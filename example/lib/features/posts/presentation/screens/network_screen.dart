import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator.dart';
import '../../../../shared/widgets/wrappers.dart';
import '../../application/posts_cubit.dart';
import '../../application/posts_state.dart';

/// Presents the Network / REST feature.
///
/// Clean Architecture **presentation** layer: the UI binds to [PostsCubit]
/// and never touches [DioClient] or the repository directly.
class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsCubit>(
      create: (_) => getIt<PostsCubit>(),
      child: DemoScaffold(
        title: 'Network Engine',
        child: Column(
          children: [
            DemoCard(
              title: 'REST (Dio via RestConfig)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wired to https://jsonplaceholder.typicode.com via '
                    'RestConfig. The PostRepositoryImpl adapts Dio responses '
                    'into domain entities and maps errors to Result/Failure.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<PostsCubit, PostsState>(
                    builder: (context, state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton.icon(
                          onPressed: () => context
                              .read<PostsCubit>()
                              .fetch(limit: 3),
                          icon: const Icon(Icons.cloud_download),
                          label: const Text('Fetch top 3 posts'),
                        ),
                        const SizedBox(height: 12),
                        switch (state) {
                          PostsInitial() => const Text('Nothing fetched yet.'),
                          PostsLoading() => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          PostsError(:final message) => Text(
                            message,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          PostsLoaded(:final posts) => Column(
                            children: [
                              for (var i = 0; i < posts.length; i++)
                                ListTile(
                                  dense: true,
                                  leading: CircleAvatar(
                                    child: Text('${posts[i].id}'),
                                  ),
                                  title: Text(
                                    posts[i].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    posts[i].body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        },
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DemoCard(
              title: 'GraphQL (configured endpoint)',
              child: Text(
                'When you pass a GraphQLConfig, use GraphQLService.query() / '
                '.mutate() and subscribe via client.subscribe(WebSocketLink). '
                'Not enabled in this demo.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            DemoCard(
              title: 'Clean Architecture Flow',
              child: Text(
                'Screen → PostsCubit (application) → FetchTopPosts (domain) → '
                'PostRepositoryImpl → PostRemoteDataSource → Dio.\n\n'
                'Domain ships a sealed PostRepository contract; the data layer '
                'satisfies it, so the domain never depends on transport.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}