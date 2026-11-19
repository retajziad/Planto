# Planto — Design System & Implementation Notes

## 1. Overview

This document connects Planto's Sketch design with its SwiftUI implementation. It covers the design values, the components built from them, and the places where the app uses native iOS styling instead of the mockup.

**Source.** Design values come from the layer data of the original high-fidelity Sketch design, whose artboards are 428 × 926 pt. Implementation values refer to an iPhone 18 Pro, which is 402 pt wide.

**Design principles**

- **Dark only.** The design has no light mode, so the app always runs in dark appearance.
- **System font.** All text uses the native iOS system font (SF Pro), so no custom fonts are bundled.
- **Native components.** Lists, forms, sheets and Liquid Glass buttons are standard SwiftUI components styled with Planto's colors, so they behave like the rest of iOS.
- **One brand green.** `#338069` is used for every primary action and for progress.

**Notation.** Values are exact unless marked **≈**, which means approximate or varying between artboards. "Sketch" refers to the design file and "SwiftUI" to the code.

## 2. Color Palette

### Brand and content colors

These are stored as color assets in `Assets.xcassets`. Each has a single value, with no separate light and dark variants.

| Asset | Hex | Opacity | Use |
|---|---|---|---|
| `ButtonGreen` | `#338069` | 100% | Primary buttons, Save button, + button, progress fill |
| `CheckGreen` | `#28E0A8` | 100% | Completed check, text cursor |
| `AccentColor` | `#28E0A8` | 100% | App accent color |
| `ProgressTrack` | `#262626` | 100% | Progress bar track |
| `CircleGray` | `#979797` | 100% | Unchecked circle |
| `CompletedName` | `#989898` | 100% | Plant name after watering |
| `SunYellow` | `#CCC785` | 100%, 68% when watered | Light chip text and icon |
| `WaterBlue` | `#CAF3FB` | 100% | Water chip text and icon |
| `ChipBackground` | `#18181D` | 100% | Chip background |
| `SecondaryText` | `#9F9F91` | 70% (applied in code) | Body text on Empty State and All Done |
| `NoRemindersText` | `#756F6F` | 100% | "No reminders set yet.." |
| `PlaceholderText` | `#666666` | 100% | Name field placeholder ("Pothos") |
| `HeaderDividerEmpty` | `#39393B` | 100% | Header divider when there are no plants |
| `HeaderDivider` | `#181819` | 100% | Header divider when plants exist |
| `RowDivider` | `#222224` | 100% | Plant list separators |
| `FormDivider` | `#414144` | 100% | Set Reminder row separators |

### System colors

These Sketch colors come from SwiftUI or iOS in dark mode, so they aren't stored as assets.

| Element | Hex | Provided by |
|---|---|---|
| Screen background | `#000000` | `Color.black` |
| Primary text | `#FFFFFF` | `.white` |
| Room text | `#FFFFFF` at 50% | `Color.white.opacity(0.5)` |
| Set Reminder sheet background | `#1C1C1E` | iOS grouped background (dark) |
| Form card background | `#2C2C2E` | iOS grouped cell background (dark) |
| Form values and chevrons | `#8E8E93` | `.tint(.gray)` on the form |
| "Delete Reminder" | `#FF453A` | Destructive button role (dark) |

**Notes**

- **Two greens:** `#338069` fills buttons and the progress bar. `#28E0A8` is used only for small accents: the completed check and the text cursor.
- **Cursor:** Sketch uses `#29DFA8`. The app reuses `CheckGreen` (`#28E0A8`), which is one unit away, instead of adding a near-duplicate color.
- **All Done backdrop:** the oval behind the All Done illustration (`#14141A` at 58%) is part of `PlantWink.svg`, not a separate color.

## 3. Typography

All text uses the native iOS system font (SF Pro). Most styles set an explicit size and weight with `.system(size:weight:)`, matching Sketch. The splash subtitle uses the semantic `.title3` style, and the "Set Reminder" title is the standard inline navigation title. Kerning follows Sketch, rounded to two decimals.

| Style | Weight | Size | Kerning (Sketch → SwiftUI) | Color | Alignment |
|---|---|---|---|---|---|
| Screen title "My Plants 🌱" | Bold | 34 | 0.374 → 0.37 | White | Leading |
| Screen heading ("Start your plant journey!", "All Done! 🎉") | Semibold | 25 | 0 | White | Center |
| Body (Empty State, All Done) | Regular | 16 | 0 | `SecondaryText` 70% | Center |
| "No reminders set yet.." | Semibold | 20 | 0 | `NoRemindersText` | Center |
| Progress message | Regular | 18 | 0.234 → 0.23 | White | Center |
| Room ("in Kitchen") | Regular | 15 | −0.24 | White 50% | Leading |
| Plant name | Regular | 28 | 0.364 → 0.36 | White / `CompletedName` | Leading |
| Light chip | Regular | 14 | 0 | `SunYellow` | Leading |
| Water chip | Medium | 14 | 0 | `WaterBlue` | Leading |
| Button label ("Set Plant Reminder", + symbol) | Medium | 17 | — | White | Center |
| Sheet title "Set Reminder" | Semibold | 17 | — | White | Center |
| Form labels and values | Regular | 18 | Sketch −0.455; not applied | White / gray | Leading / trailing |
| Name field and placeholder | Regular | 17 | 0 | White / `PlaceholderText` | Leading |
| "Delete Reminder" | Regular | 17 | — | `#FF453A` | Center |

