import 'package:cafein/controllers/auth/auth_controller.dart';
import 'package:cafein/controllers/profile/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userController.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userController.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => userController.fetchProfile(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final employee = userController.userModel.value?.employee;
        if (employee == null) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: employee.foto != null
                    ? NetworkImage(employee.foto!)
                    : null,
                child: employee.foto == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              const SizedBox(height: 20),
              _buildInfoTile(Icons.badge, 'Nama Lengkap', employee.namaLengkap),
              _buildInfoTile(Icons.wc, 'Jenis Kelamin', employee.gender),
              _buildInfoTile(Icons.phone, 'No. HP', employee.noHp),
              _buildInfoTile(Icons.email, 'Email', employee.email ?? '-'),
              _buildInfoTile(
                Icons.location_on,
                'Alamat',
                employee.alamat ?? '-',
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => authController.logout(),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
