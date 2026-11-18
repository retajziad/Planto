import SwiftUI

// Shown to a new user who has not added any plant yet.
struct EmptyStateView: View {
    // A binding, so this view can open the sheet that MyPlantsView owns.
    @Binding var showAddSheet: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image("PlantHappy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 164)
                    .padding(.top, 77)

                Text("Start your plant journey!")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 37)

                Text("Now all your plants will be in one place and\nwe will help you take care of them :)🪴")
                    .font(.system(size: 16))
                    .foregroundStyle(Color("SecondaryText").opacity(0.7))
                    .multilineTextAlignment(.center)
                    .frame(width: 315)
                    .padding(.top, 25)

                // Liquid Glass: a green glass capsule button.
                Button {
                    showAddSheet = true
                } label: {
                    Text("Set Plant Reminder")
                        .font(.system(size: 17, weight: .medium))
                        .frame(width: 256, height: 28)
                }
                .buttonStyle(.glassProminent)
                .tint(Color("ButtonGreen"))
                .padding(.top, 105)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    EmptyStateView(showAddSheet: .constant(false))
        .preferredColorScheme(.dark)
}
