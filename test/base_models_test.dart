import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/base/base.dart';
import 'package:flutter_prakash_core/src/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

// Concrete implementations for testing abstract contracts
class UserTestModel extends BaseModel with JsonSerializableMixin {
  final int id;
  final String name;

  const UserTestModel({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  @override
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class TestRepository extends BaseRepository {
  Future<String> fetchRemoteData() async => 'Clean Architecture Data';
  Future<String> failingData() async =>
      throw const ServerException(message: 'Remote Error');
}

class GetUserUseCase extends UseCase<String, int> {
  final TestRepository repository;
  GetUserUseCase(this.repository);

  @override
  Future<Result<String>> call(int params) {
    return repository.safeCall(() => repository.fetchRemoteData());
  }
}

class FormatUserSyncUseCase extends UseCaseSync<String, String> {
  @override
  Result<String> call(String params) {
    return Result.success('User: $params');
  }
}

class StreamTicksUseCase extends StreamUseCase<int, NoParams> {
  @override
  Stream<Result<int>> call(NoParams params) async* {
    yield const Result.success(1);
    yield const Result.success(2);
  }
}

void main() {
  group('BaseModel & JsonSerializableMixin', () {
    test('BaseModel supports equatable value comparison', () {
      const user1 = UserTestModel(id: 1, name: 'Prakash');
      const user2 = UserTestModel(id: 1, name: 'Prakash');
      const user3 = UserTestModel(id: 2, name: 'Prakash');

      expect(user1, equals(user2));
      expect(user1 == user3, isFalse);
      expect(user1.props, equals([1, 'Prakash']));
    });

    test('JsonSerializableMixin forces toJson contract', () {
      const user = UserTestModel(id: 101, name: 'Developer');
      expect(user.toJson(), equals({'id': 101, 'name': 'Developer'}));
    });
  });

  group('BaseRepository', () {
    final repo = TestRepository();

    test(
      'safeCall wraps successful async operation into Result.success',
      () async {
        final result = await repo.safeCall(() => repo.fetchRemoteData());
        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals('Clean Architecture Data'));
      },
    );

    test(
      'safeCall catches ServerException and wraps in Result.error',
      () async {
        final result = await repo.safeCall(() => repo.failingData());
        expect(result.isError, isTrue);
        expect(result.failureOrNull, isA<ServerFailure>());
        expect(result.failureOrNull?.errorMessage, equals('Remote Error'));
      },
    );
  });

  group('UseCases (Async, Sync, Stream, NoParams)', () {
    final repo = TestRepository();

    test('UseCase executes and returns Future<Result<T>>', () async {
      final useCase = GetUserUseCase(repo);
      final result = await useCase(1);
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals('Clean Architecture Data'));
    });

    test('UseCaseSync executes synchronously', () {
      final syncUseCase = FormatUserSyncUseCase();
      final result = syncUseCase('Prakash');
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals('User: Prakash'));
    });

    test('StreamUseCase emits stream of Results', () async {
      final streamUseCase = StreamTicksUseCase();
      final stream = streamUseCase(const NoParams());
      final items = await stream.toList();

      expect(items.length, equals(2));
      expect(items[0].dataOrNull, equals(1));
      expect(items[1].dataOrNull, equals(2));
    });

    test('NoParams supports equality', () {
      const p1 = NoParams();
      const p2 = NoParams();
      expect(p1, equals(p2));
      expect(p1.props, isEmpty);
    });
  });

  group('LiveData<T>', () {
    test('LiveData holds value, notifies listeners, and disposes safely', () {
      final liveData = LiveData<int>(10);
      expect(liveData.value, equals(10));

      var notified = 0;
      void listener() => notified++;

      liveData.addListener(listener);
      liveData.value = 20;
      expect(notified, equals(1));
      expect(liveData.value, equals(20));

      liveData.removeListener(listener);
      liveData.value = 30;
      expect(notified, equals(1));

      liveData.observe(listener);
      liveData.value = 40;
      expect(notified, equals(2));

      liveData.removeObserver(listener);
      liveData.value = 50;
      expect(notified, equals(2));

      liveData.dispose();
    });

    testWidgets('LiveData builds reactive widget via listen and listens', (
      tester,
    ) async {
      final liveString = LiveData<String>('Initial');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                liveString.listen((val) => Text('Listen: $val')),
                liveString.listens((ctx, val, child) => Text('Listens: $val')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Listen: Initial'), findsOneWidget);
      expect(find.text('Listens: Initial'), findsOneWidget);

      liveString.value = 'Updated';
      await tester.pump();

      expect(find.text('Listen: Updated'), findsOneWidget);
      expect(find.text('Listens: Updated'), findsOneWidget);

      liveString.dispose();
    });
  });
}
