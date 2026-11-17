import Foundation
import UserNotifications

// Schedules the local watering notifications.
//
// iOS cannot repeat a notification "every 3 days at 9:00 AM" by itself,
// so we schedule the next watering days one by one, as separate notifications.
// iOS keeps at most 64 waiting notifications per app, so we share 60 between the plants.
// The list is rebuilt after every change and every time the app opens.
struct NotificationService {
    let center = UNUserNotificationCenter.current()

    // Removes all waiting notifications and schedules new ones for the given plants.
    // Called after adding, editing, deleting, checking and unchecking.
    func scheduleReminders(for plants: [Plant]) {
        if plants.isEmpty {
            center.removeAllPendingNotificationRequests()
            return
        }

        // Asks for permission. iOS only shows the alert the first time.
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted == false {
                return
            }

            center.removeAllPendingNotificationRequests()

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
    }

    // The next watering days of a plant, at 9:00 AM.
    // It starts at the next watering day and jumps forward by the watering frequency.
    // Times that already passed are skipped.
    func reminderDates(for plant: Plant, count: Int) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        var dates: [Date] = []
        var day = plant.nextWateringDate

        while dates.count < count {
            let nineAM = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: day) ?? day
            if nineAM > now {
                dates.append(nineAM)
            }
            day = calendar.date(byAdding: .day, value: plant.wateringDays.numberOfDays, to: day) ?? now
        }

        return dates
    }
}
