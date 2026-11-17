import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image("PlantHappy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)

                Text("Planto")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.white)

                Text("Plant Care reminders 🌿")
                    .font(.title3)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    SplashView()
}
