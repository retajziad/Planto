import Foundation

// One plant reminder.
// Identifiable lets SwiftUI lists tell plants apart.
// Codable lets us save the plant to the device and load it again.
struct Plant: Identifiable, Codable {
    var id = UUID()
    var name: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var waterAmount: WaterAmount

    // The day the reminder was created. A new plant is due on this day.
    var dateAdded = Date()

    // The last time the user checked this plant as watered.
    // It is nil when the plant has not been watered yet.
    var lastWateredDate: Date?

    // The watering before the last one. It is kept so that unchecking
    // today's watering can put the old date back.
    var previousWateredDate: Date?

    // The day (at midnight) this plant should be watered next.
    var nextWateringDate: Date {
        let calendar = Calendar.current

        // Never watered: it is due from the day it was added.
        guard let lastWateredDate else {
            return calendar.startOfDay(for: dateAdded)
        }

        // Watered before: add the watering frequency to the last watering day.
        let lastWateredDay = calendar.startOfDay(for: lastWateredDate)
        let nextDay = calendar.date(byAdding: .day, value: wateringDays.numberOfDays, to: lastWateredDay)
        return nextDay ?? lastWateredDay
    }

    // True when the plant was checked as watered on the given day.
    func wasWatered(on day: Date) -> Bool {
        guard let lastWateredDate else {
            return false
        }
        return Calendar.current.isDate(lastWateredDate, inSameDayAs: day)
    }

    // True when the plant needs water on the given day (or is overdue).
    func isDue(on day: Date) -> Bool {
        return Calendar.current.startOfDay(for: day) >= nextWateringDate
    }
}
