import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../models/ai_provider_config.dart';
import '../ai_provider_adapter.dart';

/// Anthropic Messages API. Uses `x-api-key` auth plus the required
/// `anthropic-version` header. On Flutter Web, Anthropic requires an
/// explicit opt-in header to allow direct browser calls — enabling it
/// means the user's key is visible in devtools/network tab, which is an
/// inherent trade-off of the BYOK, no-backend model (disclosed in Settings).
class ClaudeAdapter implements AiProviderAdapter {
  ClaudeAdapter({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<String> generateInterpretation(String apiKey, String prompt) async {
    final config = AiProviderConfig.all[AiProvider.claude]!;
    final response = await _dio.post<Map<String, dynamic>>(
      config.apiEndpoint,
      options: Options(
        headers: {
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
          if (kIsWeb) 'anthropic-dangerous-direct-browser-access': 'true',
        },
      ),
      data: {
        'model': config.defaultModel,
        'max_tokens': 1500,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      },
    );

    final content = response.data?['content'] as List?;
    if (content == null) {
      throw const FormatException('Unexpected Claude API response');
    }
    final textBlock = content.firstWhere(
      (block) => block['type'] == 'text',
      orElse: () =>
          throw const FormatException('No text block in Claude API response'),
    );
    return textBlock['text'] as String;
  }
}
