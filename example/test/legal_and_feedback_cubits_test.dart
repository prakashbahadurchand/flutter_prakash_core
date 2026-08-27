import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core_example/features/common/data/datasources/common_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/common/data/repositories/common_repository.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/feedback_cubit.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/legal_cubit.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/legal_state.dart';

void main() {
  late CommonLocalDataSource localDataSource;
  late CommonRepository repository;

  setUp(() {
    localDataSource = const CommonLocalDataSource();
    repository = CommonRepository(localDataSource);
  });

  group('LegalCubit', () {
    test('loadPrivacyPolicy emits LegalLoaded', () async {
      final cubit = LegalCubit(repository);
      await cubit.loadPrivacyPolicy();

      expect(cubit.state, isA<LegalLoaded>());
      final state = cubit.state as LegalLoaded;
      expect(state.document.title, contains('Privacy Policy'));
      cubit.close();
    });

    test('loadTermsAndConditions emits LegalLoaded', () async {
      final cubit = LegalCubit(repository);
      await cubit.loadTermsAndConditions();

      expect(cubit.state, isA<LegalLoaded>());
      final state = cubit.state as LegalLoaded;
      expect(state.document.title, contains('Terms'));
      cubit.close();
    });
  });

  group('FeedbackCubit', () {
    test('validates form and submits', () async {
      final cubit = FeedbackCubit(repository);
      expect(cubit.state.isFormValid, isFalse);

      cubit.onEmailChanged('user@example.com');
      cubit.onFeedbackChanged('Great Clean Architecture implementation!');

      expect(cubit.state.isFormValid, isTrue);

      await cubit.submit();

      expect(cubit.state.status.isSuccess, isTrue);
      cubit.close();
    });
  });
}
