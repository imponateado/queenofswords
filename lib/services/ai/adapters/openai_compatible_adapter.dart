import 'package:dio/dio.dart';

import '../../../models/ai_provider_config.dart';
import '../ai_provider_adapter.dart';

/// Shared adapter for providers exposing an OpenAI-compatible chat
/// completions endpoint (Bearer auth, `{model, messages}` body,
/// `choices[0].message.content` response). Covers ChatGPT itself plus
/// DeepSeek, Qwen (DashScope's compatible-mode endpoint), Moonshot (Kimi),
/// and Zhipu (GLM), which all mirror this contract.
class OpenAiCompatibleAdapter implements AiProviderAdapter {
  OpenAiCompatibleAdapter(this.provider, {Dio? dio}) : _dio = dio ?? Dio();

  final AiProvider provider;
  final Dio _dio;

  @override
  Future<String> generateInterpretation(String apiKey, String prompt) async {
    final config = AiProviderConfig.all[provider]!;
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
      throw FormatException(
        'Unexpected ${config.displayName} API response',
      );
    }
    return choices.first['message']['content'] as String;
  }
}
