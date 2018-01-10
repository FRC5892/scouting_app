# Scouting App (tentative title)

This is FRC team 5892's scouting app. The application is designed to help scouts organize, collate, and summarize their data in the Internet-starved environment of competition.

The application provides scouts with a set of two forms: one for pit interviews and one for matches. Form data is manually pushed and pulled to and from Google Firebase, presumably when your scouting team convenes and a few people turn on their phones' hotspots.

We have not yet released the app on the App Store or Play Store, but it is open source. Feel free to build and customize it yourself. Instructions for compiling the app are below.

The app is cross-compatible between Android and iOS. In order to compile for iOS, you will need a Mac.

### Instructions to Compile
1. Install Flutter on the computer. Instructions for Windows, Mac, and Linux are at <https://flutter.io/setup/>.
2. Clone this repository.
3. Follow the instructions at [this link](https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#4) to create a database and add configuration files for whichever platform(s) you need to support. Disregard the "Integrate the FlutterFire package" section and anything below.

#### Building for iOS
~~Please note that I know very little about iOS development. Don't hesitate to suggest improvements to this.~~

For each device that you need to install the app on:
- plug it into your Mac
- complete the necessary setup in Xcode
- run `flutter run --release` in the repository root

#### Building for Android
- run `flutter build apk` in the repository root
- find the output file at `build/app/outputs/apk/release/app-release.apk`
- send the file to all of the Android users (email/Google Drive are good for this)
- have them install it