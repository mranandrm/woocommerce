import 'package:flutter/material.dart';
import 'package:woocommerce/services/woocommerce_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool loading = false;

  String message = "";

  Future<void> _register() async{

    if (!_formKey.currentState!.validate()) return;

    setState(()=> loading= true);
    final service = WooCommerceService();

    try{
       final response = await service.registerUser({

         "email" : _email.text.trim(),
         "username": _username.text.trim(),
         "password": _password.text.trim(),
         "first_name" : "",
         "last_name": "",
         "billing" : {},
         "shipping": {}

       });

       if(response.containsKey("id")){

         setState(() => message="Registeration Successfull");

       }else{

         setState(() => message= response["message"]??"Registeration Successfull");
       }

    }

    catch (e){

      setState(()=> message="Error: $e");
    }
    setState(() =>loading =false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),

      body: Padding(
          padding: const EdgeInsets.all(16),
        child:Form(
          key: _formKey,
            child: Column(
              children: [

                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (v)=>v!.isEmpty ? "Enter email" : null,
                ),
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(labelText: "Username"),
                  validator: (v) => v!.isEmpty ? "Enter username" : null,
                ),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? "Enter password" : null,
                ),
                
                const SizedBox(height: 20,),
                
                loading 
                    ? const CircularProgressIndicator()
                    :ElevatedButton(
                    onPressed: _register, 
                    child: const Text("Register"),
                ),
                const SizedBox(height: 10,),
                Text(message,style:  const TextStyle(color: Colors.red),)
              ],
            )
        ),
      ),

    );
  }
}
