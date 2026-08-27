import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/demo/data/repositories/demo_repository.dart';

/// Sample Cubit demonstrating data-fetching from [DemoRepository] with [BaseUiCubit].
@injectable
class SampleFetchCubit extends BaseUiCubit<List<String>> {
  final DemoRepository _demoRepository;

  SampleFetchCubit(this._demoRepository) {
    fetchFeatures();
  }

  /// Fetches enterprise features list asynchronously using [executeResult].
  Future<void> fetchFeatures() async {
    await executeResult(
      call: () async {
        final result = await _demoRepository.fetchItems(page: 1, pageSize: 12);
        return result.when(
          success: (items) => Result.success(
            items.map((e) => '${e.title}: ${e.description}').toList(),
          ),
          error: (failure) => Result.error(failure),
        );
      },
      onSuccess: (data) {
        emitEffect(
          ShowToastEffect('Loaded ${data.length} enterprise data items'),
        );
      },
    );
  }
}
