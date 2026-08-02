import 'package:equatable/equatable.dart';

import '../domain/entities/post.dart';

/// Clean Architecture **application** layer state for the posts feature.
sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => const [];
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<Post> posts;

  const PostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostsError extends PostsState {
  final String message;

  const PostsError(this.message);

  @override
  List<Object?> get props => [message];
}