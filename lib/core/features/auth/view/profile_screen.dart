import 'package:flutter/material.dart';
import 'package:hotel_booking_app/core/features/auth/data/auth_api_services.dart';
import 'package:hotel_booking_app/core/widget/bottom_navigation.dart';
import 'package:hotel_booking_app/core/features/hotel/view/hotel_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEdit = false;
  bool _loading = false;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final List<String> _genders = ['male', 'female', 'other'];
  String _selectedGender = 'male';

  final List<String> _maritalStatus = ['married', 'unmarried', 'other'];
  String _selectMaritalStatus = 'married';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    await provider.getData();
    nameCtrl.text = provider.name;
    emailCtrl.text = provider.email;
    _selectedGender = provider.selectedGender.toLowerCase();
    _selectMaritalStatus = provider.selectMaritalStatus.toLowerCase();
    setState(() {});
  }

  Widget editableField(TextEditingController controller, String label, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => isEdit = true),
      child: AbsorbPointer(
        absorbing: !isEdit,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.red),
              labelText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSavePressed() async {
    setState(() => isEdit = false);
    final provider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _loading = true);
    await AuthApiServices.updateProfile(
      nameCtrl.text,
      emailCtrl.text,
      gender: _selectedGender,
      marital: _selectMaritalStatus,
    );
    await provider.updateProfile(
      nameCtrl.text,
      emailCtrl.text,
      _selectedGender,
      _selectMaritalStatus,
    );

    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("login_status_key", false);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Gradient Background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFF512F), Color(0xffDD2476)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Main Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Profile Avatar
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Icon(Icons.person, size: 60, color: Colors.red),
                ),

                const SizedBox(height: 10),
                const Text(
                  "My Profile",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),

                const SizedBox(height: 25),

                /// White Card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: ListView(
                      children: [
                        editableField(nameCtrl, "Name", Icons.person),
                        editableField(emailCtrl, "Email", Icons.email),

                        const SizedBox(height: 10),

                        /// Gender
                        _buildDropdown("Gender", _selectedGender, _genders, (val) {
                          setState(() => _selectedGender = val);
                        }),

                        const SizedBox(height: 15),

                        /// Marital Status
                        _buildDropdown("Marital Status", _selectMaritalStatus, _maritalStatus, (val) {
                          setState(() => _selectMaritalStatus = val);
                        }),

                        const SizedBox(height: 30),

                        /// Save Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed:(){
                            _onSavePressed();

                            // 2️⃣ 3 second delay ke baad Home screen navigate
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => BottomNavigation()),
                                    (route) => false,
                              );
                            });
                          },
                          child: const Text("Save Profile", style: TextStyle(fontSize: 18)),
                        ),

                        const SizedBox(height: 15),

                        /// Logout
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: _logout,
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_loading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String title, String value, List<String> items, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e.toUpperCase()),
        ))
            .toList(),
        onChanged: isEdit ? (val) => onChanged(val!) : null,
      ),
    );
  }
}
