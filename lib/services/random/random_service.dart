abstract class RandomService {
  /// Returns [count] unique indices in the range [0, deckSize).
  Future<List<int>> drawCardIndices(int count, int deckSize);
}
