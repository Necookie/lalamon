import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'error_messages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isLoading = false;
  final bool _isChangingPassword = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAvatarUrl();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  // Load user data from Firebase
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists && mounted) {
          setState(() {
            _nameController.text = userData.data()?['name'] ?? '';
            _phoneController.text = userData.data()?['phone'] ?? '';
          });
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar(ErrorMessages.getProfileLoadError(e));
        }
      }
    }
  }

  // Load avatar URL from Firebase Firestore for the logged-in user
  Future<void> _loadAvatarUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _avatarUrl = userDoc.data()?['avatar_url'] ?? ''; // Retrieve avatar URL from Firestore
          });
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar('Error loading avatar: $e');
        }
      }
    }
  }

  // Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.pinkAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Update profile data in Firestore
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': user.email,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        if (mounted) {
          _showSuccessSnackBar('Profile updated successfully!');
          setState(() {
            _isEditing = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(ErrorMessages.getProfileUpdateError(e));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Upload profile image to Supabase Storage and update URL in Firestore
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _isLoading = true);

      try {
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser == null) {
          _showErrorSnackBar('Firebase user is not authenticated');
          return;
        }

        final fileBytes = await pickedFile.readAsBytes();
        final fileName = '${firebaseUser.uid}/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
        final supabaseStorage = Supabase.instance.client.storage.from('profile-pictures');

        // Upload image to Supabase Storage
        final response = await supabaseStorage.uploadBinary(
          fileName,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

        // Get the public URL of the uploaded image
        final imageUrl = supabaseStorage.getPublicUrl(fileName);

        // Store the Supabase URL in Firestore under the user's profile
        await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update({
          'avatar_url': imageUrl, // Save Supabase URL in Firebase Firestore
        });

        if (mounted) {
          setState(() {
            _avatarUrl = imageUrl; // Update the avatar URL in the widget state
          });
          _showSuccessSnackBar('Profile picture updated successfully!');
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar('Error uploading image: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        actions: [
          if (!_isChangingPassword)
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              color: Colors.white,
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_isEditing) {
                        _updateProfile();
                      } else {
                        setState(() {
                          _isEditing = true;
                        });
                      }
                    },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0), // Remove top padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Center the profile picture
              SizedBox(
                width: MediaQuery.of(context).size.width, // Full width of the screen
                height: 350, // Height of the card
                child: Card(
                  elevation: 4, // Adds shadow for a card-like effect
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12), // Rounded bottom-left corner
                      bottomRight: Radius.circular(12), // Rounded bottom-right corner
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pinkAccent.shade100, // White at the top
                          Colors.blueGrey.shade100, // Light grey at the bottom
                        ],
                        begin: Alignment.topLeft, // Gradient starts from the top-left
                        end: Alignment.bottomRight, // Gradient ends at the bottom-right
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12), // Match the card's bottom-left corner
                        bottomRight: Radius.circular(12), // Match the card's bottom-right corner
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0), // Padding inside the container
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _isLoading ? null : _pickAndUploadImage, // Trigger image upload on tap
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _avatarUrl != null
                                ? CachedNetworkImageProvider(_avatarUrl!)
                                : const AssetImage('assets/default_avatar.jpg') as ImageProvider,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white, // Show a loading indicator if uploading
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 35), // Space between avatar and name
                        Text(
                          _nameController.text.isNotEmpty ? _nameController.text : 'No name provided',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // Center-align the text
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Display name, email, and phone
              if (!_isEditing) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 20,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(Icons.phone, color: Colors.pinkAccent, size: 30),
                        ),
                        Text(
                          'Phone',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          _phoneController.text.isNotEmpty ? _phoneController.text : 'No phone provided',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 20,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.email, color: Colors.pinkAccent, size: 30),
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          FirebaseAuth.instance.currentUser?.email ?? 'No email provided',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 20,
                    ),
                  ],
                ),
              ],

              // Form to edit profile
              if (_isEditing)
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.pinkAccent,
                            ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Phone field
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Save changes button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _updateProfile,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

