import SwiftUI

// One row in the reminders list.
struct PlantRowView: View {
    let plant: Plant
    let isWatered: Bool

    // False for plants that do not need water today. They are shown faded.
    let isTodaysReminder: Bool

    // What to do when the circle is tapped. The row itself does not change data.
    let toggleAction: () -> Void

    var body: some View {
        HStack(spacing: 23) {
            Button {
                toggleAction()
            } label: {
                Image(systemName: isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 25))
                    .foregroundStyle(isWatered ? Color("CheckGreen") : Color("CircleGray"))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isWatered ? "Mark as not watered" : "Mark as watered")

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Image(systemName: "location")
                    Text("in \(plant.room.rawValue)")
                }
                .font(.system(size: 15))
                .kerning(-0.24)
                .foregroundStyle(Color.white.opacity(0.5))

                Text(plant.name)
                    .font(.system(size: 28))
                    .kerning(0.36)
                    .foregroundStyle(isWatered ? Color("CompletedName") : Color.white)
                    .padding(.top, 4)

                HStack(spacing: 13) {
                    HStack(spacing: 4) {
                        Image(systemName: plant.light.iconName)
                        Text(plant.light.rawValue)
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color("SunYellow"))
                    .opacity(isWatered ? 0.68 : 1)
                    .padding(.horizontal, 9)
                    .frame(height: 23)
                    .background(Color("ChipBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    HStack(spacing: 4) {
                        Image(systemName: "drop")
                        Text(plant.waterAmount.rawValue)
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color("WaterBlue"))
                    .padding(.horizontal, 9)
                    .frame(height: 23)
                    .background(Color("ChipBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.top, 7)
            }

            Spacer()
        }
        // Start the line between rows under the circle, like in Sketch (not under the text).
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        // Plants that do not need water today are faded (not part of the Sketch design,
        // it only marks plants outside today's reminders).
        .opacity(isTodaysReminder ? 1 : 0.5)
    }
}

#Preview {
    PlantRowView(
        plant: Plant(name: "Monstera", room: .kitchen, light: .fullSun, wateringDays: .everyDay, waterAmount: .ml20to50),
        isWatered: false,
        isTodaysReminder: true,
        toggleAction: {}
    )
    .preferredColorScheme(.dark)
}
