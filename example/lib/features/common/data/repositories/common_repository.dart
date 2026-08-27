import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/common/data/datasources/common_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/common/data/models/legal_document_model.dart';

@lazySingleton
class CommonRepository {
  final CommonLocalDataSource _localDataSource;

  const CommonRepository(this._localDataSource);

  FutureResult<LegalDocumentModel> getPrivacyPolicy() {
    return Result.fromAsync(call: () => _localDataSource.getPrivacyPolicy());
  }

  FutureResult<LegalDocumentModel> getTermsAndConditions() {
    return Result.fromAsync(call: () => _localDataSource.getTermsAndConditions());
  }
}
