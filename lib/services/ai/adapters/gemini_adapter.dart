import 'package:dio/dio.dart';

import '../../../models/ai_provider_config.dart';
import '../ai_provider_adapter.dart';

/// Google Gemini `generateContent` API. Auth via `key` query parameter.
class GeminiAdapter implements AiProviderAdapter {
  GeminiAdapter({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<String> generateInterpretation(String apiKey, String prompt) async {
    final config = AiProviderConfig.all[AiProvider.gemini]!;
    final url = '${config.apiEndpoint}/${config.defaultModel}:generateContent';
    final response = await _dio.post<Map<String, dynamic>>(
      url,
      queryParameters: {'key': apiKey},
      options: Options(headers: {'content-type': 'application/json'}),
      data: {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      },
    );

    final candidates = response.data?['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw const FormatException('Unexpected Gemini API response');
    }
    final parts = candidates.first['content']['parts'] as List;
    return parts.map((p) => p['text'] as String).join();
  }
}
