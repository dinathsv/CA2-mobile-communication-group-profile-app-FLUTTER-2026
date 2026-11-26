# IX

**Nine people. Nine identities.**

IX is an Android member directory for the NDT Mobile Communication CA2 group assignment. It combines a shared sign-in and directory with nine profile screens owned by individual contributors.

## Features and stack

- Flutter and null-safe Dart with Material 3 and shared light and dark themes.
- Firebase Core and Firebase Authentication for email/password sign-in, persistent sessions, and confirmed sign-out.
- A searchable directory with carousel and list views, nine independent profiles, and portrait transitions that respect the system's reduced-motion setting.
- A `StreamBuilder` for session changes and `setState` for the form, search, and theme.

## Local setup

Use Flutter 3.44 or later with Dart 3.12 or later, an Android device or emulator running API 24 or later, and an Android toolchain confirmed by `flutter doctor`. The foundation was created with Flutter 3.47.7.

```sh
flutter doctor
flutter pub get
```

### Firebase setup for Android

1. Create or select the group's project in the Firebase console. Enable **Authentication → Sign-in method → Email/Password**. Add a dedicated temporary assessment user under **Authentication → Users → Add user**. [Firebase password sign-in guide](https://firebase.google.com/docs/auth/flutter/password-auth)
2. Install the Firebase CLI, sign in with a Google account that can configure the group project, and activate the FlutterFire CLI.

   ```sh
   firebase login
   dart pub global activate flutterfire_cli
   ```

3. From the repository root, replace `YOUR_FIREBASE_PROJECT_ID` with the group's project ID and run the command below. Run `dart pub global run flutterfire_cli:flutterfire` in place of `flutterfire` if the pub cache's `bin` directory is outside your PATH. [FlutterFire setup guide](https://firebase.google.com/docs/flutter/setup)

   ```sh
   flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID --platforms=android --android-package-name=lk.ndt.nine
   ```

4. Confirm that FlutterFire generated `lib/firebase_options.dart` and `android/app/google-services.json`. Android Gradle processes the JSON into the native resources used by `Firebase.initializeApp()`. Both generated files are local to each checkout. Assign the group leader to configure the shared project, or share the generated Android configuration privately with contributors who lack console access. [Android Firebase setup guide](https://firebase.google.com/docs/android/setup)
5. Rebuild and sign in with the assessment account. The app displays a setup screen until valid Android Firebase configuration is present.

### Assessment login

| Field | Value |
| --- | --- |
| Email | `simple@gmail.com` |
| Password | `simple12` |

Use a private GitHub repository and grant the lecturer access. Keep personal passwords, service-account credentials, and signing keys out of Git.

## Run, test, and build

```sh
flutter devices
flutter run

dart format lib test
flutter analyze
flutter test

flutter build apk --debug
```

The Dart and widget tests run without Firebase project configuration. Install the debug APK from `build/app/outputs/flutter-apk/app-debug.apk` for assessment or device testing.

### Run in Chrome

Register or select a Web app in the same Firebase project. Save its Firebase SDK configuration as `firebase.web.json` in the project root. With the Firebase CLI and `jq` installed, replace `WEB_APP_ID` and `YOUR_PROJECT_ID` to download the configuration and run the app.

```sh
firebase apps:sdkconfig WEB WEB_APP_ID --project YOUR_PROJECT_ID --json \
  | jq -e '.result.sdkConfig // .result' > firebase.web.json
flutter run -d chrome --dart-define-from-file=firebase.web.json
```

## Architecture

| Path | Responsibility |
| --- | --- |
| `lib/main.dart`, `lib/app.dart` | Firebase startup, app shell, and theme state |
| `lib/services/auth_service.dart` | Firebase adapter, validation, and user-facing sign-in errors |
| `lib/features/auth/` | Login form, session gate, and the authenticated navigator |
| `lib/features/home/`, `lib/data/member_registry.dart` | Searchable directory and profile-to-route mapping |
| `lib/features/members/member_XX/`, `assets/members/member_XX/` | Each contributor's data, UI, and portrait |
| `lib/models/`, `lib/core/`, `lib/widgets/` | Profile contract, theming, transitions, and shared widgets |

Signing out removes the authenticated navigator and its route history. The native Firebase SDK restores the saved sign-in session when the app launches.

## Member contributions

| Member | Portrait | Name | Student ID | Design | Owned directories |
| :---: | :---: | --- | --- | --- | --- |
| 01 | <img src="assets/members/member_01/portrait.png" alt="Portrait of Chanaka Ekanayake" width="64"> | Chanaka Ekanayake | 23IT0475 | MONO | [Profile](lib/features/members/member_01/) · [Assets](assets/members/member_01/) |
| 02 | <img src="assets/members/member_02/portrait.png" alt="Portrait of Hamas Akram" width="64"> | Hamas Akram | 23IT0479 | TERMINAL | [Profile](lib/features/members/member_02/) · [Assets](assets/members/member_02/) |
| 03 | <img src="assets/members/member_03/portrait.jpeg" alt="Portrait of S Dinath" width="64"> | S Dinath | 23IT0471 | AURA | [Profile](lib/features/members/member_03/) · [Assets](assets/members/member_03/) |
| 04 | <img src="assets/members/member_04/portrait.png" alt="Portrait of Umindu Dinal" width="64"> | Umindu Dinal | 23IT0470 | ZEN | [Profile](lib/features/members/member_04/) · [Assets](assets/members/member_04/) |
| 05 | <img src="assets/members/member_05/portrait.png" alt="Portrait of EDIRISINGHE ARACHCHILAGE SACHINI JINATHMA EDIRISINGHE" width="64"> | EDIRISINGHE ARACHCHILAGE SACHINI JINATHMA EDIRISINGHE | 23IT0474 | BENTO | [Profile](lib/features/members/member_05/) · [Assets](assets/members/member_05/) |
| 06 | <img src="assets/members/member_06/portrait.png" alt="Portrait of Ravindi Ranthilini" width="64"> | Ravindi Ranthilini | 23IT0476 | VOGUE | [Profile](lib/features/members/member_06/) · [Assets](assets/members/member_06/) |
| 07 | <img src="assets/members/member_07/portrait.png" alt="Placeholder portrait for Member 07" width="64"> | Pending | Pending | PULSE | [Profile](lib/features/members/member_07/) · [Assets](assets/members/member_07/) |
| 08 | <img src="assets/members/member_08/portrait.png" alt="Placeholder portrait for Member 08" width="64"> | Pending | Pending | BRUTAL | [Profile](lib/features/members/member_08/) · [Assets](assets/members/member_08/) |
| 09 | <img src="assets/members/member_09/portrait.png" alt="Portrait of D.M.S.A.K. Dissanayaka" width="64"> | D.M.S.A.K. Dissanayaka | 23IT0472 | CINEMA | [Profile](lib/features/members/member_09/) · [Assets](assets/members/member_09/) |

See [CONTRIBUTING.md](CONTRIBUTING.md) for the member contract and Git workflow.

## Screenshots

| Sign-in | Directory | Member profile |
| --- | --- | --- |
| Add a configured Android screenshot | Add a light or dark directory screenshot | Add a finished profile screenshot |
