# Planto — Design Specifications from Sketch

Values below were read from the layer data inside `Plants App🌱 Copy 43.sketch` (page "🌱 High-fidelity"),
not measured from screenshots. Sketch artboards are 428 × 926 pt. Positions are in points.

**Legend:** ✅ exact value from Sketch · ⚠️ inferred or approximated · ❌ not available in the file

## Colors

| Element | Sketch value | Source |
|---|---|---|
| Screen background | `#000000` | ✅ artboard fill |
| Sheet background | `#1C1C1E` | ✅ "Frame" fill (Set Reminder) |
| Form card background | `#2C2C2E` | ✅ "Rectangle 15" fill |
| Header divider (start / no reminders) | `#39393B`, 1 pt | ✅ "Rectangle 2" |
| Header divider (list / All Done) | `#181819`, 1 pt | ✅ "Rectangle 2" |
| Row divider (plant list) | `#222224`, 1 pt | ✅ "Rectangle 1" |
| Form row divider | `#414144`, 1 pt | ✅ "Rectangle 14" |
| Primary green (buttons, progress fill) | `#338069` | ✅ symbol color overrides + "Filled" |
| Progress track | `#262626` | ✅ "Frame" fill |
| Completed check | `#28E0A8` | ✅ 􀁣 text color |
| Unchecked circle | `#979797` border, 1.2 pt | ✅ "Circle" oval |
| Text-field cursor | `#29DFA8` | ✅ "Cursor" (app uses `#28E0A8`, 1 unit apart) |
| Primary text | `#FFFFFF` | ✅ |
| Room text | `#FFFFFF` at 50% | ✅ |
| Completed plant name | `#989898` | ✅ text-layer fill |
| Light chip text | `#CCC785` (68% opacity when completed) | ✅ |
| Water chip text | `#CAF3FB` | ✅ text-layer fill (overrides the `#005EF3` run color) |
| Chip background | `#18181D` | ✅ |
| Secondary text (empty / All Done) | `#9F9F91` at 70% | ✅ |
| "No reminders set yet.." | `#756F6F` | ✅ |
| Form value text and chevrons | `#8E8E93` | ✅ |
| Placeholder "Pothos" | `#666666` | ✅ |
| Destructive "Delete Reminder" | `#FF453A` | ✅ Apple "Lists/Destructive" symbol |
| All Done backdrop oval | `#14141A` at 58% | ✅ (already inside `PlantWink.svg`) |

## Typography

All text uses the iOS system font (SF Pro).

| Text | Font | Size | Kerning | Alignment |
|---|---|---|---|---|
| "My Plants 🌱" | SF Pro Display Bold | 34 | 0.374 | left |
| "Start your plant journey!" / "All Done! 🎉" | SF Pro Semibold | 25 | 0 | center |
| Empty-state body / "All Reminders Completed" | SF Pro Regular | 16 | 0 | center |
| "No reminders set yet.." | SF Pro Semibold | 20 | 0 | center |
| Progress text | SF Pro Regular | 18 | 0.234 | center |
| Room ("in Kitchen") | SF Pro Text Regular | 15 | -0.24 | left |
| Plant name | SF Pro Regular | 28 | 0.364 | left |
| Light chip | SF Pro Regular | 14 | 0 | left |
| Water chip | SF Pro Medium | 14 | 0 | left |
| Button labels ("Set Plant Reminder") | SF Pro Medium | 17 | — | center |
| Sheet title "Set Reminder" | SF Pro Semibold | 17 | — | center |
| Form row labels and values | SF Pro Regular | 18 (Light label: 17) | -0.455 | left / right |
| "Plant Name" label | Helvetica 18 ⚠️ | 18 | 0 | left |
| Placeholder | SF Pro Regular | 17 | 0 | left |

- Line height: not set on most layers (❌, so the system default applies). It is fixed at 22 pt on form rows and 16 pt on the water chip.
- "Plant Name" uses Helvetica in Sketch, unlike every other label. It is probably accidental; the app uses the system font, since no new fonts were to be added.

## Layout and components

