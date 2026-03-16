import 'package:flutter/material.dart';
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

// ─── Cart State (InheritedWidget) ─────────────────────────────────────────────

class CartStateData {
  final List<Product> cartItems;
  final void Function(Product) addToCart;
  final void Function(int) removeFromCart;
  final VoidCallback clearCart;

  const CartStateData({
    required this.cartItems,
    required this.addToCart,
    required this.removeFromCart,
    required this.clearCart,
  });
}

class CartState extends InheritedWidget {
  final CartStateData data;

  const CartState({
    super.key,
    required this.data,
    required super.child,
  });

  static CartStateData of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<CartState>();
    assert(result != null, 'No CartState found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(CartState oldWidget) => true;
}

// ─── App Root ─────────────────────────────────────────────────────────────────

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Product> _cartItems = [];

  void _addToCart(Product product) {
    setState(() => _cartItems.add(product));
  }

  void _removeFromCart(int index) {
    setState(() => _cartItems.removeAt(index));
  }

  void _clearCart() {
    setState(() => _cartItems.clear());
  }

  @override
  Widget build(BuildContext context) {
    return CartState(
      data: CartStateData(
        cartItems: _cartItems,
        addToCart: _addToCart,
        removeFromCart: _removeFromCart,
        clearCart: _clearCart,
      ),
      child: MaterialApp(
        title: 'Mini Katalog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            brightness: Brightness.light,
          ),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1A1A2E),
            elevation: 0,
            centerTitle: false,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const DetailScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}
