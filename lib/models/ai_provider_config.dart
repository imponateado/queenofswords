enum AiProvider { claude, chatgpt, gemini, deepseek, qwen, moonshot, zhipu }

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
      defaultModel: 'gpt-5.6-sol',
      apiEndpoint: 'https://api.openai.com/v1/chat/completions',
      fallbackChatUrl: 'https://chat.openai.com/',
    ),
    AiProvider.gemini: AiProviderConfig(
      provider: AiProvider.gemini,
      displayName: 'Gemini',
      defaultModel: 'gemini-3.5-flash',
      apiEndpoint: 'https://generativelanguage.googleapis.com/v1beta/models',
      fallbackChatUrl: 'https://gemini.google.com/app',
    ),
    AiProvider.deepseek: AiProviderConfig(
      provider: AiProvider.deepseek,
      displayName: 'DeepSeek',
      defaultModel: 'deepseek-v4-flash',
      apiEndpoint: 'https://api.deepseek.com/chat/completions',
      fallbackChatUrl: 'https://chat.deepseek.com/',
    ),
    AiProvider.qwen: AiProviderConfig(
      provider: AiProvider.qwen,
      displayName: 'Qwen',
      defaultModel: 'qwen3.7-plus',
      apiEndpoint:
          'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions',
      fallbackChatUrl: 'https://chat.qwen.ai/',
    ),
    AiProvider.moonshot: AiProviderConfig(
      provider: AiProvider.moonshot,
      displayName: 'Kimi (Moonshot)',
      defaultModel: 'kimi-k3',
      apiEndpoint: 'https://api.moonshot.ai/v1/chat/completions',
      fallbackChatUrl: 'https://kimi.com/',
    ),
    AiProvider.zhipu: AiProviderConfig(
      provider: AiProvider.zhipu,
      displayName: 'Zhipu (GLM)',
      defaultModel: 'glm-5.2',
      apiEndpoint: 'https://open.bigmodel.cn/api/paas/v4/chat/completions',
      fallbackChatUrl: 'https://chatglm.cn/',
    ),
  };
}
