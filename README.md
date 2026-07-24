# Queen of Swords 🗡️

**Português** · [English](#english)

Um app de tiragem de tarô feito em Flutter, com embaralhamento verdadeiramente aleatório e interpretações por IA opcionais.

[![Release](https://img.shields.io/github/v/release/imponateado/queenofswords)](https://github.com/imponateado/queenofswords/releases/latest)
[![Build](https://github.com/imponateado/queenofswords/actions/workflows/release.yml/badge.svg)](https://github.com/imponateado/queenofswords/actions/workflows/release.yml)

## Funcionalidades

- **Embaralhamento verdadeiramente aleatório** — as cartas são sorteadas com a aleatoriedade de ruído atmosférico do [random.org](https://www.random.org), com fallback local criptograficamente seguro quando offline
- **Quatro tiragens** — Carta Única, Três Cartas (passado / presente / futuro), Cinco Cartas e Cruz Celta
- **Interpretação por IA (opcional)** — use sua própria chave de API do Claude, ChatGPT, Gemini, DeepSeek, Qwen, Kimi ou GLM; as chaves ficam no armazenamento seguro do sistema e nunca saem do seu aparelho
- **Enciclopédia de cartas** — navegue pelas 78 cartas com significados na posição normal e invertida
- **Histórico de tiragens** — suas leituras ficam salvas localmente no aparelho
- **Fase da lua** — veja a fase lunar atual junto da sua tiragem
- **Bilíngue** — Português do Brasil e inglês

## Instalação

Baixe a versão mais recente na página de [Releases](https://github.com/imponateado/queenofswords/releases/latest).

### Android

Baixe o APK correspondente ao seu aparelho e instale:

| APK | Aparelho |
| --- | --- |
| `arm64-v8a` | Maioria dos celulares (2017 em diante) |
| `armeabi-v7a` | Aparelhos antigos de 32 bits |
| `x86_64` | Emuladores e Chromebooks |

Na dúvida, comece pelo `arm64-v8a`.

### iOS

O IPA não é assinado, então precisa ser instalado por sideload com ferramentas como [AltStore](https://altstore.io/) ou [Sideloadly](https://sideloadly.io/), ou reassinado com seu próprio certificado de desenvolvedor Apple.

## Compilando do código-fonte

Requer [Flutter](https://flutter.dev) 3.44+ no canal stable.

```bash
git clone https://github.com/imponateado/queenofswords.git
cd queenofswords
flutter pub get
flutter run
```

Builds de release:

```bash
flutter build apk --release --split-per-abi   # Android
flutter build ios --release --no-codesign     # iOS (sem assinatura)
```

## Publicando uma versão

As releases são automatizadas com GitHub Actions. Ao enviar uma tag, os APKs e o IPA são compilados e publicados:

```bash
# primeiro atualize o `version:` no pubspec.yaml, depois:
git tag v1.x.y
git push origin v1.x.y
```

## Notas técnicas

- Gerenciamento de estado com [provider](https://pub.dev/packages/provider)
- Histórico persistido com [Hive](https://pub.dev/packages/hive)
- Chaves de API armazenadas via [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- Localização com o `gen-l10n` do Flutter (`lib/l10n`)

## Licença

Nenhuma licença foi definida ainda — todos os direitos reservados por enquanto.

---

<a name="english"></a>

# English

[Português](#queen-of-swords-️) · **English**

A tarot reading app built with Flutter, featuring true random shuffling and optional AI-powered interpretations.

## Features

- **True random shuffling** — cards are drawn using [random.org](https://www.random.org)'s atmospheric-noise randomness, with a cryptographically secure local fallback when offline
- **Four spreads** — Single Card, Three Card (past / present / future), Five Card, and Celtic Cross
- **AI interpretation (optional)** — bring your own API key for Claude, ChatGPT, Gemini, DeepSeek, Qwen, Kimi or GLM; keys are kept in the platform's secure storage and never leave your device
- **Card encyclopedia** — browse all 78 cards with upright and reversed meanings
- **Reading history** — past readings are stored locally on your device
- **Moon phase** — see the current lunar phase alongside your reading
- **Bilingual** — Portuguese (Português do Brasil) and English

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
