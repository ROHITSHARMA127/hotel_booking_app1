import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'api_services/api_services.dart';
import 'auth_provider/auth_provider.dart';
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

    // load cached data for quick UI
    await provider.getData();
    nameCtrl.text = provider.name;
    emailCtrl.text = provider.email;
    _selectedGender = provider.selectedGender.toLowerCase();
    _selectMaritalStatus = provider.selectMaritalStatus.toLowerCase();
    if (mounted) setState(() {});

    // fetch from server if possible
    setState(() => _loading = true);
    try {
      final serverProfile = await AuthHelper.getProfile();
      if (serverProfile != null) {
        final serverName = (serverProfile['name'] ?? serverProfile['fullName'] ?? provider.name).toString();
        final serverEmail = (serverProfile['email'] ?? provider.email).toString();
        final serverGender = (serverProfile['gender'] ?? provider.selectedGender).toString();
        final serverMarital = (serverProfile['marital'] ?? provider.selectMaritalStatus).toString();

        await provider.updateProfile(serverName, serverEmail, serverGender, serverMarital);

        if (!mounted) return;
        nameCtrl.text = serverName;
        emailCtrl.text = serverEmail;
        _selectedGender = serverGender.toLowerCase();
        _selectMaritalStatus = serverMarital.toLowerCase();
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not fetch profile: $e")));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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

  Future<void> _onSavePressed() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final newName = nameCtrl.text.trim();
    final newEmail = emailCtrl.text.trim();
    final newGender = _selectedGender;
    final newMarital = _selectMaritalStatus;

    setState(() => isEdit = false);

    if (newName.isEmpty || newEmail.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name and email cannot be empty")));
      return;
    }

    setState(() => _loading = true);
    try {
      final success = await AuthHelper.updateProfile(newName, newEmail, gender: newGender, marital: newMarital);
      // update local regardless, but show appropriate message
      await provider.updateProfile(newName, newEmail, newGender, newMarital);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated locally (server failed)")));
        }
      }
    } catch (e) {
      await provider.updateProfile(newName, newEmail, newGender, newMarital);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("login_status_key", false);
    // optionally clear token: await prefs.remove("auth_token");

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  Future<void> _deleteProfile() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    await provider.deleteProfile();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("login_status_key", false);
    await prefs.remove("auth_token");
    await prefs.remove("userId");

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
          title: const Text("Profile", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(onPressed: _onSavePressed, child: const Text("Save", style: TextStyle(color: Colors.blue))),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  const Text("Personal details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 20),
                  editableField(nameCtrl, "Name"),
                  const SizedBox(height: 20),
                  editableField(emailCtrl, "Email"),
                  const SizedBox(height: 20),

                  AbsorbPointer(
                    absorbing: !isEdit,
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g.toUpperCase()))).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedGender = value;
                            provider.selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  AbsorbPointer(
                    absorbing: !isEdit,
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: "Marital Status", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      child: DropdownButton<String>(
                        value: _selectMaritalStatus,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _maritalStatus.map((m) => DropdownMenuItem(value: m, child: Text(m.toUpperCase()))).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectMaritalStatus = value;
                            provider.selectMaritalStatus = value;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 200),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: Colors.black)),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _logout,
                    child: const Text("Logout"),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete Profile"),
                          content: const Text("Are you sure you want to delete your profile? This will clear local data."),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );

                      if (confirm == true) await _deleteProfile();
                    },
                    child: const Text("Delete Profile", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),

            if (_loading)
              Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}