<p align="center"><img src="assets/icon/preview.png" width="120" alt="Clutch app icon"></p>

# Clutch

Your emergency info on your lock screen, in your wallet and in a QR. Free, open source, and private: no account, no analytics, and the Android release build has no internet permission.

## What it does

- **Lock-screen wallpaper.** By default it shows only "In case of emergency" and a QR, so your details stay private until someone scans it. You can put it over your own photo, or switch to a layout that shows the details directly.
- **Lock-screen SOS button.** A "Clutch SOS" shortcut (One UI and other launchers that allow app shortcuts) and an "Emergency QR" Quick Settings tile. Both show the QR over the lock screen without unlocking.
- **QR that opens a page.** Scanning opens a clean page with one-tap call buttons ([docs/index.html](docs/index.html)). The details live in the link after `#`, which browsers never send to the server. There's also an offline plain-text mode.
- **Wallet card.** 85.6 × 53.98 mm, front and back, as an A4 PDF to print, cut and fold.
- **Family profiles**, encrypted on-device storage, JSON backup with an optional passphrase, a 6-month check-in reminder, an edit lock (biometric or PIN), a home-screen widget, NFC tag writing, and regional emergency numbers.
- **Languages:** English, हिन्दी, Hinglish and తెలుగు. Strings live in [lib/l10n](lib/l10n); add a language by adding an ARB file.

> Clutch is not a medical device. You are responsible for keeping your details accurate.

## Build

```sh
flutter pub get
flutter test
flutter run            # Android 8.0+ is the primary target; iOS 15+ is supported
```

The app icon is drawn in code: `flutter test tool/icon_gen_test.dart && dart run flutter_launcher_icons`.

## Licence

MIT. Fonts: Unbounded and Space Grotesk, under the SIL Open Font License ([assets/fonts/OFL.txt](assets/fonts/OFL.txt)).