| Component | Sketch value |
|---|---|
| Title position | x 16, y 83; 20 pt above the header divider |
| Header divider | x 15 to the right edge, y 143 |
| Empty-state illustration | 164 × 200, centered, 77 pt below divider |
| Gap: illustration → heading → body → button | 37 / 25 / 105 pt |
| Empty-state body width | 315 pt |
| "Set Plant Reminder" button | 280 × 42, Glass Prominent, tint `#338069` |
| + button | 44 × 44 circle, Glass Prominent, tint `#338069`, 30 pt from the right edge |
| Progress text → bar | 15 pt; text sits 34–38 pt below the divider (differs between artboards) |
| Progress bar | 361 × 8, corner radius 4; ≈33 pt side margins |
| Bar → first row | ≈60 pt |
| Plant row | ≈111–113 pt tall; circle x 15 (23 × 23); text x 65–67 |
| Row inner gaps | room → name 4–5 pt, name → chips 7 pt |
| Chips | height 23, corner radius 8, 13 pt apart, ≈9 pt horizontal padding |
| Set Reminder cards | width 388, corner radius 30; name card 59 tall; two-row cards 95–98 tall |
| Gaps between cards | 50 / 40 pt; Delete row 85 pt below |
| Sheet toolbar buttons | 44 × 44 glass |
| All Done illustration | 219 × 227, 127 pt below divider; title 33 pt below; subtitle 14 pt below title |
| Shadows | Only inside Apple's Liquid Glass button symbols (system-rendered); none on Planto's own layers |

## Sketch vs. SwiftUI (before this change)

| Element | Sketch | SwiftUI before | Fixed? |
|---|---|---|---|
| Primary green | `#338069` | `#29765F` (sampled from PDF) | ✅ |
| Header divider | `#39393B` / `#181819`, 1 pt, 20 pt below title | white 30%, 12 pt below | ✅ |
| Title kerning | 0.374 | none | ✅ |
| Progress text | 18 pt, kerning 0.234 | 17 pt | ✅ |
| Progress bar | `#262626` track, `#338069` fill, 8 pt | system track, `#29765F`, scaled ×2 | ✅ (custom ProgressViewStyle) |
| Progress margins | ≈33 pt sides, 15 pt below text | 28 / 14 | ✅ |
| Row divider | `#222224`, starts under the circle | system grey, starts under the text | ✅ |
| Unchecked circle | `#979797`, 25 pt glyph | system grey, 26 pt | ✅ |
| Circle → text gap | text at x 67 | x 71.7 | ✅ (x 67.7 now) |
| Room text | 15 pt, white 50%, kerning -0.24 | 15 pt, system grey | ✅ |
| Plant name kerning / completed color | 0.364 / `#989898` | none / system grey | ✅ |
| Chips | 14 pt (water: Medium), height 23, 13 pt apart | 13 pt, padding 4, 12 apart | ✅ |
| Completed row | only name grey + light chip at 68% | whole row at 80% opacity (dimmed the green check) | ✅ |
| Empty body text | 16 pt `#9F9F91` 70%, width 315 | 15 pt system grey | ✅ |
| Empty-state spacing | 77 / 37 / 25 / 105 | 71 / 41 / 22 / 100 | ✅ |
| "Set Plant Reminder" | 280 × 42, Medium 17 | 276 × 42, Semibold 17 | ✅ (280 × 42 now) |
| + button | 44 × 44, 17 pt Medium symbol | 34 × 34, 22 pt symbol | ✅ (44 × 44 now) |
| "No reminders set yet.." | `#756F6F` | system grey | ✅ |
| All Done spacing / subtitle | 33 / 14, `#9F9F91` 70% | 36 / 16, system grey | ✅ |
| Placeholder | `#666666` | system placeholder | ✅ |
| Form text | 18 pt | 17 pt | ✅ |
| Form dividers | `#414144` | system | ✅ |
| Card spacing / row height | 40–50 pt / ≈47 pt; name card 59 | system defaults | ✅ (spacing 40, min row height 47, name row padded) |

## Not matched exactly, and why

- **Form card corner radius (Sketch: 30):** iOS draws Form sections with its own radius; there is no native setting for it.
- **Sheet toolbar buttons (Sketch: 44 × 44):** iOS 26 draws native toolbar glass buttons at 36 × 36. Kept native for Liquid Glass.
- **"Full sun" vs "Full Sun":** Sketch rows say "Full sun"; the app uses the option list from the challenge brief ("Full Sun").
- **Device size:** Sketch is 428 pt wide; the test simulator (iPhone 18 Pro) is 402 pt. Margins are kept, so centered items scale with the screen.
- **Faded not-due rows (50%):** not in Sketch. It is an app behavior added earlier to mark plants that are not due today.
- **Line heights:** not set in Sketch for most layers, so the system default is used.
