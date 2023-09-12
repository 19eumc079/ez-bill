import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'profile_page_components/update_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child('users')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child('user_details')
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            data = snapshot.data!.snapshot.value;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (data != null) ...[
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: ClipOval(),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Company Name:',
                        data['company_name']?.toString().toUpperCase() ?? ''),
                    _buildInfoRow('Email:', data['email'] ?? ''),
                    _buildInfoRow('Phone:', data['phone'] ?? ''),
                    _buildInfoRow('Door No:', data['door_no'] ?? ''),
                    _buildInfoRow('Street:', data['street'] ?? ''),
                    _buildInfoRow('City:', data['city'] ?? ''),
                    _buildInfoRow('Pin:', data['pin'] ?? ''),
                    _buildInfoRow('Country:', data['country'] ?? ''),
                    _buildInfoRow('State:', data['state'] ?? ''),
                    _buildInfoRow('GST:', data['gst'] ?? ''),
                    _buildInfoRow(
                        'Prefix Invoice:', data['prefix_invoice'] ?? ''),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      // Perform update logic here
                      // final updata = FirebaseFirestore.instance
                      //     .collection('users')
                      //     .doc(FirebaseAuth.instance.currentUser!.uid);
                      // updata.update({
                      //   'phone': '1234567892',
                      // });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdatePage(
                                  city: data['city'],
                                  companyname: data['company_name'],
                                  country: data['country'],
                                  email: data['email'],
                                  landmark: data['door_no'],
                                  phone: data['phone'],
                                  pin: data['pin'],
                                  prefix: data['prefix_invoice'],
                                  state: data['state'],
                                  street: data['street'])));
                    },
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
