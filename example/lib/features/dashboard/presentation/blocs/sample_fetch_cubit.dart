import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/repositories/dashboard_repository.dart';

@injectable
class SampleFetchCubit extends BaseUiCubit<List<String>> {
  final DashboardRepository _repository;

  SampleFetchCubit(this._repository);

  @postConstruct
  void init() {
    fetchFeatures();
  }

  Future<void> fetchFeatures() async {
    await executeResult(call: () => _repository.fetchFeatures());
  }
}
