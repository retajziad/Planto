import SwiftUI

// The Set Reminder sheet. The same view is used for adding and editing:
// - plantToEdit is nil     -> add a new plant
// - plantToEdit has a plant -> edit (or delete) that plant
struct ReminderFormView: View {
    @ObservedObject var viewModel: PlantsViewModel
    let plantToEdit: Plant?

    // Closes the sheet.
    @Environment(\.dismiss) private var dismiss

    // What the user types and picks in the form.
    @State private var name = ""
    @State private var room = Room.bedroom
    @State private var light = Light.fullSun
    @State private var wateringDays = WateringDays.everyDay
    @State private var waterAmount = WaterAmount.ml20to50

    // The name without spaces at the start and end.
    var trimmedName: String {
        return name.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Plant Name")
                        // prompt is the grey placeholder text shown while the field is empty.
                        TextField("Plant Name", text: $name, prompt: Text("Pothos").foregroundStyle(Color("PlaceholderText")))
                            .font(.system(size: 17))
                            .tint(Color("CheckGreen"))
                    }
                    // The name card is taller than the other rows in Sketch (59 points).
                    .padding(.vertical, 6)
                }

                Section {
                    Picker(selection: $room) {
                        ForEach(Room.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    } label: {
                        Label("Room", systemImage: "location")
                            .foregroundStyle(.white)
                    }

                    Picker(selection: $light) {
                        ForEach(Light.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    } label: {
                        Label("Light", systemImage: "sun.max")
                            .foregroundStyle(.white)
                    }
                }

                Section {
                    Picker(selection: $wateringDays) {
                        ForEach(WateringDays.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    } label: {
                        Label("Watering Days", systemImage: "drop")
                            .foregroundStyle(.white)
                    }

                    Picker(selection: $waterAmount) {
                        ForEach(WaterAmount.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    } label: {
                        Label("Water", systemImage: "drop")
                            .foregroundStyle(.white)
                    }
                }

                // The delete button only exists when editing.
                if let plantToEdit {
                    Section {
                        Button("Delete Reminder", role: .destructive) {
                            viewModel.deletePlant(plantToEdit)
                            dismiss()
                        }
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .font(.system(size: 18))
            .listRowSeparatorTint(Color("FormDivider"))
            // Space between the cards and row height, from the Sketch layout.
            .listSectionSpacing(40)
            .environment(\.defaultMinListRowHeight, 47)
            .tint(.gray)
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Toolbar buttons get the Liquid Glass look from the system.
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark") {
                        save()
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color("ButtonGreen"))
                    .disabled(trimmedName.isEmpty)
                }
            }
        }
        .onAppear {
            // When editing, start the form with the saved values.
            if let plantToEdit {
                name = plantToEdit.name
                room = plantToEdit.room
                light = plantToEdit.light
                wateringDays = plantToEdit.wateringDays
                waterAmount = plantToEdit.waterAmount
            }
        }
    }

    func save() {
        if var plant = plantToEdit {
            // Edit: change the copy, then give it back to the view model.
            plant.name = trimmedName
            plant.room = room
            plant.light = light
            plant.wateringDays = wateringDays
            plant.waterAmount = waterAmount
            viewModel.updatePlant(plant)
        } else {
            // Add: create a new plant.
            viewModel.addPlant(name: trimmedName, room: room, light: light, wateringDays: wateringDays, waterAmount: waterAmount)
        }
        dismiss()
    }
}

#Preview {
    ReminderFormView(viewModel: PlantsViewModel(), plantToEdit: nil)
        .preferredColorScheme(.dark)
}
