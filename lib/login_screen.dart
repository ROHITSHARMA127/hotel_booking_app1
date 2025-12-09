import 'package:flutter/material.dart';
import 'package:hotel_booking_app/register_screen.dart';
import 'package:hotel_booking_app/widgets/custom_widget.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 20,
                children: [
                  Image.network(
                    "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/vip-hotel-logo-design-template-eb72f8981df652fe0be27a9a517ae471_screen.jpg?ts=1660122446",
                  ),
                  customTextFormField(
                    null,
                    "Enter Email",
                    provider.emailController,
                    "Please enter email",
                  ),
                  customTextFormField(
                    null,
                    "Enter Password",
                    provider.passwordController,
                    "Please enter password",
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          provider.loginNow(context);
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text("Signup",style: TextStyle(color: Color(0xFFFFC107)),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
