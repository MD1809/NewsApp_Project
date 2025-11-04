import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _usernameController = TextEditingController();
  DateTime? _birthday;
  String? _gender;

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snap = await _firestore.collection('users').doc(user.uid).get();
      if (snap.exists) {
        final data = snap.data()!;
        _usernameController.text = data['username'] ?? '';
        _gender = data['gender'];

        if (data['birthday'] != null) {
          _birthday = (data['birthday'] as Timestamp).toDate();
        }
      }
      setState(() {});
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = _auth.currentUser;

    try {
      await _firestore.collection('users').doc(user!.uid).set({
        'username': _usernameController.text.trim(),
        'gender': _gender,
        'birthday': _birthday != null ? Timestamp.fromDate(_birthday!) : null,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _loading = false);
  }

  Future<void> _pickBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _birthday = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: _inputDecoration("Username"),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Enter a username"
                    : null,
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: _pickBirthday,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _birthday == null
                            ? "Select Birthday"
                            : DateFormat('dd-MM-yyyy').format(_birthday!),
                        style: TextStyle(
                          color: _birthday == null
                              ? Colors.grey
                              : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.calendar_month,
                          color: Colors.blue),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _gender,
                decoration: _inputDecoration("Gender"),
                items: const [
                  DropdownMenuItem(
                      value: "male", child: Text("Male")),
                  DropdownMenuItem(
                      value: "female", child: Text("Female")),
                  DropdownMenuItem(
                      value: "hidden", child: Text("Hidden")),
                ],
                onChanged: (value) => setState(() => _gender = value),
              ),

              const SizedBox(height: 50),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _updateProfile,
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
