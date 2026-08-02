/// Abstract Base Data Source interface contract for Remote and Local Data Sources.
abstract class BaseDataSource {
  const BaseDataSource();
}

/// Abstract contract for Remote Data Sources.
abstract class BaseRemoteDataSource extends BaseDataSource {
  const BaseRemoteDataSource();
}

/// Abstract contract for Local Data Sources.
abstract class BaseLocalDataSource extends BaseDataSource {
  const BaseLocalDataSource();
}
