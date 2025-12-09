import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEdit = false;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final List<String> _genders = ['male', 'female', 'other'];
  String _selectedGender = 'male';

  final List<String> _maritalStatus = ['married', 'unmarried', 'other'];
  String _selectMaritalStatus = 'married';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.getData();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      nameCtrl.text = provider.name;
      emailCtrl.text = provider.email;

      _selectedGender = provider.selectedGender.toLowerCase();
      _selectMaritalStatus = provider.selectMaritalStatus.toLowerCase();

      setState(() {});
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  Widget editableField(TextEditingController controller, String label) {
    return GestureDetector(
      onTap: () => setState(() => isEdit = true),
      child: AbsorbPointer(
        absorbing: !isEdit,
        child: SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            "Profile",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await provider.updateProfile(
                  nameCtrl.text.trim(),
                  emailCtrl.text.trim(),
                  _selectedGender,
                  _selectMaritalStatus,
                );

                setState(() => isEdit = false);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Updated")),
                );
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text("Personal details",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 20),

              editableField(nameCtrl, "Name"),
              const SizedBox(height: 20),

              editableField(emailCtrl, "Email"),
              const SizedBox(height: 20),

              // -------- GENDER DROPDOWN ----------
              AbsorbPointer(
                absorbing: !isEdit,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _genders
                        .map((g) => DropdownMenuItem(
                      value: g,
                      child: Text(g.toUpperCase()),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                        provider.selectedGender = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // -------- MARITAL STATUS ----------
              AbsorbPointer(
                absorbing: !isEdit,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Marital Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectMaritalStatus,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _maritalStatus
                        .map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.toUpperCase()),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectMaritalStatus = value!;
                        provider.selectMaritalStatus = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 200),

              // -------- LOGOUT BUTTON ----------
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(5),
                      side: BorderSide(color: Colors.black),
                    )),
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool("login_status_key", false);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Logout",style: TextStyle(color: Colors.black),),
              ),

              const SizedBox(height: 10),

              // -------- DELETE PROFILE BUTTON ----------
              TextButton(
                onPressed: () async {
                  await provider.deleteProfile();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "Delete Profile",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
