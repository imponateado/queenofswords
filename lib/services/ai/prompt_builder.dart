import '../../models/reading.dart';
import '../../models/spread.dart';

/// Builds the tarot-interpretation prompt sent to the AI — used verbatim
/// both as the API request payload (direct integration) and as the text
/// copied to the clipboard when the user has no API key configured.
///
/// All wording is supplied by the caller (resolved from `AppLocalizations`
/// at the UI layer) so the prompt follows the app's current locale, the
/// same way [positionLabel] resolves each drawn card's spread-position
/// label since [SpreadPosition] no longer carries a bare label itself.
class PromptBuilder {
  PromptBuilder._();

  static String build(
    Reading reading, {
    required String Function(SpreadPosition position) positionLabel,
    required String noQuestionText,
    required String questionIntro,
    required String cardsIntro,
    required String closingQuestion,
    required String orientationUpright,
    required String orientationReversed,
  }) {
    final question = reading.question?.trim();
    final questionLine = (question != null && question.isNotEmpty) ? question : noQuestionText;

    final cardsBlock = reading.drawnCards
        .map((drawn) {
          final orientation = drawn.isReversed ? orientationReversed : orientationUpright;
          return '- ${positionLabel(drawn.position)}: ${drawn.card.name} ($orientation)';
        })
        .join('\n');

    return '''
$questionIntro
$questionLine

$cardsIntro
$cardsBlock

$closingQuestion
''';
  }
}
