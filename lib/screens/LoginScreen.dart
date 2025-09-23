import 'package:flutter/material.dart';
import 'package:woocommerce/services/woocommerce_service.dart';

import 'ProductScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool loading = false;
  String message = "";

  Future <void> _login() async {

    if(! _formKey.currentState!.validate()) return;

    setState(()=> loading = true);

    final service = WooCommerceService();

    try{

       final  response = await service.loginUser(
           _username.text.trim(),
           _password.text.trim(),
       );

       if(response.containsKey("token")){

         setState(() => message ="Login Successfull");

         // ✅ Navigate directly to ProductScreen
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => const ProductScreen()),
         );

       }
       else{

         setState(()=> message = response["message"] ?? "Login Failed");
       }
    }

    catch (e) {
        setState(() => message = "Error: $e");

    }

    setState(() => loading = false);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:  AppBar(
        title: const Text("Login "),
      ),

      body: Padding(
          padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
            child: Column(
              children: [

                TextFormField(
                  controller: _username,
                  decoration:  const InputDecoration(labelText: "Username or Email"),
                  validator: (v)=> v!.isEmpty ? "Enter username" : null,
                ),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? "Enter password" : null,
                ),
                const SizedBox(height: 20),
                loading 
                ? const CircularProgressIndicator()
                    : ElevatedButton(
                    onPressed: _login, 
                    child: const Text("Login"),),
                const SizedBox(height: 10),
                Text(message, style:  const TextStyle(color: Colors.green),)
              ],
            )
        ),
      ),
    );
  }
}
