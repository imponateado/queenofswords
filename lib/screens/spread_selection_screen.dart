import 'package:flutter/material.dart';

import '../data/spreads_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/spread.dart';
import '../widgets/app_scaffold.dart';
import 'reading_screen.dart';

class SpreadSelectionScreen extends StatelessWidget {
  const SpreadSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.spreadSelectionTitle,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: SpreadsRepository.all.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final spread = SpreadsRepository.all[index];
          return _SpreadCard(spread: spread);
        },
      ),
    );
  }
}

class _SpreadCard extends StatelessWidget {
  const _SpreadCard({required this.spread});

  final Spread spread;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          spreadName(context, spread),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(spreadDescription(context, spread)),
        trailing: Chip(label: Text(l10n.cardCountLabel(spread.cardCount))),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ReadingScreen(spread: spread)),
        ),
      ),
    );
  }
}
