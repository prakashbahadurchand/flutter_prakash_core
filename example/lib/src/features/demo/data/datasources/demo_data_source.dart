import 'package:injectable/injectable.dart';
import 'package:flutter_prakash_example/src/features/demo/data/models/sample_item_model.dart';

@lazySingleton
class DemoDataSource {
  Future<List<SampleItemModel>> fetchItems({int page = 1, int pageSize = 10}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return List.generate(
      pageSize,
      (index) {
        final itemId = (page - 1) * pageSize + index + 1;
        return SampleItemModel(
          id: itemId,
          title: 'Enterprise Core Sample #$itemId',
          description:
              'High-performance clean architecture data item #$itemId fetched via DemoDataSource.',
          category: itemId % 2 == 0 ? 'Network' : 'Storage',
        );
      },
    );
  }

  Future<SampleItemModel> submitForm({
    required String title,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    return SampleItemModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      category: 'Submitted',
    );
  }
}
