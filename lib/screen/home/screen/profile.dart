import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycourse_flutter/config/authmanager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  XFile? _coverImage;

  Future<void> _pickImage(ImageSource source, bool isProfileImage) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (isProfileImage) {
        _profileImage = pickedFile;
      } else {
        _coverImage = pickedFile;
      }
    });
  }

  void _showImagePickerOptions(bool isProfileImage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Take a Photo'),
              onTap: () {
                _pickImage(ImageSource.camera, isProfileImage);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.green),
              title: const Text('Choose from Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery, isProfileImage);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          // Creative Cover Photo
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(22)),
                  child: _coverImage != null
                      ? Image.file(
                          File(_coverImage!.path),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/image/b6.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt,
                        color: Colors.green, size: 30),
                    onPressed: () => _showImagePickerOptions(false),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => _showImagePickerOptions(true),
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: _profileImage != null
                                ? Image.file(
                                    File(_profileImage!.path),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/image/profile.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.green, size: 30),
                            onPressed: () => _showImagePickerOptions(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'johndoe@example.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildListTile(
                  icon: Icons.person,
                  title: 'My Profile',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to My Profile page
                  },
                ),
                _buildListTile(
                  icon: Icons.history,
                  title: 'My Orders',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to My Orders page
                  },
                ),
                _buildListTile(
                  icon: Icons.credit_card,
                  title: 'My Cards',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to My Cards page
                  },
                ),
                _buildListTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to Settings page
                  },
                ),
                _buildListTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  color: Colors.green,
                  onTap: () {
                    Authmanger.removeToken();
                    Navigator.pushReplacementNamed(context, '/sigin');
                  },
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
