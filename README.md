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
| 07 | <img src="assets/members/member_07/portrait.png" alt="Portrait of Manusha Ginige" width="64"> | Manusha Ginige | 23IT0477 | PULSE | [Profile](lib/features/members/member_07/) · [Assets](assets/members/member_07/) |
| 08 | <img src="assets/members/member_08/portrait.png" alt="Portrait of M. G. Dulan" width="64"> | M. G. Dulan | 23IT0473 | BRUTAL | [Profile](lib/features/members/member_08/) · [Assets](assets/members/member_08/) |
| 09 | <img src="assets/members/member_09/portrait.png" alt="Portrait of D.M.S.A.K. Dissanayaka" width="64"> | D.M.S.A.K. Dissanayaka | 23IT0472 | CINEMA | [Profile](lib/features/members/member_09/) · [Assets](assets/members/member_09/) |

S Dinath (Member 03) connected the app to Firebase Authentication.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the member contract and Git workflow.

## Screenshots

| Sign-in | Directory | Member profile |
| --- | --- | --- |
| Add a configured Android screenshot | Add a light or dark directory screenshot | Add a finished profile screenshot |
