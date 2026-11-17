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
- The main list shows every saved plant, so any plant can be edited or deleted at any time. Today's reminders (due, late, or already watered today) come first; plants that do not need water today are shown faded below them.
- The progress bar and "All Done" only count today's reminders. A plant can also be watered early: checking it counts as today's care and moves its next watering date.
- Unchecking a plant puts back its previous watering date, so it is due again and its schedule is not lost.
- "All Done" shows only when there are reminders today and all of them are checked. Tap the All Done screen to see the list again and uncheck a plant checked by mistake.
- The progress bar is hidden on days with no reminders. After every plant is deleted, the screen shows "No reminders set yet..".
- The day is refreshed when the app opens, when it comes back from the background, and at midnight while it is open.
- Plants are saved on the device with UserDefaults, so they are still there after closing the app.

## How the notifications work

- The app asks for notification permission when the user saves a plant. If the user says no, the app still works normally.
- iOS cannot repeat a notification "every 3 days at 9:00 AM" on its own, and an app cannot run code in the background whenever it wants. So the app schedules the next watering days in advance, one notification per watering day at 9:00 AM.
- iOS keeps at most 64 waiting notifications per app. The app shares 60 between the plants (1 plant = its next 60 waterings, 2 plants = 30 each, and so on).
- The whole list is removed and rebuilt after every add, edit, delete, check and uncheck, and every time the app opens, so there are no duplicate or outdated notifications.
- If a plant's watering day has passed (or 9:00 AM today already passed), its next reminder is the next 9:00 AM.
- Limit: with many plants and long gaps without opening the app, the scheduled reminders can run out (for example 10 daily plants = 6 days ahead). Opening the app fills them up again.
