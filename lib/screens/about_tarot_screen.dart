import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../widgets/app_scaffold.dart';

class AboutTarotScreen extends StatelessWidget {
  const AboutTarotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.aboutTarotTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.aboutTarotHeading1, style: titleStyle),
          const SizedBox(height: 8),
          Text(l10n.aboutTarotBody1, style: bodyStyle),
          const SizedBox(height: 24),
          Text(l10n.aboutTarotHeading2, style: titleStyle),
          const SizedBox(height: 8),
          Text(l10n.aboutTarotBody2, style: bodyStyle),
          const SizedBox(height: 24),
          Text(l10n.aboutTarotHeading3, style: titleStyle),
          const SizedBox(height: 8),
          Text(l10n.aboutTarotBody3, style: bodyStyle),
          const SizedBox(height: 24),
          Text(l10n.aboutTarotHeading4, style: titleStyle),
          const SizedBox(height: 8),
          Text(l10n.aboutTarotBody4, style: bodyStyle),
        ],
      ),
    );
  }
}
