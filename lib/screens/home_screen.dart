import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../widgets/app_scaffold.dart';
import 'about_tarot_screen.dart';
import 'card_encyclopedia_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'spread_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.homeTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
        ),
      ],
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    l10n.homeTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(l10n.historyTitle),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.aboutTarotTitle),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AboutTarotScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(l10n.cardEncyclopediaTitle),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CardEncyclopediaScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.homeTitle,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.homeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                icon: const Icon(Icons.style_outlined),
                label: Text(l10n.newReadingButton),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SpreadSelectionScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
