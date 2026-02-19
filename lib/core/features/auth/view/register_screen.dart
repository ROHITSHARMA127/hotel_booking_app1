import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFF512F), Color(0xffDD2476)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Form card
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4))
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/Rx hotel logo.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Sign up to continue",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),

                      const SizedBox(height: 25),

                      // Full Name
                      TextFormField(
                        controller: provider.nameController,
                        validator: (val) =>
                        val!.isEmpty ? "Please enter name" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.drive_file_rename_outline, color: Colors.red),
                          hintText: "Name",
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Email
                      TextFormField(
                        controller: provider.emailController,
                        validator: (val) =>
                        val!.isEmpty ? "Please enter email" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email, color: Colors.red),
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextFormField(
                        controller: provider.passwordController,
                        obscureText: true,
                        validator: (val) =>
                        val!.isEmpty ? "Please enter password" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Colors.red),
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Gender
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Gender",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: [
                          RadioListTile<String>(
                            activeColor: Colors.red,
                            title: const Text('Male'),
                            value: 'Male',
                            groupValue: provider.selectedGender,
                            onChanged: (val) =>
                                setState(() => provider.selectedGender = val!),
                          ),
                          RadioListTile<String>(
                            activeColor: Colors.red,
                            title: const Text('Female'),
                            value: 'Female',
                            groupValue: provider.selectedGender,
                            onChanged: (val) =>
                                setState(() => provider.selectedGender = val!),
                          ),
                          RadioListTile<String>(
                            activeColor: Colors.red,
                            title: const Text('Other'),
                            value: 'Other',
                            groupValue: provider.selectedGender,
                            onChanged: (val) =>
                                setState(() => provider.selectedGender = val!),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: provider.selectedGender.isEmpty
                              ? null // ❌ Disabled
                              : () {
                            if (formKey.currentState?.validate() ?? false) {
                              provider.signupNow(context);
                            }
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

