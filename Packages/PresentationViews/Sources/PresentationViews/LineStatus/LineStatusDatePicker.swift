import SwiftUI

struct LineStatusDatePicker: View {
    
    @Binding var selectedDate: Date?
    
    @State private var isExpanded = false
    @State private var selectedDateInternal: Date = .now
    
    
    var body: some View {
        VStack {

            Button {
                isExpanded.toggle()
            } label: {
                HStack {
                    if let selectedDate {
                        Text(selectedDate.formatted(date: .complete, time: .omitted))
                    } else {
                        Text("inline.date.picker.select.date.title", bundle: .module)
                    }
                    Spacer()
                    Image(systemName: "arrowtriangle.down.circle")
                        .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                }
                .padding(.vertical)
                
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
            .animation(nil, value: selectedDate)
            .animation(.default, value: isExpanded)
            
            
            if isExpanded {
                DatePicker("",
                           selection: $selectedDateInternal,
                           in: Date.now...,
                           displayedComponents: [.date])
                .datePickerStyle(.graphical)
            }
       
        }
        .animation(.smooth, value: isExpanded)
        .onChange(of: selectedDateInternal) { newValue in
            selectedDate = newValue
            isExpanded = false
        }        
    }
}


// MARK: - Previews

private struct WrapperView: View {
    @State var selectedDate: Date?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    LineStatusDatePicker(selectedDate: $selectedDate)
                    ForEach((1...20), id: \.self) {
                        Text("List item \($0)")
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Preview")
        }
    }
}
#Preview {
    WrapperView()
}
