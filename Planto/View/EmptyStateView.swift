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
                    .padding(.top, 71)

                Text("Start your plant journey!")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 41)

                Text("Now all your plants will be in one place and\nwe will help you take care of them :)🪴")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 22)

                // Liquid Glass: a green glass capsule button.
                Button {
                    showAddSheet = true
                } label: {
                    Text("Set Plant Reminder")
                        .font(.headline)
                        .frame(width: 240, height: 28)
                }
                .buttonStyle(.glassProminent)
                .tint(Color("ButtonGreen"))
                .padding(.top, 100)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    EmptyStateView(showAddSheet: .constant(false))
        .preferredColorScheme(.dark)
}
