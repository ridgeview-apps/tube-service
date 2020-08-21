//
// Adapted from: https://medium.com/@crystalminds/integrate-uisearchcontroller-in-ios-apps-using-swiftui-f3d31d04a93
//
import SwiftUI

public extension View {
    
    func navigationSearchBar(text: Binding<String>,
                             scopeSelection: Binding<Int> = Binding.constant(0),
                             options: [NavigationSearchBarOptionKey : Any] = [:],
                             actions: [NavigationSearchBarActionKey : NavigationSearchBarActionTask] = [:]) -> some View {
        overlay(NavigationSearchBar<EmptyView>(text: text,
                                               scopeSelection: scopeSelection,
                                               options: options,
                                               actions: actions)
                    .frame(width: 0, height: 0))
    }

    func navigationSearchBar<SearchResultsContent: View>(text: Binding<String>,
                                                         scopeSelection: Binding<Int> = Binding.constant(0),
                                                         options: [NavigationSearchBarOptionKey : Any] = [:],
                                                         actions: [NavigationSearchBarActionKey : NavigationSearchBarActionTask] = [:],
                                                         @ViewBuilder searchResultsContent: @escaping () -> SearchResultsContent) -> some View {
        overlay(NavigationSearchBar<SearchResultsContent>(text: text,
                                                          scopeSelection: scopeSelection,
                                                          options: options, actions: actions,
                                                          searchResultsContent: searchResultsContent)
                    .frame(width: 0, height: 0))
    }
}

public enum NavigationSearchBarOptionKey: Hashable, Equatable {
    case automaticallyShowsSearchBar
    case obscuresBackgroundDuringPresentation
    case hidesNavigationBarDuringPresentation
    case hidesSearchBarWhenScrolling
    case placeholder
    case showsBookmarkButton
    case scopeButtonTitles
    case searchTextFieldAccessibilityId
}

public enum NavigationSearchBarActionKey: Hashable, Equatable {
    case onCancelButtonClicked
    case onSearchButtonClicked
    case onDidBecomeActive
    case onBookmarkButtonClicked
}

public typealias NavigationSearchBarActionTask = () -> Void

fileprivate struct NavigationSearchBar<SearchResultsContent>: UIViewControllerRepresentable where SearchResultsContent : View {
    typealias UIViewControllerType = SearchControllerWrapper
    typealias OptionKey = NavigationSearchBarOptionKey
    typealias ActionKey = NavigationSearchBarActionKey
    typealias ActionTask = NavigationSearchBarActionTask

    @Binding var text: String
    @Binding var scopeSelection: Int
    
    let options: [OptionKey : Any]
    let actions: [ActionKey : ActionTask]
    let searchResultsContent: () -> SearchResultsContent?
    
    init(text: Binding<String>,
         scopeSelection: Binding<Int> = Binding.constant(0),
         options: [OptionKey : Any] = [OptionKey : Any](),
         actions: [ActionKey : ActionTask] = [ActionKey : ActionTask](),
         @ViewBuilder searchResultsContent: @escaping () -> SearchResultsContent? = { nil }) {
        self._text = text
        self._scopeSelection = scopeSelection
        self.options = options
        self.actions = actions
        self.searchResultsContent = searchResultsContent
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(representable: self)
    }
    
    func makeUIViewController(context: Context) -> SearchControllerWrapper {
        SearchControllerWrapper()
    }
    
    func updateUIViewController(_ wrapper: SearchControllerWrapper, context: Context) {
        if wrapper.searchController != context.coordinator.searchController {
            wrapper.searchController = context.coordinator.searchController
        }
        
        if let hidesSearchBarWhenScrolling = options[.hidesSearchBarWhenScrolling] as? Bool {
            wrapper.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        }
        
        if options[.automaticallyShowsSearchBar] as? Bool ?? true  {
            wrapper.navigationBarSizeToFit()
        }

        if let searchController = wrapper.searchController {
            searchController.automaticallyShowsScopeBar = true
            
            searchController.obscuresBackgroundDuringPresentation = options[.obscuresBackgroundDuringPresentation] as? Bool ?? false
            searchController.hidesNavigationBarDuringPresentation = options[.hidesNavigationBarDuringPresentation] as? Bool ?? true
            
            if let searchResultsContent = searchResultsContent(),
               let hostingController = searchController.searchResultsController as? UIHostingController<SearchResultsContent> {
                hostingController.rootView = searchResultsContent
            }
        }
        
        if let searchBar = wrapper.searchController?.searchBar {
            searchBar.text = text
            
            searchBar.placeholder = options[.placeholder] as? String
            searchBar.showsBookmarkButton = options[.showsBookmarkButton] as? Bool ?? false
            searchBar.scopeButtonTitles = options[.scopeButtonTitles] as? [String]
            
            if let searchTextFieldAccessibilityId = options[.searchTextFieldAccessibilityId] as? String {
                searchBar.searchTextField.accessibilityIdentifier =  searchTextFieldAccessibilityId
            }
            
            searchBar.selectedScopeButtonIndex = scopeSelection
        }
    }
    
    class Coordinator: NSObject, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
        let representable: NavigationSearchBar
        
        let searchController: UISearchController
        
        init(representable: NavigationSearchBar) {
            self.representable = representable
            
            var resultsController: UIViewController? = nil
            if let searchResultsContent = representable.searchResultsContent() {
                resultsController = UIHostingController(rootView: searchResultsContent)
            }
            
            self.searchController = UISearchController(searchResultsController: resultsController)
            
            super.init()
            
            self.searchController.searchResultsUpdater = self
            self.searchController.searchBar.delegate = self
        }
        
        // MARK: - UISearchResultsUpdating
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            DispatchQueue.main.async { [weak self] in self?.representable.text = text }
        }
        
        // MARK: - UISearchBarDelegate
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            guard let action = self.representable.actions[.onCancelButtonClicked] else { return }
            DispatchQueue.main.async { action() }
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let action = self.representable.actions[.onSearchButtonClicked] else { return }
            DispatchQueue.main.async { action() }
        }
        
        func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
            guard let action = self.representable.actions[.onBookmarkButtonClicked] else { return }
            DispatchQueue.main.async { action() }
        }
        
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            guard let action = self.representable.actions[.onDidBecomeActive] else { return true }
            DispatchQueue.main.async {
                action()
            }
            return true
        }
        
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            DispatchQueue.main.async { [weak self] in self?.representable.scopeSelection = selectedScope }
        }
    }
    
    final class SearchControllerWrapper: UIViewController {
        var searchController: UISearchController? {
            get {
                self.parent?.navigationItem.searchController
            }
            set {
                self.parent?.navigationItem.searchController = newValue
            }
        }
        
        var hidesSearchBarWhenScrolling: Bool {
            get {
                self.parent?.navigationItem.hidesSearchBarWhenScrolling ?? true
            }
            set {
                self.parent?.navigationItem.hidesSearchBarWhenScrolling = newValue
            }
        }
        
        func navigationBarSizeToFit() {
            self.parent?.navigationController?.navigationBar.sizeToFit()
        }
    }
}
