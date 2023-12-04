# google_maps

NOTE: You must add your API key to `android/app/src/main/AndroidManifest.xml`
before this application can be run.

## Test Scenario 1

- Run application.
- Zoom in and out using the pinch gesture
- Zoom in and out using the + and - buttons
- Pan around

What to look for:

- Any flickering of the application display or corrupt rendering.

## Test Scenario 2

- Run application
- Click the RED/GREEN/BLUE buttons in random sequence
- Observe that the three square dots on the screen consistently switch colors without multiple clicks on the button.

What to look for:

- Inconsistent colors on squares
- Squares not changing color after button is clicked

## Test Scenario 3

- Run application
- Swipe up from the bottom of the screen so the app picker is shown and then swipe down so the app becomes active again.

What to look for:

- Any flickering of the application display.
