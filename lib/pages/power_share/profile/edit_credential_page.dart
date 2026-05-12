import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cafein/controllers/power_share/edit_credential_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EditCredentialPage extends StatefulWidget {
  const EditCredentialPage({super.key});

  @override
  State<EditCredentialPage> createState() => _EditCredentialPageState();
}

class _EditCredentialPageState extends State<EditCredentialPage> {
  late final EditCredentialController controller;

  @override
  void initState() {
    super.initState();
    // Delete existing controller to ensure fresh state per navigation
    // This is safe in initState — runs only once, not on every rebuild
    Get.delete<EditCredentialController>(force: true);
    controller = Get.put(EditCredentialController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrowLeft, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.isEditing.value
                ? 'Edit Kredensial'
                : 'Tambah Kredensial',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ),
        actions: [
          // Save button
          Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF1B4E6B),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: TextButton(
                      onPressed: () => controller.saveCredential(),
                      child: Text(
                        'Simpan',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: const Color(0xFF1B4E6B),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    IconlyLight.shieldDone,
                    color: const Color(0xFF1B4E6B),
                    size: 28.sp,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'Kredensial menambahkan kredibilitas pada konten Anda di Berbagi.',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            Text(
              'Jenis Kredensial',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1.5.h),

            CustomDropdown<String>(
              hintText: 'Pilih Jenis Kredensial',
              items: controller.credentialTypes,
              initialItem: controller.selectedType.value,
              onChanged: (value) {
                if (value != null) {
                  controller.selectedType.value = value;
                }
              },
              decoration: CustomDropdownDecoration(
                closedFillColor: Colors.white,
                expandedFillColor: Colors.white,
                closedBorderRadius: BorderRadius.circular(12),
                expandedBorderRadius: BorderRadius.circular(12),
              ),
            ),

            SizedBox(height: 4.h),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildDynamicFields(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFields(EditCredentialController controller) {
    // Unique key for AnimatedSwitcher
    Key fieldKey = ValueKey(controller.selectedType.value);

    switch (controller.selectedType.value) {
      case 'Keahlian':
        return _buildTextField(
          key: fieldKey,
          label: 'Keahlian',
          hint: 'Masukkan Keahlian',
          controller: controller.skillController,
          icon: IconlyLight.star,
        );
      case 'Pendidikan':
        return Column(
          key: fieldKey,
          children: [
            _buildTextField(
              label: 'Nama Sekolah',
              hint: 'Nama Sekolah (contoh: Universitas Indonesia)',
              controller: controller.schoolController,
              icon: IconlyLight.discovery,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              label: 'Jurusan',
              hint: 'Jurusan (contoh: Teknik Elektro)',
              controller: controller.majorController,
              icon: IconlyLight.bookmark,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              label: 'Jenis Gelar',
              hint: 'Jenis Gelar (contoh: Sarjana Teknik)',
              controller: controller.degreeController,
              icon: IconlyLight.paper,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              label: 'Tahun Kelulusan',
              hint: 'Contoh: 2024',
              controller: controller.graduationYearController,
              keyboardType: TextInputType.number,
              icon: IconlyLight.calendar,
            ),
          ],
        );
      case 'Lokasi':
        return _buildTextField(
          key: fieldKey,
          label: 'Lokasi',
          hint: 'Masukkan Alamat',
          controller: controller.addressController,
          icon: IconlyLight.location,
        );
      case 'Pekerjaan':
        return Column(
          key: fieldKey,
          children: [
            _buildTextField(
              label: 'Pekerjaan',
              hint: 'Pekerjaan (contoh: Software Engineer)',
              controller: controller.jobTitleController,
              icon: IconlyLight.work,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              label: 'Perusahaan / Organisasi',
              hint: 'Perusahaan / Organisasi',
              controller: controller.companyController,
              icon: IconlyLight.category,
            ),
          ],
        );
      case 'Penghargaan':
        return _buildTextField(
          key: fieldKey,
          label: 'Penghargaan',
          hint: 'Gelar Penghargaan',
          controller: controller.honorController,
          icon: IconlyLight.activity,
        );
      case 'Topik':
        return Column(
          key: fieldKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        IconlyLight.infoSquare,
                        color: Colors.blue[900],
                        size: 16.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Informasi Kredensial yang baik :',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  _buildBulletItem('Bersifat singkat dan spesifik'),
                  _buildBulletItem('Bersifat membantu dan tulus'),
                  _buildBulletItem('Memiliki ejaan dan tata bahasa yang benar'),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            _buildTextField(
              label: 'Pilih Topik',
              hint: 'Pilih Topik',
              controller: controller.topicController,
              icon: IconlyLight.document,
            ),
            SizedBox(height: 2.h),
            _buildTextField(
              label: 'Deskripsi Pengalaman',
              hint: 'Deskripsi Pengalaman',
              controller: controller.descriptionController,
              maxLines: 4,
              icon: IconlyLight.edit,
            ),
          ],
        );
      case 'Nomor Telepon':
        return _buildTextField(
          key: fieldKey,
          label: 'Nomor Telepon (Opsional)',
          hint: 'Masukkan Nomor Telepon',
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          icon: IconlyLight.call,
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.8.h),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.blue[900],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: Colors.blue[900],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    Key? key,
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 1.w, bottom: 0.8.h),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(fontSize: 14.sp),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF1B4E6B),
                size: 20.sp,
              ),
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: Colors.grey[400],
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFF1B4E6B),
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: (maxLines > 1) ? 2.h : 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    EditCredentialController controller,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hapus Kredensial',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus kredensial ini?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteCredential();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
