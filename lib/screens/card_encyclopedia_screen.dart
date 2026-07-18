import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/tarot_card.dart';
import '../providers/deck_provider.dart';
import '../utils/suit_label.dart';
import '../widgets/app_scaffold.dart';
import 'card_detail_screen.dart';

class CardEncyclopediaScreen extends StatefulWidget {
  const CardEncyclopediaScreen({super.key});

  @override
  State<CardEncyclopediaScreen> createState() => _CardEncyclopediaScreenState();
}

class _CardEncyclopediaScreenState extends State<CardEncyclopediaScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<DeckProvider>().load(Localizations.localeOf(context)),
    );
    _searchController.addListener(
      () =>
          setState(() => _query = _searchController.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deckProvider = context.watch<DeckProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (deckProvider.isLoading && deckProvider.cards.isEmpty) {
      return AppScaffold(
        title: l10n.cardEncyclopediaTitle,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final filtered = deckProvider.cards
        .where((c) => _query.isEmpty || c.name.toLowerCase().contains(_query))
        .toList();

    final major = filtered.where((c) => c.arcana == Arcana.major).toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    final bySuit = <Suit, List<TarotCard>>{
      for (final suit in Suit.values)
        suit: filtered.where((c) => c.suit == suit).toList()
          ..sort((a, b) => a.number.compareTo(b.number)),
    };

    return AppScaffold(
      title: l10n.cardEncyclopediaTitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.searchCardLabel,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (major.isNotEmpty)
                  _SectionHeader(l10n.majorArcanaSectionTitle),
                for (final card in major) _CardTile(card: card),
                for (final suit in Suit.values)
                  if (bySuit[suit]!.isNotEmpty) ...[
                    _SectionHeader(suitLabel(context, suit)),
                    for (final card in bySuit[suit]!) _CardTile(card: card),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card});

  final TarotCard card;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.style_outlined),
      title: Text(card.name),
      subtitle: Text(card.uprightKeywords.join(', ')),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => CardDetailScreen(card: card))),
    );
  }
}
