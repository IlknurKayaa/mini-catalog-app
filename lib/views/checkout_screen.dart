import 'package:flutter/material.dart';
import 'package:minicatalog/models/produtcs_model.dart';

class CheckoutScreen extends StatefulWidget {
  final Set<int> cartID;

  const CheckoutScreen({super.key, required this.cartID});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final mailController = TextEditingController();
  final addressController = TextEditingController();
  final cardController = TextEditingController();

  void completeOrder() {
    if (_formKey.currentState!.validate()) {
      widget.cartID.clear();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Siparişiniz tamamlanmıştır")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ödeme")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildInput("Ad", nameController),
              buildInput("Soyad", surnameController),
              buildInput(
                "Mail",
                mailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mail boş olamaz";
                  }

                  final emailRegex = RegExp(
                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                  );

                  if (!emailRegex.hasMatch(value)) {
                    return "Geçerli bir mail girin";
                  }

                  return null;
                },
              ),
              buildInput("Adres", addressController),
              buildInput(
                "Kart Numarası",
                cardController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Kart numarası boş olamaz";
                  }

                  // sadece rakam mı
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Sadece rakam giriniz";
                  }

                  // uzunluk kontrol (16 haneli)
                  if (value.length != 16) {
                    return "Kart numarası 16 haneli olmalı";
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: completeOrder, child: Text("Öde")),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator:
            validator ??
            (value) => value == null || value.isEmpty
                ? "Bu alan boş bırakılamaz"
                : null,
      ),
    );
  }
}
