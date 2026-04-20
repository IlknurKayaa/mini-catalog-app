import 'package:flutter/material.dart';
import 'package:minicatalog/models/produtcs_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Data product;
  final Set<int> cartID;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.cartID,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final imagePath = widget.product.image ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Geri"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 IMAGE (FIXED)
            Hero(
              tag: "${widget.product.id}_${widget.product.name}",
              child: imagePath.startsWith("http")
                  ? Image.network(
                      imagePath,
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 350,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, size: 50),
                        );
                      },
                    )
                  : Image.asset(
                      imagePath,
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.product.tagline ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),

                  Text(
                    "İçerik",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 4),

                  Text(
                    widget.product.description ?? "",
                    style: TextStyle(fontSize: 14),
                  ),

                  SizedBox(height: 12),

                  Text(
                    widget.product.price ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 30),

                  /// 🔥 BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade900,
                      minimumSize: Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.cartID.add(widget.product.id ?? 0);
                      });

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Sepete Eklendi")));
                    },
                    child: Text(
                      "Sepete Ekle",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
