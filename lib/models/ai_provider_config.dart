enum AiProvider { claude, chatgpt, gemini }

class AiProviderConfig {
  final AiProvider provider;
  final String displayName;
  final String defaultModel;
  final String apiEndpoint;
  final String fallbackChatUrl;

  const AiProviderConfig({
    required this.provider,
    required this.displayName,
    required this.defaultModel,
    required this.apiEndpoint,
    required this.fallbackChatUrl,
  });

  static const Map<AiProvider, AiProviderConfig> all = {
    AiProvider.claude: AiProviderConfig(
      provider: AiProvider.claude,
      displayName: 'Claude',
      defaultModel: 'claude-sonnet-5',
      apiEndpoint: 'https://api.anthropic.com/v1/messages',
      fallbackChatUrl: 'https://claude.ai/new',
    ),
    AiProvider.chatgpt: AiProviderConfig(
      provider: AiProvider.chatgpt,
      displayName: 'ChatGPT',
      defaultModel: 'gpt-4o',
      apiEndpoint: 'https://api.openai.com/v1/chat/completions',
      fallbackChatUrl: 'https://chat.openai.com/',
    ),
    AiProvider.gemini: AiProviderConfig(
      provider: AiProvider.gemini,
      displayName: 'Gemini',
      defaultModel: 'gemini-2.5-flash',
      apiEndpoint: 'https://generativelanguage.googleapis.com/v1beta/models',
      fallbackChatUrl: 'https://gemini.google.com/app',
    ),
  };
}
