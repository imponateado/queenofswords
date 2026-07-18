import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/spreads_repository.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/reading.dart';
import '../providers/history_provider.dart';
import '../widgets/app_scaffold.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          context.read<HistoryProvider>().load(Localizations.localeOf(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.historyTitle,
      actions: [
        if (historyProvider.readings.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: l10n.clearHistoryTooltip,
            onPressed: () => historyProvider.clear(),
          ),
      ],
      body: historyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyProvider.readings.isEmpty
          ? Center(
              child: Text(
                l10n.historyEmptyState,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: historyProvider.readings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final reading = historyProvider.readings[index];
                return _HistoryTile(reading: reading);
              },
            ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.reading});

  final Reading reading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateLabel = DateFormat('dd/MM/yyyy HH:mm').format(reading.createdAt);
    final cardNames = reading.drawnCards.map((d) => d.card.name).join(', ');
    final title = spreadName(context, reading.spread);

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          '$dateLabel\n$cardNames',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => context.read<HistoryProvider>().delete(reading.id),
        ),
        onTap: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Text(
                reading.aiInterpretation ?? l10n.historyNoAiInterpretation,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.closeButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
