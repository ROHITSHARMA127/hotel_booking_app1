import 'package:flutter/material.dart';
import 'package:hotel_booking_app/widgets/custom_widget.dart';
import 'package:provider/provider.dart';
import 'auth_provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context,listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Center(
                    child: Image.network(
                      "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/vip-hotel-logo-design-template-eb72f8981df652fe0be27a9a517ae471_screen.jpg?ts=1660122446",
                    ),
                  ),
                  customTextFormField(
                    null,
                    "Enter Full Name",
                    provider.nameController,
                    "Please enter fullName",
                  ),
                  customTextFormField(
                    null,
                    "Enter Email",
                    provider.emailController,
                    "Please enter Email",
                  ),
                  customTextFormField(
                    null,
                    "Enter password",
                    provider.passwordController,
                    "Please enter Password",
                  ),
                  Text("Gender", style: TextStyle(color: Colors.white)),
                  RadioListTile<String>(
                    activeColor: Colors.orange,
                    title: const Text(
                      'Male',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Male',
                    groupValue: provider.selectedGender,
                    onChanged:
                        (value) => setState(() => provider.selectedGender = value!),
                  ),
                  RadioListTile<String>(
                    activeColor: Colors.orange,
                    title: const Text(
                      'Female',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Female',
                    groupValue: provider.selectedGender,
                    onChanged:
                        (value) => setState(() => provider.selectedGender = value!),
                  ),
                  RadioListTile<String>(
                    activeColor: Colors.orange,
                    title: const Text(
                      'Other',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Other',
                    groupValue: provider.selectedGender,
                    onChanged:
                        (value) => setState(() => provider.selectedGender = value!),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            provider.signupNow(context);
                          }
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
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
