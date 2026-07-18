import 'package:coffee_box/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 249, 249, 249),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 220,
                          height: 220,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Sign Up with email',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                        RoundedTextField(
                          label: 'Name',
                          color: Color(0xFFC67C4E),
                          controller: nameController,
                        ),
                        SizedBox(height: 12),
                        RoundedTextField(
                          label: 'Email',
                          color: Color(0xFFC67C4E),
                          controller: emailController,
                        ),
                        SizedBox(height: 12),
                        RoundedTextField(
                          label: 'Password',
                          color: Color(0xFFC67C4E),
                          controller: passwordController,
                          obscureText: true,
                        ),
                        SizedBox(height: 12),
                        RoundedTextField(
                          label: 'Address',
                          color: Color(0xFFC67C4E),
                          controller: addressController,
                        ),
                        SizedBox(height: 12),
                        RoundedTextField(
                          label: 'Phone Number',
                          color: Color(0xFFC67C4E),
                          controller: phoneNumberController,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            authProvider.signUpWithEmailAndPassword(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                nameController.text.trim(),
                                addressController.text.trim(),
                                phoneNumberController.text.trim(),
                                context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFC67C4E),
                          ),
                          child: Container(
                            width: 175,
                            height: 35,
                            alignment: Alignment.center,
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Or'),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google-icon.png',
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Sign Up with Google',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final String label;
  final Color color;
  final TextEditingController controller;
  final bool obscureText;

  RoundedTextField({
    required this.label,
    required this.color,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
