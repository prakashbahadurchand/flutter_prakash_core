import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/sample_user_model.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/repositories/dashboard_repository.dart';

@injectable
class SamplePagingCubit extends BasePagingCubit<SampleUser> {
  final DashboardRepository _repository;

  SamplePagingCubit(this._repository) : super(pageSize: 10);

  @override
  Future<Result<List<SampleUser>>> fetchPage(int page, int pageSize) {
    return _repository.fetchUsersPage(
      page: page,
      pageSize: pageSize,
    );
  }
}
