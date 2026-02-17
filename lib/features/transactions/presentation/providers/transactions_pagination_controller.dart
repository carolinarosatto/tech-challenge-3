import 'package:flutter/foundation.dart';

class TransactionsPaginationController {
  TransactionsPaginationController({
    int initialPageSize = 6,
    Duration minimumLoadingDuration = const Duration(milliseconds: 250),
  }) : _pageSize = initialPageSize,
       _currentLimit = initialPageSize,
       _minimumLoadingDuration = minimumLoadingDuration;

  final Duration _minimumLoadingDuration;

  int _pageSize;
  int _currentLimit;
  bool _isLoadingPage = false;
  bool _hasMore = true;
  int _pageLoadToken = 0;
  DateTime? _pageLoadStartedAt;
  bool _isDisposed = false;

  int get pageSize => _pageSize;
  int get currentLimit => _currentLimit;
  bool get isLoadingPage => _isLoadingPage;
  bool get hasMore => _hasMore;

  bool get canLoadMore => !_isLoadingPage && _hasMore;

  bool updatePageSize(int pageSize) {
    if (pageSize <= 0 || pageSize == _pageSize) {
      return false;
    }

    _pageSize = pageSize;
    reset();
    return true;
  }

  void reset() {
    _currentLimit = _pageSize;
    _hasMore = true;
  }

  void expandPage() {
    _currentLimit += _pageSize;
  }

  int startLoading() {
    _isLoadingPage = true;
    _pageLoadStartedAt = DateTime.now();
    _pageLoadToken += 1;
    return _pageLoadToken;
  }

  void markDataLoaded(int itemCount) {
    _hasMore = itemCount >= _currentLimit;
  }

  void markError() {
    _isLoadingPage = false;
    _hasMore = false;
  }

  Future<void> finishLoading({
    required int token,
    required VoidCallback onCompleted,
  }) async {
    final startedAt = _pageLoadStartedAt;
    final elapsed = startedAt == null
        ? Duration.zero
        : DateTime.now().difference(startedAt);
    final remaining = _minimumLoadingDuration - elapsed;

    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    if (_isDisposed || _pageLoadToken != token) {
      return;
    }

    _isLoadingPage = false;
    onCompleted();
  }

  void dispose() {
    _isDisposed = true;
  }
}
