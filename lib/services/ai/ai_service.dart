import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:url_launcher/url_launcher.dart';

import '../../models/ai_provider_config.dart';
import '../../models/reading.dart';
import '../../models/spread.dart';
import '../secure_storage_service.dart';
import 'adapters/claude_adapter.dart';
import 'adapters/gemini_adapter.dart';
import 'adapters/openai_compatible_adapter.dart';
import 'ai_provider_adapter.dart';
import 'ai_result.dart';
import 'prompt_builder.dart';

/// Orchestrates the two interpretation flows described in the plan:
///
/// Flow A — the user has stored their own API key for [provider]: call that
/// provider's API directly and return the interpretation text.
///
/// Flow B — no key stored (or Flow A failed on Web, most likely due to
/// CORS): copy the prompt to the clipboard and open the provider's official
/// chat URL so the user can paste it there themselves.
class AiService {
  AiService({
    SecureStorageService? storage,
    Map<AiProvider, AiProviderAdapter>? adapters,
  }) : _storage = storage ?? SecureStorageService(),
       _adapters =
           adapters ??
           {
             AiProvider.claude: ClaudeAdapter(),
             AiProvider.chatgpt: OpenAiCompatibleAdapter(AiProvider.chatgpt),
             AiProvider.gemini: GeminiAdapter(),
             AiProvider.deepseek: OpenAiCompatibleAdapter(AiProvider.deepseek),
             AiProvider.qwen: OpenAiCompatibleAdapter(AiProvider.qwen),
             AiProvider.moonshot: OpenAiCompatibleAdapter(
               AiProvider.moonshot,
             ),
             AiProvider.zhipu: OpenAiCompatibleAdapter(AiProvider.zhipu),
           };

  final SecureStorageService _storage;
  final Map<AiProvider, AiProviderAdapter> _adapters;

  Future<AiResult> getInterpretation({
    required Reading reading,
    required AiProvider provider,
    required String Function(SpreadPosition position) positionLabel,
    required String noQuestionText,
    required String questionIntro,
    required String cardsIntro,
    required String closingQuestion,
    required String orientationUpright,
    required String orientationReversed,
  }) async {
    final prompt = PromptBuilder.build(
      reading,
      positionLabel: positionLabel,
      noQuestionText: noQuestionText,
      questionIntro: questionIntro,
      cardsIntro: cardsIntro,
      closingQuestion: closingQuestion,
      orientationUpright: orientationUpright,
      orientationReversed: orientationReversed,
    );
    final apiKey = await _storage.getApiKey(provider);

    if (apiKey == null || apiKey.isEmpty) {
      return _flowB(provider, prompt);
    }

    try {
      final adapter = _adapters[provider]!;
      final text = await adapter
          .generateInterpretation(apiKey, prompt)
          .timeout(const Duration(seconds: 30));
      return AiResult.success(text);
    } catch (e) {
      if (kIsWeb) {
        final displayName = AiProviderConfig.all[provider]!.displayName;
        return _flowB(
          provider,
          prompt,
          kind: AiNoticeKind.webFallbackAfterError,
          providerName: displayName,
        );
      }
      return AiResult.error(e.toString());
    }
  }

  Future<AiResult> _flowB(
    AiProvider provider,
    String prompt, {
    AiNoticeKind kind = AiNoticeKind.clipboardCopied,
    String? providerName,
  }) async {
    await Clipboard.setData(ClipboardData(text: prompt));
    final url = Uri.parse(AiProviderConfig.all[provider]!.fallbackChatUrl);
    await launchUrl(url, mode: LaunchMode.externalApplication);
    return AiResult.copiedToClipboard(kind: kind, providerName: providerName);
  }
}
