import 'dart:math';

import 'random_service.dart';

/// Fisher-Yates shuffle backed by a cryptographically secure PRNG.
/// Always available on every platform — used as the fallback whenever
/// [RandomOrgService]'s network call fails (offline, timeout, malformed or
/// too-short response), on every platform including Flutter Web, where
/// random.org is tried first same as everywhere else.
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
