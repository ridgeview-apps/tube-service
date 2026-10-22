import SwiftUI

/// A settings-style row: title leading, with the current value trailing as a menu.
///
/// Only the value is the menu's label, so the menu grows out of the value and the title stays visible
/// while it's open. The value's tap target is 44pt tall and extends left of the text, so it isn't fiddly.
/// The row stacks vertically at accessibility sizes so neither side truncates.
struct ScheduleMenuRow<MenuItems: View>: View {
    let title: LocalizedStringResource
    let value: String
    /// Secondary text under the value, e.g. the times of a time slot.
    var detail: String?
    @ViewBuilder let menuItems: () -> MenuItems

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        let isStacked = dynamicTypeSize.isAccessibilitySize
        let layout =
            isStacked
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 0))
            : AnyLayout(HStackLayout(alignment: .firstTextBaseline, spacing: 8))

        layout {
            Text(title)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                // The menu carries this as its accessibility label.
                .accessibilityHidden(true)

            VStack(alignment: isStacked ? .leading : .trailing, spacing: 0) {
                Menu {
                    menuItems()
                } label: {
                    valueLabel
                        // Widens the tap target into the row's empty middle; not needed when stacked.
                        .padding(.leading, isStacked ? 0 : 24)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel(Text(title))
                .accessibilityValue([value, detail].compactMap { $0 }.joined(separator: ", "))

                if let detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(isStacked ? .leading : .trailing)
                        // Tucks up under the value text, into the spare bottom of its 44pt tap target.
                        // Accessibility sizes fill that target, so there's nothing to tuck into.
                        .padding(.top, isStacked ? 0 : -10)
                        .padding(.bottom, 4)
                        // Read as part of the menu's value instead.
                        .accessibilityHidden(true)
                }
            }
            // The short title gives up width first, so the value and detail can stay on one line.
            .layoutPriority(1)
        }
    }

    private var valueLabel: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(value)
                .multilineTextAlignment(dynamicTypeSize.isAccessibilitySize ? .leading : .trailing)
            Image(systemName: "chevron.up.chevron.down")
                .font(.caption.weight(.semibold))
        }
        .font(.subheadline)
        .foregroundStyle(Color.accentColor)
    }
}
