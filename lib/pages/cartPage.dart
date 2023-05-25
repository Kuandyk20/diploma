import 'package:diploma/pages/restaurantPage.dart';
import 'package:flutter/material.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: Cart.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = Cart.items[index];
          return ListTile(
            /*leading: Image.network(
              item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),*/
            title: Text(item.name),
            //subtitle: Text(item.address),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                Cart.removeItem(item);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Cart.clearCart();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cart cleared'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: Icon(Icons.clear_all),
        label: Text('Clear Cart'),
      ),
    );
  }
}