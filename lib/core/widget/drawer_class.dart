import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/provider/auth_provider.dart';
import '../features/auth/view/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Drawer(
      width: size.width, // Full screen drawer
      child: SafeArea(
        child: Column(
          children: [
            // 🔥 Consumer yahin use hua
            Consumer<AuthProvider>(
              builder: (context, provider, child) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffFF512F), Color(0xffDD2476)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 6),
                          ],
                        ),
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        provider.name.isNotEmpty
                            ? provider.name
                            : "Guest User",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        provider.email.isNotEmpty
                            ? provider.email
                            : "guest@email.com",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen()),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit Profile"),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Rx Hotel App v1.0",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
