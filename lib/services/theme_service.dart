import 'dart:convert';
import 'dart:io';

class ThemeService {
  static final ThemeService _s = ThemeService._();
  factory ThemeService() => _s;

  ThemeService._();

  static const _file = 'data/theme.json';
  bool _dark = false;

  bool get dark => _dark;

  Future<void> init() async {
    final f = File(_file);
    if (await f.exists()) {
      final raw = await f.readAsString();
      if (raw.trim().isNotEmpty) _dark = json.decode(raw) as bool;
    } else {
      await _persist(false);
    }
  }

  Future<void> toggle() async {
    _dark = !_dark;
    await _persist(_dark);
  }

  Future<void> setDark(bool value) async {
    _dark = value;
    await _persist(_dark);
  }

  Future<void> _persist(bool value) async {
    final f = File(_file);
    await f.create(recursive: true);
    await f.writeAsString(value ? '1' : '0');
  }
}
