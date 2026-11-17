# Planto 🌱 — Plant Care Reminders

A SwiftUI app for the Apple Developer Academy coding challenge.
Add your plants, see which ones need water today, check them off, and get a local notification on watering days.

## Requirements

- Xcode 26 or newer
- iOS 26 or newer (needed for the Liquid Glass buttons)

## How to run

1. Open `Planto.xcodeproj` in Xcode.
2. Pick an iPhone simulator at the top of the window (for example iPhone 17).
3. Press **Run** (⌘R).

## Project structure (MVVM)

```
Planto/
├── PlantoApp.swift              App entry point
├── Model/
│   ├── Plant.swift              The Plant struct and its watering-date logic
│   └── PlantOptions.swift       Enums: Room, Light, WateringDays, WaterAmount
├── ViewModel/
│   └── PlantsViewModel.swift    Add, edit, delete, check, progress, saving
├── View/
│   ├── ContentView.swift        Shows the splash, then the main screen
│   ├── SplashView.swift         Splash screen
│   ├── MyPlantsView.swift       Main screen with all its states
│   ├── EmptyStateView.swift     "Start your plant journey!" screen
│   ├── AllDoneView.swift        "All Done!" screen
│   ├── PlantRowView.swift       One row in the reminders list
│   └── ReminderFormView.swift   Set Reminder sheet (add and edit)
├── Service/
│   └── NotificationService.swift  Schedules and cancels local notifications
└── Assets.xcassets              App icon, illustrations, colors
```

## How the reminders work

- A new plant is due on the day it is added.
- Checking a plant saves today's date as its last watering. The next watering day is that date plus the chosen frequency (for example "Every 3 days" = 3 days later).
- The main screen shows the plants that are due today (or overdue) and the ones already watered today.
- Unchecking a plant puts back its previous watering date, so it is due again and its schedule is not lost.
- "All Done" shows only when there are reminders today and all of them are checked. Tap the All Done screen to see the completed list again and uncheck a plant checked by mistake.
- When plants exist but none needs water today, the screen shows "No reminders set yet..".
- Plants are saved on the device with UserDefaults, so they are still there after closing the app.

## How the notifications work

- iOS cannot repeat a notification "every 3 days at 9:00 AM" on its own, so the app schedules the next watering days one by one, each at 9:00 AM.
- iOS keeps at most 64 waiting notifications per app. The app shares 60 between the plants (1 plant = its next 60 waterings, 2 plants = 30 each, and so on).
- The list is rebuilt after every add, edit, delete, check and uncheck, and every time the app opens.
