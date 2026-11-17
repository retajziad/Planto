import SwiftUI

// Shown when every reminder for today is completed.
struct AllDoneView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image("PlantWink")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 219)
                    .padding(.top, 127)

                Text("All Done! 🎉")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 36)

                Text("All Reminders Completed")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding(.top, 16)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    AllDoneView()
        .preferredColorScheme(.dark)
}
