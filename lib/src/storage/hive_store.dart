import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Object-store wrapper over [hive_ce] boxes.
///
/// Use [init] before reading/writing. [openBox<T>] returns a typed box for
/// persisting structured JSON-serializable models.
class HiveStore {
  HiveStore._();
  static final HiveStore instance = HiveStore._();

  bool _initialized = false;

  Future<void> init([String? overrideDirectory]) async {
    if (_initialized) return;
    final dir =
        overrideDirectory ?? (await getApplicationDocumentsDirectory()).path;
    Hive.init(dir);
    await Hive.openBox<dynamic>('default');
    _initialized = true;
  }

  /// Opens (or retrieves) a [Box] with a custom type adapter.
  Future<Box<T>> openBox<T>(String name, [TypeAdapter<T>? adapter]) async {
    if (!_initialized) await init();
    if (adapter != null && !Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
    if (!Hive.isBoxOpen(name)) {
      await Hive.openBox<T>(name);
    }
    return Hive.box<T>(name);
  }

  Future<Box<dynamic>> defaultBox() async {
    if (!_initialized) await init();
    return Hive.box<dynamic>('default');
  }

  Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}
