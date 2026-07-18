import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/ai_provider_config.dart';

/// Stores user-supplied AI API keys on-device only — nothing is ever sent
/// anywhere except directly to that provider's official API.
///
/// Backed by Keychain (iOS) / Keystore (Android). On Web this falls back to
/// browser storage, which is not hardware-backed — Settings must disclose
/// this to users pasting a key into a web build.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  String _keyFor(AiProvider provider) => 'ai_api_key_${provider.name}';

  Future<String?> getApiKey(AiProvider provider) =>
      _storage.read(key: _keyFor(provider));

  Future<void> setApiKey(AiProvider provider, String apiKey) =>
      _storage.write(key: _keyFor(provider), value: apiKey);

  Future<void> clearApiKey(AiProvider provider) =>
      _storage.delete(key: _keyFor(provider));
}
