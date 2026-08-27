import 'package:flutter_prakash_core_example/features/common/data/models/legal_document_model.dart';

sealed class LegalState {
  const LegalState();
}

final class LegalInitial extends LegalState {
  const LegalInitial();
}

final class LegalLoading extends LegalState {
  const LegalLoading();
}

final class LegalLoaded extends LegalState {
  final LegalDocumentModel document;
  const LegalLoaded(this.document);
}

final class LegalFailure extends LegalState {
  final String message;
  const LegalFailure(this.message);
}
