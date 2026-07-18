enum AiResultStatus { success, copiedToClipboard, error }

/// Which user-facing notice to show for an [AiResultStatus.copiedToClipboard]
/// result. Kept as an enum (rather than a pre-built string) so the actual
/// text can be resolved with [AppLocalizations] at the UI layer — this
/// service layer has no [BuildContext] and stays locale-agnostic.
enum AiNoticeKind {
  /// The normal Flow B path: no API key stored, so the prompt was copied and
  /// the provider's chat site was opened.
  clipboardCopied,

  /// A direct API call failed (most likely CORS, on Web) and the app fell
  /// back to copying the prompt and opening the provider's site.
  webFallbackAfterError,
}

class AiResult {
  final AiResultStatus status;
  final String? text;
  final AiNoticeKind? noticeKind;
  final String? noticeProviderName;
  final String? errorMessage;

  const AiResult._({
    required this.status,
    this.text,
    this.noticeKind,
    this.noticeProviderName,
    this.errorMessage,
  });

  factory AiResult.success(String text) =>
      AiResult._(status: AiResultStatus.success, text: text);

  factory AiResult.copiedToClipboard({
    AiNoticeKind kind = AiNoticeKind.clipboardCopied,
    String? providerName,
  }) => AiResult._(
    status: AiResultStatus.copiedToClipboard,
    noticeKind: kind,
    noticeProviderName: providerName,
  );

  factory AiResult.error(String message) =>
      AiResult._(status: AiResultStatus.error, errorMessage: message);
}
