import 'package:flutter/material.dart';
import 'package:minicatalog/views/home_screen.dart';
import 'package:minicatalog/views/product_detail_screen.dart';
import 'package:minicatalog/views/cart_screen.dart';

class AppRoutes {
  static const home = "/";
  static const detail = "/detail";
  static const cart = "/cart";

  static Map<String, WidgetBuilder> routes = {
    home: (context) => HomeScreen(),
    detail: (context) => const ProductDetailWrapper(),
    cart: (context) => const CartWrapper(),
  };
}

class ProductDetailWrapper extends StatelessWidget {
  const ProductDetailWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return ProductDetailScreen(
      product: args["product"],
      cartID: args["cartID"],
    );
  }
}

class CartWrapper extends StatelessWidget {
  const CartWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return CartScreen(products: args["products"], cartID: args["cartID"]);
  }
}
