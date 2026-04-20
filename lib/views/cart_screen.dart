import 'package:flutter/material.dart';
import 'package:minicatalog/models/produtcs_model.dart';
import 'package:minicatalog/views/checkout_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:io';

class CartScreen extends StatefulWidget {
  final List<Data> products;
  final Set<int> cartID;

  const CartScreen({super.key, required this.products, required this.cartID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isOnline = false; // 🔥 başlangıç false
  StreamSubscription? connectivitySubscription;

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      setState(() {
        isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      });
    } catch (_) {
      setState(() {
        isOnline = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkInternet();

    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      _,
    ) async {
      await checkInternet();
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProduct = widget.products
        .where((product) => widget.cartID.contains(product.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sepet"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: cartProduct.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Sepet Boş",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartProduct.length,
                        itemBuilder: (context, index) {
                          final product = cartProduct[index];
                          final imagePath = product.image ?? "";

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: imagePath.startsWith("http")
                                      ? Image.network(
                                          imagePath,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 80,
                                                  height: 80,
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.broken_image,
                                                  ),
                                                );
                                              },
                                        )
                                      : Image.asset(
                                          imagePath,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        product.tagline ?? "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        product.price ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.cartID.remove(product.id);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_circle_outline_outlined,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              SizedBox(height: 20),

              /// 🔴 OFFLINE UYARI
              if (!isOnline)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "İnternet bağlantısı gerekli",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              /// 🔥 BUTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOnline
                      ? Colors.green.shade900
                      : Colors.grey,
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isOnline
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutScreen(cartID: widget.cartID),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      }
                    : null,
                child: Text(
                  "Sepeti Onayla",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
