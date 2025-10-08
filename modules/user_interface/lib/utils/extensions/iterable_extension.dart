extension IterableModifier<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) item) =>
      cast<T?>().firstWhere((v) => v != null && item(v), orElse: () => null);
}
