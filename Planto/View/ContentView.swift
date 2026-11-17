import SwiftUI

// The first view of the app.
// It shows the splash for a moment, then the main screen.
struct ContentView: View {
    @StateObject private var viewModel = PlantsViewModel()
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
            } else {
                MyPlantsView(viewModel: viewModel)
            }
        }
        .onAppear {
            // Hide the splash after 1.5 seconds.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
