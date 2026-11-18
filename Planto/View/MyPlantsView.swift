import SwiftUI

// The main screen. It shows one of four states:
// start (new user), no reminders (every plant was deleted), the plants list, or all done.
struct MyPlantsView: View {
    @ObservedObject var viewModel: PlantsViewModel

    // Controls the "add" sheet.
    @State private var showAddSheet = false

    // The plant the user tapped to edit. It is nil when no plant is being edited.
    @State private var plantToEdit: Plant?

    // True after the user taps the All Done screen to see the completed list again
    // (for example to uncheck a plant that was checked by mistake).
    @State private var showCompletedList = false

    // Tells us when the app comes back to the screen.
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header

                if viewModel.plants.isEmpty && !viewModel.hasAddedPlantBefore {
                    EmptyStateView(showAddSheet: $showAddSheet)
                } else if viewModel.plants.isEmpty {
                    // A returning user who deleted every plant.
                    noRemindersMessage
                } else if viewModel.isAllDone && !showCompletedList {
                    AllDoneView()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showCompletedList = true
                        }
                } else {
                    // The progress bar is only shown on days that have reminders.
                    if !viewModel.todaysPlants.isEmpty {
                        progressSection
                    }
                    plantsList
                }
            }

            // The start screen has its own button, so the + button is hidden there.
            if !viewModel.plants.isEmpty || viewModel.hasAddedPlantBefore {
                addButton
            }
        }
        .sheet(isPresented: $showAddSheet) {
            ReminderFormView(viewModel: viewModel, plantToEdit: nil)
        }
        .sheet(item: $plantToEdit) { plant in
            ReminderFormView(viewModel: viewModel, plantToEdit: plant)
        }
        .onAppear {
            // App was just opened: use today's date and top up the notifications.
            viewModel.refreshToday()
        }
        .onChange(of: scenePhase) {
            // App came back from the background (maybe on a new day).
            if scenePhase == .active {
                showCompletedList = false
                viewModel.refreshToday()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
            // iOS sends this at midnight (and when the time zone changes)
            // while the app is open, so the list moves on to the new day.
            showCompletedList = false
            viewModel.refreshToday()
        }
    }

    // MARK: - Parts of the screen

    var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .kerning(0.37)
                .foregroundStyle(.white)
                .padding(.top, 24)

            // A 1-point line. Sketch uses a lighter grey on the empty screens.
            Rectangle()
                .fill(viewModel.plants.isEmpty ? Color("HeaderDividerEmpty") : Color("HeaderDivider"))
                .frame(height: 1)
        }
        .padding(.leading, 15)
    }

    var noRemindersMessage: some View {
        Text("No reminders set yet..")
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(Color("NoRemindersText"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var progressSection: some View {
        VStack(spacing: 15) {
            Group {
                if viewModel.completedCount == 0 {
                    Text("Your plants are waiting for a sip 💦")
                } else {
                    Text("\(viewModel.completedCount) of your plants feel loved today ✨")
                }
            }
            .font(.system(size: 18))
            .kerning(0.23)
            .foregroundStyle(.white)

            ProgressView(value: viewModel.progress)
                .progressViewStyle(PlantoProgressStyle())
                .animation(.easeInOut, value: viewModel.progress)
        }
        .padding(.horizontal, 33)
        .padding(.top, 36)
        .padding(.bottom, 44)
    }

    var plantsList: some View {
        List {
            ForEach(viewModel.plantsForList) { plant in
                PlantRowView(
                    plant: plant,
                    isWatered: plant.wasWatered(on: viewModel.today),
                    isTodaysReminder: viewModel.isTodaysReminder(plant),
                    toggleAction: {
                        withAnimation {
                            viewModel.toggleWatered(plant)
                            showCompletedList = false
                        }
                    }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    plantToEdit = plant
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 15, bottom: 10, trailing: 16))
                .listRowBackground(Color.black)
                .listRowSeparatorTint(Color("RowDivider"))
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deletePlant(plant)
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    // Liquid Glass: a green glass circle button.
    var addButton: some View {
        Button {
            showAddSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 17, weight: .medium))
                .frame(width: 30, height: 30)
        }
        .accessibilityLabel("Add Reminder")
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(Color("ButtonGreen"))
        .padding(.trailing, 30)
        .padding(.bottom, 7)
    }
}

// Draws the ProgressView like the Sketch design:
// a dark 8-point track with a green bar on top that grows with the progress.
struct PlantoProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        // fractionCompleted is a number from 0 to 1 (nil when unknown).
        let progress = configuration.fractionCompleted ?? 0

        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color("ProgressTrack"))
                Capsule()
                    .fill(Color("ButtonGreen"))
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 8)
    }
}

#Preview {
    MyPlantsView(viewModel: PlantsViewModel())
        .preferredColorScheme(.dark)
}
