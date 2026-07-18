import 'package:flutter/widgets.dart';

import '../l10n/generated/app_localizations.dart';

/// Local, dependency-free calculation of the current moon phase, based on
/// elapsed time since a known reference new moon and the synodic month
/// length. Deliberately scoped to phase name only — void-of-course timing
/// would require real ephemeris data (an external source), which is out of
/// scope here.
enum MoonPhaseName {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent,
}

class MoonPhase {
  MoonPhase._();

  static const double _synodicMonthDays = 29.53058867;
  static final DateTime _referenceNewMoon = DateTime.utc(2000, 1, 6, 18, 14);

  static double _ageInDays(DateTime now) {
    final minutesSinceReference = now
        .toUtc()
        .difference(_referenceNewMoon)
        .inMinutes;
    final days = minutesSinceReference / (60 * 24);
    final age = days % _synodicMonthDays;
    return age < 0 ? age + _synodicMonthDays : age;
  }

  static MoonPhaseName phaseFor(DateTime now) {
    final fraction = _ageInDays(now) / _synodicMonthDays;
    if (fraction < 0.0625) return MoonPhaseName.newMoon;
    if (fraction < 0.1875) return MoonPhaseName.waxingCrescent;
    if (fraction < 0.3125) return MoonPhaseName.firstQuarter;
    if (fraction < 0.4375) return MoonPhaseName.waxingGibbous;
    if (fraction < 0.5625) return MoonPhaseName.fullMoon;
    if (fraction < 0.6875) return MoonPhaseName.waningGibbous;
    if (fraction < 0.8125) return MoonPhaseName.lastQuarter;
    if (fraction < 0.9375) return MoonPhaseName.waningCrescent;
    return MoonPhaseName.newMoon;
  }

  /// Localized display name for [phase]. Requires a [BuildContext] since the
  /// label is resolved via the generated `AppLocalizations`.
  static String labelFor(BuildContext context, MoonPhaseName phase) {
    final l10n = AppLocalizations.of(context)!;
    return switch (phase) {
      MoonPhaseName.newMoon => l10n.moonPhaseNewMoon,
      MoonPhaseName.waxingCrescent => l10n.moonPhaseWaxingCrescent,
      MoonPhaseName.firstQuarter => l10n.moonPhaseFirstQuarter,
      MoonPhaseName.waxingGibbous => l10n.moonPhaseWaxingGibbous,
      MoonPhaseName.fullMoon => l10n.moonPhaseFullMoon,
      MoonPhaseName.waningGibbous => l10n.moonPhaseWaningGibbous,
      MoonPhaseName.lastQuarter => l10n.moonPhaseLastQuarter,
      MoonPhaseName.waningCrescent => l10n.moonPhaseWaningCrescent,
    };
  }

  static String emojiFor(MoonPhaseName phase) => switch (phase) {
    MoonPhaseName.newMoon => '🌑',
    MoonPhaseName.waxingCrescent => '🌒',
    MoonPhaseName.firstQuarter => '🌓',
    MoonPhaseName.waxingGibbous => '🌔',
    MoonPhaseName.fullMoon => '🌕',
    MoonPhaseName.waningGibbous => '🌖',
    MoonPhaseName.lastQuarter => '🌗',
    MoonPhaseName.waningCrescent => '🌘',
  };
}
