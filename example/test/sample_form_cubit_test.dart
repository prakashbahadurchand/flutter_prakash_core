import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/sample_form_cubit.dart';

void main() {
  late DashboardLocalDataSource localDataSource;
  late DashboardRemoteDataSource remoteDataSource;
  late DashboardRepository repository;

  setUp(() {
    localDataSource = DashboardLocalDataSource();
    remoteDataSource = DashboardRemoteDataSource();
    repository = DashboardRepository(localDataSource, remoteDataSource);
  });

  group('SampleFormCubit', () {
    test('validates fields and submits', () async {
      final cubit = SampleFormCubit(repository);
      expect(cubit.state.isFormValid, isFalse);

      cubit.onFullNameChanged('Prakash');
      cubit.onEmailChanged('prakash@example.com');
      cubit.onPasswordChanged('password123');

      expect(cubit.state.isFormValid, isTrue);

      await cubit.submit();

      expect(cubit.state.status.isSuccess, isTrue);
      cubit.close();
    });
  });
}
