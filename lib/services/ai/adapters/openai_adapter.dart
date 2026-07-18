import 'package:dio/dio.dart';

import '../../../models/ai_provider_config.dart';
import '../ai_provider_adapter.dart';

/// OpenAI Chat Completions API. Bearer-token auth. OpenAI's browser-CORS
/// posture for this endpoint is unverified — AiService already falls back
/// to the clipboard/deep-link flow on any failure on Web, so this adapter
/// just needs to fail cleanly rather than handle CORS specially.
class OpenAiAdapter implements AiProviderAdapter {
  OpenAiAdapter({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<String> generateInterpretation(String apiKey, String prompt) async {
    final config = AiProviderConfig.all[AiProvider.chatgpt]!;
    final response = await _dio.post<Map<String, dynamic>>(
      config.apiEndpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'content-type': 'application/json',
        },
      ),
      data: {
        'model': config.defaultModel,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      },
    );

    final choices = response.data?['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw const FormatException('Unexpected OpenAI API response');
    }
    return choices.first['message']['content'] as String;
  }
}
