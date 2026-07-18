import 'package:dio/dio.dart';

import 'local_secure_random_service.dart';
import 'random_service.dart';

enum LastDrawSource { randomOrg, localSecure }

/// Draws card indices using random.org's free, keyless "sequences" endpoint,
/// which returns a true-random permutation with no duplicates.
///
/// Verified empirically (not just from docs): this endpoint responds with
/// `Access-Control-Allow-Origin: *`, so it works fine from a Flutter Web
/// browser call too — no proxy needed on any platform. Any failure (offline,
/// timeout, rate limit, malformed response, or a future CORS policy change)
/// falls back to [LocalSecureRandomService] transparently, so a draw can
/// never fail outright.
class RandomOrgService implements RandomService {
  RandomOrgService({Dio? dio, LocalSecureRandomService? fallback})
    : _dio = dio ?? Dio(),
      _fallback = fallback ?? LocalSecureRandomService();

  final Dio _dio;
  final LocalSecureRandomService _fallback;

  LastDrawSource lastDrawSource = LastDrawSource.localSecure;

  @override
  Future<List<int>> drawCardIndices(int count, int deckSize) async {
    try {
      final response = await _dio
          .get<String>(
            'https://www.random.org/sequences/',
            queryParameters: {
              'min': 0,
              'max': deckSize - 1,
              'col': 1,
              'format': 'plain',
              'rnd': 'new',
            },
          )
          .timeout(const Duration(seconds: 5));

      final body = response.data;
      if (body == null) throw const FormatException('empty response');

      final permutation = body
          .trim()
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map(int.parse)
          .toList();

      if (permutation.length < count) {
        throw const FormatException('short response from random.org');
      }

      lastDrawSource = LastDrawSource.randomOrg;
      return permutation.take(count).toList();
    } catch (_) {
      lastDrawSource = LastDrawSource.localSecure;
      return _fallback.drawCardIndices(count, deckSize);
    }
  }
}
