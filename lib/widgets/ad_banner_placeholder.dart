import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// The app's single, fixed ad slot. Deliberately just a styled placeholder —
/// no ad network is wired up yet. When one is added later (e.g.
/// google_mobile_ads / AdSense), only this widget's internals change.
class AdBannerPlaceholder extends StatelessWidget {
  const AdBannerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      color: colorScheme.surfaceContainerHighest,
      child: Text(
        AppLocalizations.of(context)!.adPlaceholderLabel,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
