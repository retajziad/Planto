import SwiftUI

// The main screen. It shows one of four states:
// start (new user), no reminders today, the reminders list, or all done.
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
                } else if viewModel.todaysPlants.isEmpty {
                    // No plants at all, or no plant needs water today.
                    noRemindersMessage
                } else if viewModel.isAllDone && !showCompletedList {
                    AllDoneView()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showCompletedList = true
                        }
                } else {
                    progressSection
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
    }

    // MARK: - Parts of the screen

    var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 24)

            Divider()
                .overlay(Color.white.opacity(0.3))
        }
        .padding(.leading, 16)
    }

    var noRemindersMessage: some View {
        Text("No reminders set yet..")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var progressSection: some View {
        VStack(spacing: 14) {
            if viewModel.completedCount == 0 {
                Text("Your plants are waiting for a sip 💦")
                    .foregroundStyle(.white)
            } else {
                Text("\(viewModel.completedCount) of your plants feel loved today ✨")
                    .foregroundStyle(.white)
            }

            ProgressView(value: viewModel.progress)
                .tint(Color("ButtonGreen"))
                .scaleEffect(x: 1, y: 2)
                .animation(.easeInOut, value: viewModel.progress)
        }
        .padding(.horizontal, 28)
        .padding(.top, 36)
        .padding(.bottom, 28)
    }

    var plantsList: some View {
        List {
            ForEach(viewModel.todaysPlants) { plant in
                PlantRowView(
                    plant: plant,
                    isWatered: plant.wasWatered(on: viewModel.today),
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
                .listRowBackground(Color.black)
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
                .font(.title2)
                .frame(width: 32, height: 40)
        }
        .accessibilityLabel("Add Reminder")
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(Color("ButtonGreen"))
        .padding(.trailing, 28)
        .padding(.bottom, 16)
    }
}

#Preview {
    MyPlantsView(viewModel: PlantsViewModel())
        .preferredColorScheme(.dark)
}
