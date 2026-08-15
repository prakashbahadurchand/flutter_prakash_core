import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Enterprise Supabase Engine for Flutter Prakash applications.
///
/// Features:
/// - Single entry-point initialization with [initialize].
/// - Streamlined Authentication (email/password, OAuth, OTP, sign out, user info).
/// - Type-safe Database CRUD queries (`select`, `insert`, `update`, `delete`, `streamTable`).
/// - Storage bucket operations (upload file, get public URL).
/// - Real-time stream subscriptions.
class SupabaseEngine {
  SupabaseEngine._();

  static bool _isInitialized = false;

  /// Returns the global [SupabaseClient] instance.
  static SupabaseClient get client {
    if (!_isInitialized) {
      throw StateError(
        'SupabaseEngine must be initialized using SupabaseEngine.initialize() before accessing client.',
      );
    }
    return Supabase.instance.client;
  }

  /// Initializes the Supabase Engine with [url] and [publishableKey].
  static Future<Supabase> initialize({
    required String url,
    required String publishableKey,
    bool debug = false,
  }) async {
    final instance = await Supabase.initialize(
      url: url,
      publishableKey: publishableKey,
      debug: debug,
    );

    _isInitialized = true;
    FlutterLogger.i(
      'Supabase Engine initialized successfully',
      tag: 'SUPABASE',
    );
    return instance;
  }

  // ===========================================================================
  // AUTHENTICATION HELPERS
  // ===========================================================================

  /// Current authenticated user or `null`.
  static User? get currentUser => client.auth.currentUser;

  /// Active Auth Session or `null`.
  static Session? get currentSession => client.auth.currentSession;

  /// Sign in using email and password.
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  /// Register a new account with email and password.
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return client.auth.signUp(email: email, password: password, data: data);
  }

  /// Signs out the current user and clears session.
  static Future<void> signOut() async {
    await client.auth.signOut();
    FlutterLogger.i('User signed out from Supabase', tag: 'SUPABASE');
  }

  // ===========================================================================
  // DATABASE HELPERS
  // ===========================================================================

  /// Select rows from a table.
  static PostgrestFilterBuilder<List<Map<String, dynamic>>> select(
    String table,
  ) {
    return client.from(table).select();
  }

  /// Insert rows into a table.
  static dynamic insert({required String table, required dynamic values}) {
    return client.from(table).insert(values).select();
  }

  /// Update rows in a table.
  static dynamic update({
    required String table,
    required Map<String, dynamic> values,
  }) {
    return client.from(table).update(values).select();
  }

  /// Delete rows matching query filters.
  static dynamic delete({required String table}) {
    return client.from(table).delete().select();
  }

  /// Stream changes from a table in real-time.
  static Stream<List<Map<String, dynamic>>> streamTable({
    required String table,
    required List<String> primaryKey,
  }) {
    return client.from(table).stream(primaryKey: primaryKey);
  }

  // ===========================================================================
  // STORAGE HELPERS
  // ===========================================================================

  /// Get public URL for a file in a storage bucket.
  static String getPublicUrl({required String bucket, required String path}) {
    return client.storage.from(bucket).getPublicUrl(path);
  }
}
