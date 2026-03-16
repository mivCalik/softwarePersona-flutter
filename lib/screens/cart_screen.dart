import 'package:flutter/material.dart';
import '../models/product.dart';
import '../main.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = CartState.of(context);
    final items = cartState.cartItems;
    final total = items.fold<double>(0, (sum, p) => sum + p.price);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                cartState.clearCart();
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
        ],
      ),
      body: items.isEmpty ? _buildEmptyState() : _buildCartList(context, items, total, cartState),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 96, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, List<Product> items,
      double total, CartStateData cartState) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return _CartItem(
                product: product,
                onRemove: () => cartState.removeFromCart(index),
              );
            },
          ),
        ),
        // Total & Checkout
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, -4),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${items.length} item${items.length == 1 ? '' : 's'}',
                    style:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: const Text('Order Placed!'),
                        content: Text(
                          'Your order of \$${total.toStringAsFixed(2)} has been placed successfully.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              cartState.clearCart();
                              Navigator.pop(context); // close dialog
                              Navigator.pop(context); // back to home
                            },
                            child: const Text(
                              'OK',
                              style:
                                  TextStyle(color: Color(0xFF6C63FF)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartItem extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const _CartItem({required this.product, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.network(
              product.thumbnail,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, st) => Container(
                width: 90,
                height: 90,
                color: Colors.grey[200],
                child:
                    const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Remove button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle_outline,
                  color: Colors.redAccent),
              tooltip: 'Remove',
            ),
          ),
        ],
      ),
    );
  }
}
