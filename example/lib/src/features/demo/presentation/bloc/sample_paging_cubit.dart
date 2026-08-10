import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/features/demo/data/repositories/demo_repository.dart';

/// Sample User Item model for pagination demo.
class SampleUser {
  final String id;
  final String name;
  final String email;

  const SampleUser({
    required this.id,
    required this.name,
    required this.email,
  });
}

/// Sample Paging Cubit demonstrating clean architecture pagination via DemoRepository.
@injectable
class SamplePagingCubit extends BasePagingCubit<SampleUser> {
  final DemoRepository _demoRepository;

  SamplePagingCubit(this._demoRepository) : super(pageSize: 10);

  @override
  Future<Result<List<SampleUser>>> fetchPage(int page, int pageSize) async {
    if (page > 4) {
      return const Result.success([]);
    }

    final result = await _demoRepository.fetchItems(page: page, pageSize: pageSize);
    return result.when(
      success: (items) {
        final users = items
            .map(
              (item) => SampleUser(
                id: 'usr_${item.id}',
                name: item.title,
                email: 'user_${item.id}@prakash.dev',
              ),
            )
            .toList();
        return Result.success(users);
      },
      error: (failure) => Result.error(failure),
    );
  }
}