**Notes**

- **Line height:** Sketch leaves it unset on most layers. It is fixed at 22 pt on form rows and 16 pt on the water chip. The app uses system line heights everywhere.
- **Chip weights:** as in Sketch, the water chip is Medium and the light chip is Regular.
- **Form text:** the Sketch Light label is 17 pt and the other form labels are 18 pt. The app uses 18 pt for all form rows.
- **"Plant Name" font:** in Sketch this label uses Helvetica 18. The app uses SF Pro like every other label.

## 4. Layout & Spacing

All values are in points. Horizontal margins are fixed, and centered content stays centered on narrower screens.

### Header (all main screens)

| Element | Sketch | SwiftUI |
|---|---|---|
| Title position | x 16, y 83 | Leading 15, shared with the divider |
| Title to divider | 20 | `VStack(spacing: 20)` |
| Divider | 1 pt, x 15 to the right edge, y 143 | 1 pt `Rectangle`, leading 15, full width |

### Empty State

| Element | Value |
|---|---|
| Illustration | 164 × 200, centered, 77 below the divider |
| Illustration → heading | 37 |
| Heading → body | 25 |
| Body width | 315 |
| Body → button | 105 |
| "Set Plant Reminder" button | 280 × 42 |

### My Plants

| Element | Sketch | SwiftUI |
|---|---|---|
| Divider → progress message | ≈34–38 (differs between artboards) | 36 |
| Message → bar | 15 | 15 |
| Progress bar | 361 × 8, ≈33 side margins | Full width minus 33 on each side, 8 tall |
| Bar → first row | ≈60 | 44 + 16 row inset = 60 |
| Row insets | — | Top 16, leading 15, bottom 10, trailing 16 |
| Row height | ≈111–113 | Set by content and insets |
| Check circle | 23 × 23 at x 15 | SF Symbol at 25 pt, leading 15 |
| Circle → text | Text at x 65–67 | 23 spacing (text at ≈67.7) |
| Room → name | ≈4–5 | 4 |
| Name → chips | 7 | 7 |
| + button | 44 × 44, 30 from the right edge | 44 × 44, trailing 30, bottom 7 |

### All Done

| Element | Value |
|---|---|
| Illustration | 219 × 227, 127 below the divider |
| Illustration → title | 33 |
| Title → subtitle | 14 |

### Set Reminder

| Element | Sketch | SwiftUI |
|---|---|---|
| Card width | 388 | System inset grouped width |
| Name card height | 59 | ≈59 (47 minimum row height + 6 top and bottom padding) |
| Two-row card height | ≈95–98 | Two rows, 47 minimum each |
| Gap between cards | ≈50 / 40 | 40 (`listSectionSpacing`) |
| "Delete Reminder" card | 85 below the last card | 40 below, same as other sections |

## 5. UI Components & States

### Primary button — "Set Plant Reminder"

- **Visual:** 280 × 42 Liquid Glass Prominent capsule, tinted `ButtonGreen`, with a 17 pt Medium white label.
- **SwiftUI:** `.buttonStyle(.glassProminent)` with a 256 × 28 label frame. The glass style adds its own padding, which brings the button to 280 × 42.

### Add button (+)

- **Visual:** 44 × 44 Liquid Glass circle in `ButtonGreen` with a 17 pt Medium plus symbol, floating at the bottom right of every main screen except the first-launch Empty State.
- **SwiftUI:** a 30 × 30 symbol frame with `.glassProminent` and `.buttonBorderShape(.circle)`, which renders at 44 × 44. Its accessibility label is "Add Reminder".

### Progress bar

- **Visual:** an 8 pt capsule (corner radius 4) with a `ProgressTrack` track and a `ButtonGreen` fill.
- **SwiftUI:** a custom `PlantoProgressStyle`, because the default `ProgressView` doesn't let you set the track color or the bar height. The fill animates with ease-in-out when a plant is checked.
- **Message:** "Your plants are waiting for a sip 💦" when none of today's plants are watered, and "N of your plants feel loved today ✨" once at least one is.
- **Visibility:** hidden on days with no reminders.

### Plant row

The row has a check control on the left, then three lines: room, plant name, and the chips. Tapping the circle checks the plant, and tapping anywhere else in the row opens it for editing.

| State | Check | Name | Light chip | Water chip | Row |
|---|---|---|---|---|---|
| Due today | `circle`, `CircleGray` | White | 100% | 100% | 100% |
| Watered today | `checkmark.circle.fill`, `CheckGreen` | `CompletedName` | 68% | 100% | 100% |
| Not due today | `circle`, `CircleGray` | White | 100% | 100% | 50% |

