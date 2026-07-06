import Models
import SwiftUI

public struct LineNotificationSetupView: View {

    public enum Action {
        case done(items: [LineNotificationSettings])
    }

    private let initialItems: [LineNotificationSettings]
    private let onAction: (Action) -> Void

    @State private var items: [LineNotificationSettings]
    @State private var scrollTarget: TrainLineID?

    public init(
        initialItems: [LineNotificationSettings],
        onAction: @escaping (Action) -> Void
    ) {
        self.initialItems = initialItems
        self.onAction = onAction
        _items = State(initialValue: initialItems)
    }

    public var body: some View {
        ScrollViewReader { proxy in
            List {
                lineItemsSection
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .onChange(of: scrollTarget) { _, id in
                guard let id else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(id, anchor: .bottom)
                }
                scrollTarget = nil
            }
        }
        .safeAreaInset(edge: .bottom) {
            pinnedDoneButton
        }
        .navigationTitle(Text(.notificationsManageNavigationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Computed Properties

    private var unaddedLineIDs: [TrainLineID] {
        let addedIDs = Set(items.map(\.lineID))
        return TrainLineID.allCases
            .filter { !addedIDs.contains($0) }
            .sorted { $0.name < $1.name }
    }

    // MARK: - Line Items Section

    @ViewBuilder
    private var lineItemsSection: some View {
        ForEach($items) { $item in
            LineScheduleCard(settings: $item)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
        }
        .onDelete { indexSet in
            items.remove(atOffsets: indexSet)
        }

        if !unaddedLineIDs.isEmpty {
            addLineRow
        }
        #if DEBUG
            debugAddAllRow
        #endif
    }

    // MARK: - Pinned Done Button

    private var pinnedDoneButton: some View {
        Button {
            onAction(.done(items: items))
        } label: {
            Text(.globalDone)
                .font(.body)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.tint, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(.white)
        }
        .disabled(items.isEmpty)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .background(.regularMaterial)
    }

    // MARK: - Add Line

    private var addLineRow: some View {
        AddLineMenu(
            lineIDs: unaddedLineIDs,
            label: addLineButtonText,
            onSelect: { lineID in
                items.append(.defaultValue(lineID: lineID))
                scrollTarget = lineID
            }
        )
        .dashedCardStyle()
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
    }

    private var addLineButtonText: LocalizedStringResource {
        items.isEmpty ? .notificationsManageAddLineButton : .notificationsManageAddOtherLineButton
    }

    #if DEBUG
        private var debugAddAllRow: some View {
            Menu {
                if unaddedLineIDs.count > 1 {
                    Button("Add all lines") {
                        for lineID in unaddedLineIDs {
                            items.append(.defaultValue(lineID: lineID))
                        }
                        scrollTarget = unaddedLineIDs.last
                    }
                    Button("Add all lines (anytime)") {
                        for lineID in unaddedLineIDs {
                            items.append(.defaultValue(lineID: lineID, schedulePreset: .anytime))
                        }
                        scrollTarget = unaddedLineIDs.last
                    }
                }
            } label: {
                Text("Debug: Add lines")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 4, trailing: 20))
        }
    #endif
}


// MARK: - Previews

#if DEBUG
    #Preview("Onboarding") {
        NavigationStack {
            LineNotificationSetupView(
                initialItems: [.victoria].map { .defaultValue(lineID: $0) }
            ) { _ in }
        }
    }

    #Preview("Onboarding - Empty") {
        NavigationStack {
            LineNotificationSetupView(
                initialItems: []
            ) { _ in }
        }
    }
#endif
