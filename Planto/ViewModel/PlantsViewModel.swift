import Foundation
import Combine

// Holds all the plant reminders and the logic that changes them.
// The views read from this class and call its functions.
class PlantsViewModel: ObservableObject {

    // All saved plants. Every change is saved to the device automatically.
    @Published var plants: [Plant] = [] {
        didSet {
            savePlants()
        }
    }

    // The current day. It is refreshed when the app opens and at midnight,
    // so the list always shows the right reminders.
    @Published var today = Date()

    // True after the user has saved their first plant (used to pick the empty screen).
    @Published var hasAddedPlantBefore = false

    let notifications = NotificationService()

    let plantsKey = "savedPlants"
    let hasAddedPlantKey = "hasAddedPlantBefore"

    init() {
        loadPlants()
    }

    // MARK: - Today's reminders

    // True when the plant is one of today's reminders:
    // it needs water today (or is late), or it was already watered today.
    func isTodaysReminder(_ plant: Plant) -> Bool {
        return plant.isDue(on: today) || plant.wasWatered(on: today)
    }

    // Today's reminders. The progress bar and All Done only look at these.
    var todaysPlants: [Plant] {
        var result: [Plant] = []
        for plant in plants {
            if isTodaysReminder(plant) {
                result.append(plant)
            }
        }
        return result
    }

    // Every saved plant, for the list on the main screen:
    // today's reminders first, then the plants that do not need water today.
    // Showing all of them means every plant can always be edited or deleted.
    var plantsForList: [Plant] {
        var result = todaysPlants
        for plant in plants {
            if !isTodaysReminder(plant) {
                result.append(plant)
            }
        }
        return result
    }

    // How many of today's plants are already watered.
    var completedCount: Int {
        var count = 0
        for plant in todaysPlants {
            if plant.wasWatered(on: today) {
                count += 1
            }
        }
        return count
    }

    // A number from 0 to 1 for the progress bar.
    var progress: Double {
        if todaysPlants.isEmpty {
            return 0
        }
        return Double(completedCount) / Double(todaysPlants.count)
    }

    // True when there are reminders today and all of them are completed.
    var isAllDone: Bool {
        if todaysPlants.isEmpty {
            return false
        }
        return completedCount == todaysPlants.count
    }

    // MARK: - Add, edit, delete

    func addPlant(name: String, room: Room, light: Light, wateringDays: WateringDays, waterAmount: WaterAmount) {
        let newPlant = Plant(name: name, room: room, light: light, wateringDays: wateringDays, waterAmount: waterAmount)
        plants.append(newPlant)

        hasAddedPlantBefore = true
        UserDefaults.standard.set(true, forKey: hasAddedPlantKey)

        // Ask for notification permission when the user saves a plant
        // (iOS shows the alert only once). If the user allows it, schedule the reminders.
        notifications.requestPermission {
            self.notifications.scheduleReminders(for: self.plants)
        }
    }

    func updatePlant(_ updatedPlant: Plant) {
        // firstIndex returns an Optional because the plant might not be found.
        if let index = plants.firstIndex(where: { $0.id == updatedPlant.id }) {
            plants[index] = updatedPlant
            // The frequency may have changed, so schedule the notifications again.
            notifications.scheduleReminders(for: plants)
        }
    }

    func deletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        // Scheduling again removes the notifications of the deleted plant.
        notifications.scheduleReminders(for: plants)
    }

    // MARK: - Check and uncheck

    func toggleWatered(_ plant: Plant) {
        guard let index = plants.firstIndex(where: { $0.id == plant.id }) else {
            return
        }

        if plants[index].wasWatered(on: today) {
            // Uncheck: put back the watering date from before today's check,
            // so the plant is due again and its history is not lost.
            plants[index].lastWateredDate = plants[index].previousWateredDate
        } else {
            // Check: keep the old date, then remember that it was watered now.
            // The next watering day is calculated from this new date.
            plants[index].previousWateredDate = plants[index].lastWateredDate
            plants[index].lastWateredDate = Date()
        }

        notifications.scheduleReminders(for: plants)
    }

    // MARK: - New day

    // Called when the app opens, comes back from the background, or the day changes at midnight.
    func refreshToday() {
        today = Date()

        // Top up the upcoming notifications.
        notifications.scheduleReminders(for: plants)
    }

    // MARK: - Saving and loading (UserDefaults)

    func savePlants() {
        // Turn the array of plants into JSON data and store it.
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: plantsKey)
        }
    }

    func loadPlants() {
        hasAddedPlantBefore = UserDefaults.standard.bool(forKey: hasAddedPlantKey)

        // data(forKey:) returns nil when nothing was saved yet.
        guard let data = UserDefaults.standard.data(forKey: plantsKey) else {
            return
        }

        if let savedPlants = try? JSONDecoder().decode([Plant].self, from: data) {
            plants = savedPlants
        }
    }
}
