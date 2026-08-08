import 'package:dio/dio.dart';

class UpdateInfo {
  const UpdateInfo({required this.version, required this.releaseUrl});

  final String version;
  final String releaseUrl;
}

/// Checks GitHub Releases for a newer published version of the app than
/// [currentVersion]. Mirrors [RandomOrgService]'s philosophy: any failure
/// (offline, timeout, rate limit, malformed response) degrades silently to
/// "no update found" rather than surfacing an error — this is a best-effort
/// background check with no user-initiated action to report failure against.
///
/// ponytail: checks hit the GitHub API unauthenticated (60 req/hour per IP)
/// on every call with no caching. Fine for this app's scale; if that ever
/// becomes a problem, cache the last check's timestamp/version (e.g. in
/// shared_preferences) and skip re-checking within a cooldown window.
class UpdateCheckerService {
  UpdateCheckerService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _latestReleaseUrl =
      'https://api.github.com/repos/imponateado/queenofswords/releases/latest';

  Future<UpdateInfo?> checkForUpdate(String currentVersion) async {
    try {
      final response = await _dio
          .get<Map<String, dynamic>>(_latestReleaseUrl)
          .timeout(const Duration(seconds: 5));

      final tag = response.data?['tag_name'] as String?;
      final url = response.data?['html_url'] as String?;
      if (tag == null || url == null) return null;

      final latest = tag.startsWith('v') ? tag.substring(1) : tag;
      if (!isNewerVersion(latest, currentVersion)) return null;

      return UpdateInfo(version: latest, releaseUrl: url);
    } catch (_) {
      return null;
    }
  }

  /// Compares two `major.minor.patch` version strings. Public and
  /// network-free so it's testable in isolation. Any unexpected format
  /// (not exactly 3 numeric parts) is treated as "not newer" rather than
  /// throwing, so a surprising tag format never bothers the user.
  static bool isNewerVersion(String latest, String current) {
    final latestParts = _parse(latest);
    final currentParts = _parse(current);
    if (latestParts == null || currentParts == null) return false;

    for (var i = 0; i < 3; i++) {
      if (latestParts[i] != currentParts[i]) {
        return latestParts[i] > currentParts[i];
      }
    }
    return false;
  }

  static List<int>? _parse(String version) {
    final parts = version.split('.');
    if (parts.length != 3) return null;
    final ints = parts.map(int.tryParse).toList();
    if (ints.any((n) => n == null)) return null;
    return ints.cast<int>();
  }
}
