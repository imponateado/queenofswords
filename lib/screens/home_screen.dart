import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/update_checker_service.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/tarot_card_widget.dart';
import 'about_tarot_screen.dart';
import 'card_encyclopedia_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'spread_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final update = await UpdateCheckerService().checkForUpdate(
        info.version,
      );
      if (!mounted || update == null) return;

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.updateAvailableNotice(update.version)),
          action: SnackBarAction(
            label: l10n.updateAvailableAction,
            onPressed: () => launchUrl(
              Uri.parse(update.releaseUrl),
              mode: LaunchMode.externalApplication,
            ),
          ),
          duration: const Duration(seconds: 8),
        ),
      );
    } catch (_) {
      // Offline, plugin unavailable (e.g. under test), or any other
      // failure — this is a best-effort check, never worth bothering the
      // user about.
    }
  }

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
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned.fill(child: _ScatteredCardsBackground()),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.homeSubtitle,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
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
            ),
          ),
        ],
      ),
    );
  }
}

/// Card backs scattered across the home screen like a spread laid out on a
/// table. Positions are fixed (not re-randomized per build) so the layout
/// doesn't jump around every time the screen rebuilds.
class _ScatteredCardsBackground extends StatelessWidget {
  const _ScatteredCardsBackground();

  static const _cards = [
    _ScatteredCard(left: 0.04, top: 0.06, angle: -0.35, scale: 0.85),
    _ScatteredCard(left: 0.66, top: 0.02, angle: 0.30, scale: 0.7),
    _ScatteredCard(left: 0.80, top: 0.60, angle: -0.20, scale: 0.9),
    _ScatteredCard(left: 0.06, top: 0.64, angle: 0.42, scale: 0.75),
    _ScatteredCard(left: 0.38, top: 0.76, angle: -0.5, scale: 0.65),
    _ScatteredCard(left: 0.34, top: -0.04, angle: 0.16, scale: 0.6),
    _ScatteredCard(left: -0.08, top: 0.36, angle: 0.6, scale: 0.8),
    _ScatteredCard(left: 0.86, top: 0.30, angle: -0.6, scale: 0.65),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            for (final card in _cards)
              Positioned(
                left: constraints.maxWidth * card.left,
                top: constraints.maxHeight * card.top,
                child: Transform.rotate(
                  angle: card.angle,
                  child: Opacity(
                    opacity: 0.55,
                    child: CardBackFace(
                      width: 120 * card.scale,
                      height: 200 * card.scale,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ScatteredCard {
  const _ScatteredCard({
    required this.left,
    required this.top,
    required this.angle,
    required this.scale,
  });

  final double left;
  final double top;
  final double angle;
  final double scale;
}
