import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/demo/data/datasources/demo_data_source.dart';
import 'package:flutter_prakash_core_example/features/demo/data/models/sample_item_model.dart';

@lazySingleton
class DemoRepository {
  final DemoDataSource _dataSource;

  DemoRepository(this._dataSource);

  Future<Result<List<SampleItemModel>>> fetchItems({
    int page = 1,
    int pageSize = 10,
  }) {
    return Result.fromAsync(
      call: () => _dataSource.fetchItems(page: page, pageSize: pageSize),
    );
  }

  Future<Result<SampleItemModel>> submitForm({
    required String title,
    required String description,
  }) {
    return Result.fromAsync(
      call: () =>
          _dataSource.submitForm(title: title, description: description),
    );
  }
}
