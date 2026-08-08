import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_app/services/update_checker_service.dart';

void main() {
  group('UpdateCheckerService.isNewerVersion', () {
    test('detects a newer patch/minor/major version', () {
      expect(UpdateCheckerService.isNewerVersion('1.0.3', '1.0.2'), isTrue);
      expect(UpdateCheckerService.isNewerVersion('1.1.0', '1.0.9'), isTrue);
      expect(UpdateCheckerService.isNewerVersion('2.0.0', '1.9.9'), isTrue);
    });

    test('equal or older version is not newer', () {
      expect(UpdateCheckerService.isNewerVersion('1.0.2', '1.0.2'), isFalse);
      expect(UpdateCheckerService.isNewerVersion('1.0.1', '1.0.2'), isFalse);
    });

    test('malformed input never throws and is treated as not newer', () {
      expect(UpdateCheckerService.isNewerVersion('abc', '1.0.2'), isFalse);
      expect(UpdateCheckerService.isNewerVersion('1.0.2', 'abc'), isFalse);
      expect(UpdateCheckerService.isNewerVersion('1.0', '1.0.2'), isFalse);
    });
  });
}
