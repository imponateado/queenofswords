import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/spreads_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/reading.dart';
import '../models/spread.dart';
import '../models/tarot_card.dart';
import '../providers/deck_provider.dart';
import '../providers/reading_provider.dart';
import '../providers/settings_provider.dart';
import '../services/ai/ai_result.dart';
import '../utils/moon_phase.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/provider_selector.dart';
import '../widgets/shuffle_animation_widget.dart';
import '../widgets/spread_layout_widget.dart';
import '../widgets/tarot_card_widget.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key, required this.spread});

  final Spread spread;

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool _shuffling = false;
  bool _revealed = false;

  final _questionController = TextEditingController();
  TarotCard? _significatorCard;
  bool _significatorStepDone = false;
  int _cleansingTaps = 0;
  bool _cleansingStepDone = false;

  @override
  void initState() {
    super.initState();
    // Preload the deck in the background so tapping "shuffle" feels instant —
    // the actual draw/shuffle only happens when the user asks for it.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<DeckProvider>().load(Localizations.localeOf(context)),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _beginShuffle() async {
    setState(() => _shuffling = true);

    final deckProvider = context.read<DeckProvider>();
    final settings = context.read<SettingsProvider>();
    final minAnimationTime = Future<void>.delayed(
      const Duration(milliseconds: 1300),
    );

    if (deckProvider.cards.isEmpty) {
      await deckProvider.load(Localizations.localeOf(context));
    }
    if (!mounted || deckProvider.cards.isEmpty) return;

    final draw = context.read<ReadingProvider>().drawReading(
      spread: widget.spread,
      deck: deckProvider.cards,
      question: settings.askQuestionBeforeDraw
          ? _questionController.text.trim()
          : null,
      allowReversed: settings.allowReversedCards,
    );
    await Future.wait([minAnimationTime, draw]);

    if (!mounted) return;
    setState(() => _shuffling = false);
  }

  void _startOver() {
    context.read<ReadingProvider>().reset();
    _questionController.clear();
    setState(() {
      _shuffling = false;
      _revealed = false;
      _significatorCard = null;
      _significatorStepDone = false;
      _cleansingTaps = 0;
      _cleansingStepDone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readingProvider = context.watch<ReadingProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final deckProvider = context.watch<DeckProvider>();
    final reading = readingProvider.reading;
    final l10n = AppLocalizations.of(context)!;

    final needsSignificator =
        settingsProvider.useSignificatorCard && !_significatorStepDone;
    final needsCleansing =
        settingsProvider.deckCleansingRitual &&
        !needsSignificator &&
        !_cleansingStepDone;

    return AppScaffold(
      title: spreadName(context, widget.spread),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (reading == null && !_shuffling) ...[
              if (needsSignificator)
                _SignificatorStep(
                  deck: deckProvider.cards,
                  onPicked: (card) => setState(() {
                    _significatorCard = card;
                    _significatorStepDone = true;
                  }),
                )
              else if (needsCleansing)
                _CleansingRitualStep(
                  taps: _cleansingTaps,
                  onTap: () => setState(() {
                    _cleansingTaps++;
                    if (_cleansingTaps >= 3) _cleansingStepDone = true;
                  }),
                )
              else
                _ShuffleIntro(
                  spread: widget.spread,
                  onShuffle: _beginShuffle,
                  significatorCard: _significatorCard,
                  requireQuestion: settingsProvider.askQuestionBeforeDraw,
                  questionController: _questionController,
                  showMoonPhase: settingsProvider.showMoonPhase,
                ),
            ],
            if (_shuffling) const _ShufflingIndicator(),
            if (reading != null && !_shuffling) ...[
              SpreadLayoutWidget(
                spread: widget.spread,
                drawnCards: reading.drawnCards,
                isRevealed: _revealed,
              ),
              const SizedBox(height: 20),
              if (!_revealed)
                FilledButton.icon(
                  icon: const Icon(Icons.visibility_outlined),
                  label: Text(l10n.revealCardsButton),
                  onPressed: () => setState(() => _revealed = true),
                )
              else ...[
                if (settingsProvider.enableAiInterpretation) ...[
                  _InterpretationSection(
                    reading: reading,
                    readingProvider: readingProvider,
                    settingsProvider: settingsProvider,
                  ),
                  const SizedBox(height: 12),
                ],
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.newReadingButton),
                  onPressed: _startOver,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SignificatorStep extends StatefulWidget {
  const _SignificatorStep({required this.deck, required this.onPicked});

  final List<TarotCard> deck;
  final ValueChanged<TarotCard> onPicked;

  @override
  State<_SignificatorStep> createState() => _SignificatorStepState();
}

class _SignificatorStepState extends State<_SignificatorStep> {
  static const _fanSize = 5;

  List<TarotCard>? _options;
  int? _tappedIndex;

  @override
  void didUpdateWidget(covariant _SignificatorStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureOptions();
  }

  @override
  void initState() {
    super.initState();
    _ensureOptions();
  }

  void _ensureOptions() {
    if (_options != null || widget.deck.isEmpty) return;
    final shuffled = List<TarotCard>.from(widget.deck)
      ..shuffle(Random.secure());
    _options = shuffled.take(_fanSize).toList();
  }

  void _handleTap(int index) {
    if (_tappedIndex != null) return;
    setState(() => _tappedIndex = index);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      widget.onPicked(_options![index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;
    final l10n = AppLocalizations.of(context)!;
    if (options == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            l10n.significatorChooseCardPrompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var i = 0; i < options.length; i++)
                GestureDetector(
                  onTap: () => _handleTap(i),
                  child: TarotCardWidget(
                    card: options[i],
                    isRevealed: _tappedIndex == i,
                    width: 80,
                    height: 130,
                  ),
                ),
            ],
          ),
          if (_tappedIndex != null) ...[
            const SizedBox(height: 16),
            Text(
              l10n.significatorCardChosen(options[_tappedIndex!].name),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _CleansingRitualStep extends StatelessWidget {
  const _CleansingRitualStep({required this.taps, required this.onTap});

  final int taps;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(
            l10n.cleansingRitualPrompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onTap,
            child: const CardBackFace(width: 110, height: 170),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.cleansingTapsCounter(taps),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _ShuffleIntro extends StatelessWidget {
  const _ShuffleIntro({
    required this.spread,
    required this.onShuffle,
    this.significatorCard,
    this.requireQuestion = false,
    this.questionController,
    this.showMoonPhase = false,
  });

  final Spread spread;
  final VoidCallback onShuffle;
  final TarotCard? significatorCard;
  final bool requireQuestion;
  final TextEditingController? questionController;
  final bool showMoonPhase;

  @override
  Widget build(BuildContext context) {
    final controller = questionController;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          if (showMoonPhase) ...[
            const _MoonPhaseBadge(),
            const SizedBox(height: 12),
          ],
          if (significatorCard != null) ...[
            Text(
              l10n.significatorCardChosen(significatorCard!.name),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 12),
          ],
          const CardBackFace(width: 110, height: 170),
          const SizedBox(height: 20),
          Text(
            l10n.shuffleIntroPrompt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (requireQuestion && controller != null) ...[
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.questionInputLabel,
                border: const OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
          const SizedBox(height: 20),
          if (requireQuestion && controller != null)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) => FilledButton.icon(
                icon: const Icon(Icons.shuffle),
                label: Text(l10n.shuffleButton),
                onPressed: value.text.trim().isEmpty ? null : onShuffle,
              ),
            )
          else
            FilledButton.icon(
              icon: const Icon(Icons.shuffle),
              label: Text(l10n.shuffleButton),
              onPressed: onShuffle,
            ),
        ],
      ),
    );
  }
}

class _MoonPhaseBadge extends StatelessWidget {
  const _MoonPhaseBadge();

  @override
  Widget build(BuildContext context) {
    final phase = MoonPhase.phaseFor(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(MoonPhase.emojiFor(phase), style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 6),
        Text(
          MoonPhase.labelFor(context, phase),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _ShufflingIndicator extends StatelessWidget {
  const _ShufflingIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const ShuffleAnimationWidget(),
          const SizedBox(height: 12),
          Text(
            l10n.shufflingIndicatorText,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _InterpretationSection extends StatelessWidget {
  const _InterpretationSection({
    required this.reading,
    required this.readingProvider,
    required this.settingsProvider,
  });

  final Reading reading;
  final ReadingProvider readingProvider;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    final status = readingProvider.interpretationStatus;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ProviderSelector(
          selected: settingsProvider.selectedProvider,
          onChanged: (p) => context.read<SettingsProvider>().selectProvider(p),
        ),
        const SizedBox(height: 12),
        if (status == InterpretationStatus.idle)
          FilledButton.icon(
            icon: const Icon(Icons.auto_fix_high),
            label: Text(l10n.interpretWithAiButton),
            onPressed: () => readingProvider.requestInterpretation(
              settingsProvider.selectedProvider,
              positionLabel: (position) =>
                  positionLabel(context, reading.spread, position),
              noQuestionText: l10n.promptNoQuestionText,
              questionIntro: l10n.promptQuestionIntro,
              cardsIntro: l10n.promptCardsIntro,
              closingQuestion: l10n.promptClosingQuestion,
              orientationUpright: l10n.promptOrientationUpright,
              orientationReversed: l10n.promptOrientationReversed,
            ),
          ),
        if (status == InterpretationStatus.loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CircularProgressIndicator(),
          ),
        if (status == InterpretationStatus.success)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(reading.aiInterpretation ?? ''),
            ),
          ),
        if (status == InterpretationStatus.copiedToClipboard)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_noticeText(l10n, readingProvider)),
            ),
          ),
        if (status == InterpretationStatus.error)
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.interpretationErrorMessage(
                  readingProvider.interpretationError ?? '',
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _noticeText(AppLocalizations l10n, ReadingProvider readingProvider) {
    switch (readingProvider.interpretationNoticeKind) {
      case AiNoticeKind.webFallbackAfterError:
        return l10n.aiWebFallbackAfterErrorNotice(
          readingProvider.interpretationNoticeProviderName ?? '',
        );
      case AiNoticeKind.clipboardCopied:
      case null:
        return l10n.aiClipboardCopiedNotice;
    }
  }
}
