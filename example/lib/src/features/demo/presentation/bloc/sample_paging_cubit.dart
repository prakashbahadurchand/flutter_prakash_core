import 'package:flutter_prakash/flutter_prakash.dart';

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

/// Sample Paging Cubit demonstrating zero-boilerplate infinite pagination.
class SamplePagingCubit extends BasePagingCubit<SampleUser> {
  SamplePagingCubit() : super(pageSize: 10);

  @override
  Future<Result<List<SampleUser>>> fetchPage(int page, int pageSize) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate page limit
    if (page > 4) {
      return const Result.success([]);
    }

    final users = List.generate(pageSize, (i) {
      final index = (page - 1) * pageSize + i + 1;
      return SampleUser(
        id: 'user-$index',
        name: '${Fake.fullName} #$index',
        email: Fake.email,
      );
    });

    return Result.success(users);
  }
}