- **Order:** today's reminders are listed first, then plants that are not due.
- **Separators:** 1 pt `RowDivider`, starting under the check circle as in Sketch rather than under the text.
- **Delete:** swiping left shows a delete action with an icon only.

### Chips

| Property | Value |
|---|---|
| Height | 23 |
| Corner radius | 8 |
| Horizontal padding | 9 |
| Icon → text | 4 |
| Gap between chips | 13 |
| Background | `ChipBackground` |
| Light icons | `sun.max` (Full Sun), `sun.horizon` (Partial Sun), `moon` (Low Light) |
| Water icon | `drop` |

### Set Reminder sheet

- **Shared screen:** the same sheet is used to add and to edit a plant. Its title is "Set Reminder", inline.
- **Toolbar:**
  - **Cancel:** an `xmark` glass button.
  - **Save:** a `checkmark` button with `.glassProminent` and a `ButtonGreen` tint. It is disabled until the name contains text.
- **Sections:**
  1. Plant name.
  2. Room and Light pickers.
  3. Watering Days and Water pickers.
  4. "Delete Reminder", shown only when editing.
- **Pickers:** each label has an SF Symbol: `location` (Room), `sun.max` (Light), `drop` (Watering Days and Water). Values show in system gray with up/down chevrons.

### Screen states

| State | When | Header divider |
|---|---|---|
| Empty State | No plants have ever been added | `HeaderDividerEmpty` |
| No reminders | Every plant has been deleted | `HeaderDividerEmpty` |
| Plant list | Plants exist and All Done isn't showing | `HeaderDivider` |
| All Done | At least one plant was due today and all of them are watered; tapping it shows the list | `HeaderDivider` |

### Splash screen

Shown for 1.5 seconds at launch:

- `PlantHappy` at 140 pt wide.
- "Planto" in 44 pt Bold.
- "Plant Care reminders 🌿" in the system Title 3 style, gray.
- 12 pt spacing between the three elements.

The Sketch values in this document don't cover the splash screen.

## 6. Illustrations & App Icon

### Illustrations

| Asset | Size in app | Used on |
|---|---|---|
| `PlantHappy.svg` | 164 wide (Empty State), 140 wide (splash) | Empty State, splash |
| `PlantWink.svg` | 219 wide | All Done |

- **Source:** both illustrations are vector exports from the Sketch design, not redrawn or cropped from an image.
- **Format:** the asset catalog keeps them as SVG with "Preserve Vector Data" enabled, so they stay sharp at every size.

### App icon

The icon is [`Planto/PlantoIcon.icon`](Planto/PlantoIcon.icon), an Icon Composer document set as the app icon (`ASSETCATALOG_COMPILER_APPICON_NAME = PlantoIcon`).

- **Layers:** three SVG layers (`Planto1.svg`, `planto-2.svg`, `planto3 2.svg`), each in its own group with a neutral shadow at 50% and 30% translucency.
- **Liquid Glass:** enabled on the `Planto1` layer.
- **Default appearance:** uses the dark design, with a `system-dark` background fill and the `planto-2` layer in Multiply blend mode.
- **Other appearances:** Dark, Clear and Tinted use their own settings in the file.

## 7. Implementation Decisions

**Native SwiftUI styling**

- **Form cards (Sketch corner radius: 30):** we kept SwiftUI's native Form styling instead of rebuilding the cards by hand, so the cards use the system corner radius. Pickers and the keyboard work as they do in other iOS apps.
- **Sheet toolbar buttons (Sketch: 44 × 44):** Cancel and Save are native toolbar items, so their size and Liquid Glass look come from the system, not from the Sketch buttons.
- **Form spacing:** sections use one 40 pt spacing, so "Delete Reminder" sits 40 pt below the last card instead of 85 pt as in Sketch.
- **Form text:** form rows keep system text metrics, so the Sketch kerning (−0.455) and fixed line heights aren't applied.
- **Shadows:** Planto has no custom shadows. The only shadows in Sketch belong to Apple's Liquid Glass button symbols, and in the app they come from the system glass styles.

**Content and consistency**

- **"Full Sun" vs. "Full sun":** the app uses the option labels from the challenge brief, which capitalize "Sun".
- **Fonts:** "Plant Name" uses SF Pro instead of Helvetica, so the app has a single type family.
- **Colors:** the cursor reuses `CheckGreen`, and small Sketch kerning values are rounded to two decimals.

**Behavior added beyond the mockup**

- **Faded rows:** plants that are not due today appear at 50% opacity below today's reminders. This isn't in Sketch. It keeps every plant in the list, so any plant can be edited or deleted on any day.
- **Watered state:** as in Sketch, only the name color and the light chip change when a plant is watered, and the check stays at full opacity.

**Screen size and appearance**

- **Device width:** Sketch artboards are 428 pt wide and the test device is 402 pt. Margins stay fixed, so centered content and full-width elements adapt to the screen.
- **Dark appearance:** the app sets `.preferredColorScheme(.dark)` and `UIUserInterfaceStyle = Dark`, so it always uses the dark design regardless of the system setting.
