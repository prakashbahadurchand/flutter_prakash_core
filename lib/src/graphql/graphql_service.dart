import 'package:graphql_flutter/graphql_flutter.dart';
import '../core/result/result.dart';
import '../core/errors/failures.dart';

class GraphQLConfig {
  final String httpEndpoint;
  final String? wsEndpoint;
  final Future<String?> Function()? getToken;

  const GraphQLConfig({
    required this.httpEndpoint,
    this.wsEndpoint,
    this.getToken,
  });
}

class GraphQLService {
  final GraphQLConfig config;
  late final GraphQLClient client;

  GraphQLService({required this.config});

  Future<void> init() async {
    final HttpLink httpLink = HttpLink(config.httpEndpoint);

    Link link = httpLink;

    if (config.getToken != null) {
      final AuthLink authLink = AuthLink(
        getToken: () async => await config.getToken!(),
      );
      link = authLink.concat(httpLink);
    }

    if (config.wsEndpoint != null) {
      final WebSocketLink wsLink = WebSocketLink(config.wsEndpoint!);
      link = Link.split((request) => request.isSubscription, wsLink, link);
    }

    client = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  Future<Result<Map<String, dynamic>>> query(
    String document, {
    Map<String, dynamic> variables = const {},
  }) async {
    try {
      final options = QueryOptions(
        document: gql(document),
        variables: variables,
      );
      final result = await client.query(options);

      if (result.hasException) {
        return Result.failure(ServerFailure(result.exception.toString()));
      }
      return Result.success(result.data ?? {});
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<Map<String, dynamic>>> mutate(
    String document, {
    Map<String, dynamic> variables = const {},
  }) async {
    try {
      final options = MutationOptions(
        document: gql(document),
        variables: variables,
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        return Result.failure(ServerFailure(result.exception.toString()));
      }
      return Result.success(result.data ?? {});
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
