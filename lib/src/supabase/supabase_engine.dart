import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/result/result.dart';
import '../core/errors/failures.dart';

class SupabaseConfig {
  final String url;
  final String publishableKey;

  const SupabaseConfig({required this.url, required this.publishableKey});
}

class SupabaseEngine {
  static Future<void> initialize(SupabaseConfig config) async {
    await Supabase.initialize(
      url: config.url,
      publishableKey: config.publishableKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  // Generic DB Select Helper
  static Future<Result<List<Map<String, dynamic>>>> select(String table) async {
    try {
      final response = await client.from(table).select();
      final data = List<Map<String, dynamic>>.from(response);
      return Result.success(data);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  // Realtime Stream Subscription Helper
  static Stream<List<Map<String, dynamic>>> streamTable(
    String table, {
    required String primaryKey,
  }) {
    return client.from(table).stream(primaryKey: [primaryKey]);
  }
}
