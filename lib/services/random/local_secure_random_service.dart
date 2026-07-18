import 'dart:math';

import 'random_service.dart';

/// Fisher-Yates shuffle backed by a cryptographically secure PRNG.
/// Always available on every platform — used both as the primary source
/// of randomness on Flutter Web and as the fallback everywhere else.
class LocalSecureRandomService implements RandomService {
  final Random _rng = Random.secure();

  @override
  Future<List<int>> drawCardIndices(int count, int deckSize) async {
    final indices = List<int>.generate(deckSize, (i) => i);
    for (var i = indices.length - 1; i > 0; i--) {
      final j = _rng.nextInt(i + 1);
      final tmp = indices[i];
      indices[i] = indices[j];
      indices[j] = tmp;
    }
    return indices.take(count).toList();
  }
}
