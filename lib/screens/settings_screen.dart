import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/ai_provider_config.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/provider_selector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<SettingsProvider>().load(),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final config = AiProviderConfig.all[settings.selectedProvider]!;
    final hasKey = settings.hasApiKey(settings.selectedProvider);
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.appearanceSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.appearanceSectionSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.themeModeSystem),
                icon: const Icon(Icons.brightness_auto_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.themeModeLight),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.themeModeDark),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (selection) =>
                settings.setThemeMode(selection.first),
          ),
          const Divider(height: 40),
          Text(
            l10n.aiProviderSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.aiProviderSectionSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          ProviderSelector(
            selected: settings.selectedProvider,
            onChanged: (p) {
              settings.selectProvider(p);
              _apiKeyController.clear();
            },
          ),
          const SizedBox(height: 24),
          Text(
            l10n.apiKeySectionTitle(config.displayName),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            hasKey
                ? l10n.apiKeyStoredNotice
                : l10n.apiKeyMissingNotice(config.displayName),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _apiKeyController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: l10n.apiKeyInputLabel,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton(
                onPressed: _apiKeyController.text.trim().isEmpty
                    ? null
                    : () {
                        settings.setApiKey(
                          settings.selectedProvider,
                          _apiKeyController.text.trim(),
                        );
                        _apiKeyController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.apiKeySavedSnackbar)),
                        );
                      },
                child: Text(l10n.saveButton),
              ),
              const SizedBox(width: 8),
              if (hasKey)
                OutlinedButton(
                  onPressed: () {
                    settings.clearApiKey(settings.selectedProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.apiKeyRemovedSnackbar)),
                    );
                  },
                  child: Text(l10n.removeButton),
                ),
            ],
          ),
          if (kIsWeb) ...[
            const SizedBox(height: 8),
            Text(
              l10n.webStorageWarning,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          const Divider(height: 40),
          Text(
            l10n.readingRitualSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.readingRitualSectionSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SwitchListTile(
            title: Text(l10n.askQuestionTitle),
            subtitle: Text(l10n.askQuestionSubtitle),
            value: settings.askQuestionBeforeDraw,
            onChanged: settings.setAskQuestionBeforeDraw,
          ),
          SwitchListTile(
            title: Text(l10n.deckCleansingTitle),
            subtitle: Text(l10n.deckCleansingSubtitle),
            value: settings.deckCleansingRitual,
            onChanged: settings.setDeckCleansingRitual,
          ),
          SwitchListTile(
            title: Text(l10n.reversedCardsTitle),
            subtitle: Text(l10n.reversedCardsSubtitle),
            value: settings.allowReversedCards,
            onChanged: settings.setAllowReversedCards,
          ),
          SwitchListTile(
            title: Text(l10n.significatorTitle),
            subtitle: Text(l10n.significatorSubtitle),
            value: settings.useSignificatorCard,
            onChanged: settings.setUseSignificatorCard,
          ),
          SwitchListTile(
            title: Text(l10n.moonPhaseTitle),
            subtitle: Text(l10n.moonPhaseSubtitle),
            value: settings.showMoonPhase,
            onChanged: settings.setShowMoonPhase,
          ),
          const Divider(height: 40),
          Text(
            l10n.aboutSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.aboutDisclaimerText,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
