# Planto — Plant Care Reminders

Planto is an iOS app that helps you remember when to water your plants. You add each plant with its room, light, watering frequency and amount of water, and Planto shows which plants need water today and sends a reminder on watering days.

Built with SwiftUI as a coding challenge at the Apple Developer Academy.

## Main Features

- **Add plants** with a name, room, light, watering frequency and water amount.
- **See today's reminders** at the top of the list. Other plants appear faded below.
- **Check off watered plants** by tapping the circle. Tap again to undo.
- **Track daily progress** with a progress bar and an "All Done!" screen.
- **Edit a plant** by tapping it.
- **Delete a plant** by swiping left or from the edit screen.
- **Get a notification** at 9:00 AM on each day a plant needs water.
- **Plants stay saved** after you close the app.

## Technologies Used

- **Swift** and **SwiftUI**
- **MVVM** architecture with an `ObservableObject` view model
- **UserNotifications** for local watering reminders
- **UserDefaults** with `Codable` for saving plants on the device
- **Liquid Glass** button styles (iOS 26)
- **Icon Composer** for the app icon

The app uses no third-party libraries.

## Getting Started

### Requirements

- Xcode 26 or later (built and tested with Xcode 27.2)
- iOS 26 or later (the deployment target, required for Liquid Glass)

### Run the App

1. Open `Planto.xcodeproj` in Xcode.
2. Choose an iPhone simulator or a connected iPhone as the run destination.
3. Press **Run** (⌘R).

The app asks for notification permission the first time you save a plant. If permission is denied, everything except the notifications still works.

## Architecture

Planto follows the **Model–View–ViewModel (MVVM)** pattern:

- **Model:** plain data types. `Plant` stores a plant's details and watering dates, and the form options are enums.
- **ViewModel:** `PlantsViewModel` holds the list of plants and handles adding, editing, deleting, checking, progress and saving.
- **View:** SwiftUI screens that display the view model's data and send user actions back to it.
- **Service:** `NotificationService` schedules and cancels local notifications.

```
Planto/
├── PlantoApp.swift                App entry point
├── Model/
│   ├── Plant.swift                Plant data and watering-date logic
│   └── PlantOptions.swift         Room, Light, WateringDays, WaterAmount
├── ViewModel/
│   └── PlantsViewModel.swift      App state and user actions
├── View/
│   ├── ContentView.swift          Splash screen, then the main screen
│   ├── SplashView.swift           Splash screen
│   ├── MyPlantsView.swift         Main screen and its states
│   ├── EmptyStateView.swift       First-launch screen
│   ├── AllDoneView.swift          "All Done!" screen
│   ├── PlantRowView.swift         One plant in the list
│   └── ReminderFormView.swift     Add and edit form
├── Service/
│   └── NotificationService.swift  Local notification scheduling
├── Assets.xcassets                Illustrations and colors
└── PlantoIcon.icon                App icon (Icon Composer)
```

## Reminder Logic

- A new plant is due on the day it is added.
- When a plant is checked, its next watering date is that day plus its chosen frequency. For example, "Every 3 days" means three days later.
- A plant that isn't checked stays due every day until it is.
- The progress bar and the "All Done!" screen count only today's reminders. On days with no reminders, the progress bar is hidden.
- The list updates when the app opens, when it returns from the background, and at midnight while it is open.

## Notifications

iOS can't repeat a notification on a custom schedule such as "every 3 days", so Planto schedules notifications in advance at 9:00 AM:

- The first notification is on the plant's next watering day. If that day has already passed, or it is today and 9:00 AM has passed, the first notification is the next morning.
- After that, the reminder repeats every morning until the plant is checked, matching the days the app shows the plant as due.
- The schedule is rebuilt whenever a plant is added, edited, deleted, checked or unchecked, and whenever the app opens. Checking a plant moves its reminders to its next watering day.

iOS allows an app at most 64 scheduled notifications. Planto shares 60 of them between all plants, so each plant's reminders cover about 60 ÷ (number of plants) days from its due date. For example, with 10 plants each plant has 6 days of reminders.

## Design

The interface follows the challenge's Sketch design: dark mode, the original plant illustrations, and exact colors, font sizes and spacing taken from the Sketch file. See [DESIGN_SPECS.md](DESIGN_SPECS.md) for the values used and the few places where the app differs from the design.

The app icon is [`Planto/PlantoIcon.icon`](Planto/PlantoIcon.icon), an Icon Composer file whose default appearance uses the dark design.

## Known Limitations

- **Notifications can run out.** If the app isn't opened for longer than a plant's reminders cover, that plant gets no more notifications until the app is opened again.
- **Very large plant lists:** with more than 60 plants, each plant gets only its next notification. With more than 64, iOS keeps only 64, so some plants get none.
- **No same-day notification after 9:00 AM.** A plant that becomes due after 9:00 AM, for example one added in the afternoon, gets its first notification the next morning.
- **The notification time is fixed.** It is always 9:00 AM and can't be changed in the app.
- **Plants are stored only on this device.** There is no iCloud sync or backup.
- **Testing was limited to the iOS Simulator:**
  - The list of scheduled notifications was checked after adding, editing, deleting, checking and unchecking plants.
  - No real 9:00 AM notification from the app was observed.
  - Nothing was tested on a physical iPhone.
  - The midnight refresh while the app stays open was not tested in real time.
