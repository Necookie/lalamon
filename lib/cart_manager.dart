class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addItem(Map<String, dynamic> item) {
    // If item already exists, just increase quantity
    final index = _cartItems.indexWhere((e) => e['name'] == item['name']);
    if (index != -1) {
      _cartItems[index]['quantity'] += item['quantity'];
    } else {
      _cartItems.add(item);
    }
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
  }

  void clear() {
    _cartItems.clear();
  }
}