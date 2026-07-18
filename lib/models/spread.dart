import 'package:equatable/equatable.dart';

/// Structural data only. Localized display text (name, description, position
/// label/meaning) is resolved separately at render time — see the
/// `spreadName`/`spreadDescription`/`positionLabel`/`positionMeaning` helper
/// functions in `spreads_repository.dart`, which take a `BuildContext` and
/// look the text up via the generated `AppLocalizations`.
class SpreadPosition extends Equatable {
  final String id;

  const SpreadPosition({required this.id});

  @override
  List<Object?> get props => [id];
}

class Spread extends Equatable {
  final String id;
  final List<SpreadPosition> positions;

  const Spread({required this.id, required this.positions});

  int get cardCount => positions.length;

  @override
  List<Object?> get props => [id, positions];
}
