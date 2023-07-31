import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Auth/auth.dart';
import '../../Constants/Widgets.dart';
import '../HomeScreen.dart';
import 'SignUp.dart';

// ignore: camel_case_types
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

// ignore: camel_case_types
class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      var snackBar = const SnackBar(
                          content: Text('Email Cannot Be Empty!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _isObscure = !_isObscure;
                      },
                      icon: Icon(_isObscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      var snackBar = const SnackBar(
                          content: Text('Password Cannot Be Empty!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (value.length < 8) {
                      var snackBar = const SnackBar(
                          content: Text(
                              'Length Of Password Should be Greater than 8!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 57,
                  child: ElevatedButton(
                    
                    onPressed: () async {

                      try {
                        if (_key.currentState!.validate()) {
                          await AuthService().emailLogin(_emailController.text,
                              _passwordController.text, context).then((value) {
                                Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                                });
                          
                        }
                      } on FirebaseAuthException catch (e) {
                        
                        var snackBar =
                            SnackBar(content: Text(e.message.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.redAccent, //background color of button
                      side: const BorderSide(
                          width: 2,
                          color: Colors.white), //border width and color

                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.all(5), //content padding inside button
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register_Screen()));
                  },
                  child: const Text(
                    'Don\'t have account? SignUp',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
