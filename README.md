# Queen of Swords 🗡️

A tarot reading app built with Flutter, featuring true random shuffling and optional AI-powered interpretations.

[![Release](https://img.shields.io/github/v/release/imponateado/queenofswords)](https://github.com/imponateado/queenofswords/releases/latest)
[![Build](https://github.com/imponateado/queenofswords/actions/workflows/release.yml/badge.svg)](https://github.com/imponateado/queenofswords/actions/workflows/release.yml)

## Features

- **True random shuffling** — cards are drawn using [random.org](https://www.random.org)'s atmospheric-noise randomness, with a cryptographically secure local fallback when offline
- **Four spreads** — Single Card, Three Card (past / present / future), Five Card, and Celtic Cross
- **AI interpretation (optional)** — bring your own API key for Claude, ChatGPT, Gemini, DeepSeek, Qwen, Kimi or GLM; keys are kept in the platform's secure storage and never leave your device
- **Card encyclopedia** — browse all 78 cards with upright and reversed meanings
- **Reading history** — past readings are stored locally on your device
- **Moon phase** — see the current lunar phase alongside your reading
- **Bilingual** — English and Portuguese (Português do Brasil)

## Installation

Grab the latest build from the [Releases](https://github.com/imponateado/queenofswords/releases/latest) page.

### Android

Download the APK matching your device and install it:

| APK | Device |
| --- | --- |
| `arm64-v8a` | Most phones (2017 and newer) |
| `armeabi-v7a` | Older 32-bit devices |
| `x86_64` | Emulators and Chromebooks |

Not sure which one? Try `arm64-v8a` first.

### iOS

The IPA is unsigned, so it must be sideloaded with a tool such as [AltStore](https://altstore.io/) or [Sideloadly](https://sideloadly.io/), or re-signed with your own Apple Developer certificate.

## Building from source

Requires [Flutter](https://flutter.dev) 3.44+ on the stable channel.

```bash
git clone https://github.com/imponateado/queenofswords.git
cd queenofswords
flutter pub get
flutter run
```

Release builds:

```bash
flutter build apk --release --split-per-abi   # Android
flutter build ios --release --no-codesign     # iOS (unsigned)
```

## Releasing

Releases are automated with GitHub Actions. Pushing a tag builds the APKs and IPA and publishes them:

```bash
# bump `version:` in pubspec.yaml first, then:
git tag v1.x.y
git push origin v1.x.y
```

## Tech notes

- State management with [provider](https://pub.dev/packages/provider)
- Reading history persisted with [Hive](https://pub.dev/packages/hive)
- API keys stored via [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- Localization with Flutter's `gen-l10n` (`lib/l10n`)

## License

No license has been chosen yet — all rights reserved for now.
