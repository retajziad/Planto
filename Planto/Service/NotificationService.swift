import Foundation
import UserNotifications

// Schedules the local watering notifications.
//
// iOS cannot repeat a notification "every 3 days at 9:00 AM" by itself,
// and the app cannot run code in the background whenever it wants.
// So we schedule the next watering days in advance, one notification per day.
// iOS keeps at most 64 waiting notifications per app, so we share 60 between the plants.
// The list is rebuilt after every change and every time the app opens.
struct NotificationService {
    let center = UNUserNotificationCenter.current()

    // Shows the iOS permission alert (iOS only shows it the first time).
    // whenAllowed runs only if the user allows notifications.
    func requestPermission(whenAllowed: @escaping () -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // The answer arrives on a background thread, so we go back to the main thread.
                DispatchQueue.main.async {
                    whenAllowed()
                }
            }
        }
    }

    // Removes all waiting notifications and schedules new ones for the given plants.
    // If the user did not allow notifications, iOS ignores the new ones and the app still works.
    func scheduleReminders(for plants: [Plant]) {
        // Start from an empty list, so there are never duplicate or outdated notifications.
        center.removeAllPendingNotificationRequests()

        if plants.isEmpty {
            return
        }

        let remindersPerPlant = max(1, 60 / plants.count)

        for plant in plants {
            let dates = reminderDates(for: plant, count: remindersPerPlant)

            for date in dates {
                let content = UNMutableNotificationContent()
                content.title = "Planto"
                content.body = "Hey! \(plant.name) in the \(plant.room.rawValue) needs \(plant.waterAmount.rawValue) of water today."
                content.sound = .default

                // The trigger needs the date split into parts (year, month, day, hour, minute).
                let dateParts = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateParts, repeats: false)

                // Every notification needs its own identifier.
                let identifier = "\(plant.id.uuidString)-\(date.timeIntervalSince1970)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }

    // The next watering days of a plant, at 9:00 AM.
    func reminderDates(for plant: Plant, count: Int) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)

        var day = plant.nextWateringDate

        // A late plant (its watering day already passed) is reminded again from today.
        if day < today {
            day = today
        }

        // If 9:00 AM already passed on that day, the first reminder is the next morning.
        let firstNineAM = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: day) ?? day
        if firstNineAM <= now {
            day = calendar.date(byAdding: .day, value: 1, to: day) ?? day
        }

        // From there, one reminder every "watering days".
        var dates: [Date] = []
        while dates.count < count {
            let nineAM = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: day) ?? day
            dates.append(nineAM)
            day = calendar.date(byAdding: .day, value: plant.wateringDays.numberOfDays, to: day) ?? day
        }
        return dates
    }
}
