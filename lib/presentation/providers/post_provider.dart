import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/repositories.dart';

// Repository provider
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

// Posts state
class PostsState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const PostsState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  PostsState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Posts notifier
class PostsNotifier extends StateNotifier<PostsState> {
  final PostRepository _postRepository;

  PostsNotifier(this._postRepository) : super(const PostsState());

  // Load posts
  Future<void> loadPosts({
    bool refresh = false,
    String? feed,
    String? type,
  }) async {
    if (refresh) {
      state = const PostsState(isLoading: true);
    } else if (state.isLoading || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final page = refresh ? 1 : state.currentPage;
      final newPosts = await _postRepository.getPosts(
        page: page,
        feed: feed,
        type: type,
      );

      if (refresh) {
        state = state.copyWith(
          posts: newPosts,
          isLoading: false,
          hasMore: newPosts.length >= 20,
          currentPage: 1,
        );
      } else {
        state = state.copyWith(
          posts: [...state.posts, ...newPosts],
          isLoading: false,
          hasMore: newPosts.length >= 20,
          currentPage: page + 1,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Create post
  Future<void> createPost(CreatePostRequest request) async {
    try {
      final newPost = await _postRepository.createPost(request);
      state = state.copyWith(
        posts: [newPost, ...state.posts],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Toggle like
  Future<void> toggleLike(int postId) async {
    try {
      final result = await _postRepository.toggleLike(postId);

      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            userHasLiked: result['liked'],
            likesCount: result['likes_count'],
          );
        }
        return post;
      }).toList();

      state = state.copyWith(posts: updatedPosts);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Clear posts
  void clearPosts() {
    state = const PostsState();
  }
}

// Posts provider
final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return PostsNotifier(postRepository);
});
