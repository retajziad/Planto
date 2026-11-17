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
        HStack(spacing: 22) {
            Button {
                toggleAction()
            } label: {
                Image(systemName: isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 26))
                    .foregroundStyle(isWatered ? Color("CheckGreen") : Color.gray)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isWatered ? "Mark as not watered" : "Mark as watered")

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "location")
                    Text("in \(plant.room.rawValue)")
                }
                .font(.subheadline)
                .foregroundStyle(.gray)

                Text(plant.name)
                    .font(.system(size: 28))
                    .foregroundStyle(isWatered ? Color.gray : Color.white)

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: plant.light.iconName)
                        Text(plant.light.rawValue)
                    }
                    .font(.footnote)
                    .foregroundStyle(Color("SunYellow"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color("ChipBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    HStack(spacing: 4) {
                        Image(systemName: "drop")
                        Text(plant.waterAmount.rawValue)
                    }
                    .font(.footnote)
                    .foregroundStyle(Color("WaterBlue"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color("ChipBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            Spacer()
        }
        .padding(.vertical, 6)
        .opacity(rowOpacity)
    }

    var rowOpacity: Double {
        if !isTodaysReminder {
            return 0.5
        }
        if isWatered {
            return 0.8
        }
        return 1
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
