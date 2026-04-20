import 'package:flutter/material.dart';
import 'package:minicatalog/components/product_card.dart';
import 'package:minicatalog/models/produtcs_model.dart';
import 'package:minicatalog/services/api_service.dart';
import 'package:minicatalog/views/cart_screen.dart';
import 'package:minicatalog/views/product_detail_screen.dart';
import '../services/local_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'dart:async';
import 'package:minicatalog/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Data> allProducts = [];
  bool isLoading = false;
  String errorMessage = "";
  ApiService apiService = ApiService();
  final localService = LocalService();
  Set<int> cartID = {};
  StreamSubscription? connectivitySubscription;
  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    final hasInternet = await checkInternet();

    if (hasInternet) {
      try {
        final data = await apiService.fetchPRoduct();

        setState(() {
          allProducts = data.data ?? [];
          isLoading = false;
        });

        print("ONLINE → API");
      } catch (e) {
        setState(() {
          errorMessage = "API hata verdi";
          isLoading = false;
        });
      }
    } else {
      try {
        final localProducts = await localService.loadFakeProducts();

        setState(() {
          allProducts = localProducts;
          isLoading = false;
        });

        print("OFFLINE → JSON");
      } catch (e) {
        setState(() {
          errorMessage = "Local veri yüklenemedi";
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    loadData();

    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      _,
    ) async {
      await loadData();
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Katalog",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.cart,
                        arguments: {"products": allProducts, "cartID": cartID},
                      );
                    },
                    icon: Icon(Icons.shopping_bag_outlined),
                    iconSize: 32,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Alışverişin keyfini çıkar!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Ürün ara",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage("assets/images/banner1.png"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (errorMessage.isNotEmpty)
                Center(child: Text(errorMessage))
              else
                Expanded(
                  child: GridView.builder(
                    itemCount: allProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = allProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detail,
                            arguments: {"product": product, "cartID": cartID},
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
