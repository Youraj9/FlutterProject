import 'package:flutter_test/flutter_test.dart';
import 'package:sideproject/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('app theme uses Plus Jakarta Sans with readable body sizes', () {
    final textTheme = AppTheme.light.textTheme;

    expect(textTheme.bodySmall?.fontFamily, startsWith('PlusJakartaSans'));
    expect(textTheme.bodyMedium?.fontFamily, startsWith('PlusJakartaSans'));
    expect(textTheme.bodyLarge?.fontFamily, startsWith('PlusJakartaSans'));
    expect(textTheme.bodySmall?.fontSize, 14);
    expect(textTheme.bodyMedium?.fontSize, 15);
    expect(textTheme.bodyLarge?.fontSize, 16);
  });
}
