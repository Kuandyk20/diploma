import 'package:diploma/pages/restaurantPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'bookSeats.dart';

class CartPage extends StatefulWidget {
  final int restaurantId;

  CartPage({required this.restaurantId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<MenuItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = prefs.getString('cartItems_${widget.restaurantId}');
    if (cartItemsJson != null) {
      final cartItemsData = jsonDecode(cartItemsJson) as List<dynamic>;
      final List<MenuItem> items = cartItemsData
          .map((itemData) => MenuItem.fromJson(itemData))
          .toList();
      setState(() {
        cartItems = items;
      });
    }
  }

  Future<void> removeFromCart(MenuItem item) async {
    cartItems.remove(item);
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = cartItems.map((item) => item.toJson()).toList();
    await prefs.setString(
        'cartItems_${widget.restaurantId}', jsonEncode(cartItemsJson));
    setState(() {});
  }

  Future<void> clearCart() async {
    cartItems.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems_${widget.restaurantId}');
    setState(() {});
  }

  Future<void> refreshCart() async {
    setState(() {
      cartItems = [];
    });
    await loadCartItems();
  }


  void navigateToBookTablePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookTablePage(
          cartItems: cartItems,
          restaurantId: widget.restaurantId,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(item.name),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: () {
                removeFromCart(item);
              },
            ),
          );
        },
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          const SizedBox(height: 8),
    FloatingActionButton.extended(
    onPressed: () {
    navigateToBookTablePage();
    },
    icon: const Icon(Icons.shopping_cart),
    label: const Text('Buy'),
    ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: () {
              clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Cart'),
          ),
        ],
      ),
    );
  }
}