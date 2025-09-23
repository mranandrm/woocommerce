import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> customer;

  const ProfileScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(customer["avatar_url"] ?? ""),
            ),
            const SizedBox(height: 16),
            Text("${customer["first_name"]} ${customer["last_name"]}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(customer["email"]),
            const SizedBox(height: 16),
            Text("Billing Address: ${customer["billing"]["address_1"]}, ${customer["billing"]["city"]}"),
            Text("Phone: ${customer["billing"]["phone"]}"),
          ],
        ),
      ),
    );
  }
}
