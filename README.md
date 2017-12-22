# Scouting App (tentative title)

This is FRC team 5892's _extremely work-in-progress_ scouting app. The intent is to create an application that will help scouts organize their data in a manner optimized for the scarce WiFi present at competitions.

The application will provide scouts with a set of forms to fill out (pit interviews, matches, etc.), and allow them to be manually synced to a cloud database.

We also would like for other teams to be able to use our app themselves.

Hopefully, we will be able to release both Android and iOS versions.

### The app won't work when I build it!
Unfortunately, this is intentional. Because we use Google Firebase, the app is expecting some Firebase config files in specific locations, and we aren't checking them into Git.

If you would like to contribute (team members included), follow the instructions at [this link](https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#4) to make your own config files for your own database. Make sure your development database has Cloud Firestore enabled.

(Actually I don't know the exact degree to which the app will fail to work. Regardless, Firebase is pretty important to it.)
