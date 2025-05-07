import 'dart:math';

class RandomPickService<T> {
  final List<T> _items;
  final Random _random = Random();

  RandomPickService(this._items);

  T getRandomItem() {
    return _items[_random.nextInt(_items.length)];
  }
}
