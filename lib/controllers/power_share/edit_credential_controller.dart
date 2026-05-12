import 'package:cafein/controllers/power_share/user_profile_controller.dart';
import 'package:cafein/services/credential_service.dart';
import 'package:cafein/services/education_service.dart';
import 'package:cafein/services/local/token.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCredentialController extends GetxController {
  final CredentialService _credentialService = CredentialService();
  final EducationService _educationService = EducationService();

  final isLoading = false.obs;
  final selectedType = 'Keahlian'.obs;

  // Edit mode tracking
  final isEditing = false.obs;
  int? credentialId;
  int? educationId;

  // Keahlian
  final skillController = TextEditingController();

  // Pendidikan
  final schoolController = TextEditingController();
  final majorController = TextEditingController();
  final degreeController = TextEditingController();
  final strata = 0.obs; // 0=sarjana, etc.
  final graduationYearController = TextEditingController();

  // Lokasi
  final addressController = TextEditingController();

  // Pekerjaan
  final jobTitleController = TextEditingController();
  final companyController = TextEditingController();

  // Kehormatan
  final honorController = TextEditingController();

  // Topik
  final topicController = TextEditingController();
  final descriptionController = TextEditingController();

  // Nomer Telfon
  final phoneController = TextEditingController();

  final List<String> credentialTypes = [
    'Keahlian',
    'Pendidikan',
    'Lokasi',
    'Pekerjaan',
    'Penghargaan',
    'Topik',
    'Nomor Telepon',
  ];

  final List<String> strataTypes = [
    'Sarjana (S1)',
    'Magister (S2)',
    'Doktoral (S3)',
    'Profesi',
    'Lainnya',
    'SMA/MA/SMK',
    'SMP',
    'SD',
  ];

  // Helper to get current userId for refreshing profile
  Future<String?> _getCurrentUserId() async {
    try {
      final id = await Token.getUserId();
      return id;
    } catch (e) {
      return null;
    }
  }

  void refreshUserProfile() async {
    try {
      final userIdStr = await _getCurrentUserId();
      if (userIdStr != null) {
        // Try to find UserProfileController by tag (userId)
        if (Get.isRegistered<UserProfileController>(tag: userIdStr)) {
          Get.find<UserProfileController>(tag: userIdStr).refreshData();
          print('Refresh profile with tag $userIdStr success');
        } else {
          // If not found by tag, try without tag (if it's not tagged)
          if (Get.isRegistered<UserProfileController>()) {
            Get.find<UserProfileController>().refreshData();
            print('Refresh profile without tag success');
          }
        }
      }
    } catch (e) {
      print('Error refreshing profile: $e');
    }
  }

  void resetFields() {
    isEditing.value = false;
    credentialId = null;
    educationId = null;

    skillController.clear();
    schoolController.clear();
    majorController.clear();
    degreeController.clear();
    strata.value = 0;
    graduationYearController.clear();
    addressController.clear();
    jobTitleController.clear();
    companyController.clear();
    honorController.clear();
    topicController.clear();
    descriptionController.clear();
    phoneController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    _loadExistingData();
  }

  /// Load existing credential data from Get.arguments for edit mode
  void _loadExistingData() {
    final args = Get.arguments;
    if (args == null || args is! Map<String, dynamic>) return;

    final id = args['id'];
    if (id == null) return;

    isEditing.value = true;

    final String type = args['type'] ?? 'Keahlian';
    selectedType.value = type;

    if (type == 'Pendidikan') {
      educationId = id is int ? id : int.tryParse(id.toString());
      schoolController.text = args['school'] ?? '';
      majorController.text = args['primary_major'] ?? '';
      degreeController.text = args['degree_type'] ?? '';
      strata.value = args['strata'] is int
          ? args['strata']
          : int.tryParse(args['strata']?.toString() ?? '0') ?? 0;
      graduationYearController.text = args['graduation_year']?.toString() ?? '';
    } else {
      credentialId = id is int ? id : int.tryParse(id.toString());
      final String description = args['description'] ?? '';

      switch (type) {
        case 'Keahlian':
          skillController.text = description;
          break;
        case 'Lokasi':
          addressController.text = description;
          break;
        case 'Pekerjaan':
          // Format: "jobTitle di company"
          if (description.contains(' di ')) {
            final parts = description.split(' di ');
            jobTitleController.text = parts[0];
            companyController.text = parts.sublist(1).join(' di ');
          } else {
            jobTitleController.text = description;
          }
          break;
        case 'Penghargaan':
          honorController.text = description;
          break;
        case 'Topik':
          // Format: "topic: description"
          if (description.contains(': ')) {
            final parts = description.split(': ');
            topicController.text = parts[0];
            descriptionController.text = parts.sublist(1).join(': ');
          } else {
            topicController.text = description;
          }
          break;
        case 'Nomor Telepon':
          phoneController.text = description;
          break;
      }
    }
  }

  @override
  void onClose() {
    skillController.dispose();
    schoolController.dispose();
    majorController.dispose();
    degreeController.dispose();
    graduationYearController.dispose();
    addressController.dispose();
    jobTitleController.dispose();
    companyController.dispose();
    honorController.dispose();
    topicController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> saveCredential() async {
    try {
      isLoading.value = true;
      dynamic response;

      if (selectedType.value == 'Pendidikan') {
        int year =
            int.tryParse(graduationYearController.text) ?? DateTime.now().year;

        if (isEditing.value && educationId != null) {
          // Update existing education
          response = await _educationService.updateEducation(
            id: educationId!,
            school: schoolController.text,
            primaryMajor: majorController.text,
            strata: strata.value,
            degreeType: degreeController.text,
            graduationYear: year,
          );
        } else {
          // Add new education
          response = await _educationService.addEducation(
            school: schoolController.text,
            primaryMajor: majorController.text,
            strata: strata.value,
            degreeType: degreeController.text,
            graduationYear: year,
          );
        }
      } else {
        int backendType = _getBackendType(selectedType.value);
        String description = _getDescriptionForType(selectedType.value);

        if (isEditing.value && credentialId != null) {
          // Update existing credential
          response = await _credentialService.updateCredential(
            id: credentialId!,
            type: backendType,
            description: description,
          );
        } else {
          // Add new credential
          response = await _credentialService.addCredential(
            type: backendType,
            description: description,
          );
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        String successMsg = isEditing.value
            ? 'Berhasil memperbarui data kredensial'
            : 'Berhasil menyimpan data kredensial';
        if (response.data != null && response.data is Map) {
          successMsg =
              response.data['msg'] ?? response.data['message'] ?? successMsg;
        }

        refreshUserProfile();

        // Instead of just Get.back(), we might want to stay if adding more
        // For now, let's keep Get.back() but maybe the UI will handle "Add Another"
        Get.back();

        Get.snackbar(
          'Sukses',
          successMsg,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errMsg = 'Terjadi kesalahan saat menyimpan data';
        if (response.data != null && response.data is Map) {
          errMsg = response.data['msg'] ?? response.data['message'] ?? errMsg;
        }

        Get.snackbar(
          'Gagal',
          errMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e, stackTrace) {
      print('=== ERROR SAVING CREDENTIAL (DioException) ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Request Method: ${e.requestOptions.method}');
      print('Request Data: ${e.requestOptions.data}');
      print('StackTrace: $stackTrace');

      if (e.response != null) {
        print('Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');

        String errorMsg = 'Terjadi kesalahan pada server';
        if (e.response?.data != null && e.response?.data is Map) {
          final responseData = e.response!.data as Map;
          dynamic msgData = responseData['msg'] ?? responseData['message'];

          if (msgData is String) {
            errorMsg = msgData;
          } else if (msgData is Map) {
            if (msgData.values.isNotEmpty && msgData.values.first is List && (msgData.values.first as List).isNotEmpty) {
              errorMsg = (msgData.values.first as List)[0].toString();
            } else {
              errorMsg = msgData.toString();
            }
          } else if (msgData != null) {
            errorMsg = msgData.toString();
          }
        }

        Get.snackbar(
          'Gagal',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal menghubungkan ke server (${e.type}). Periksa koneksi internet Anda.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      print('=== ERROR SAVING CREDENTIAL (Unknown) ===');
      print('Exception: $e');
      print('StackTrace: $stackTrace');

      Get.snackbar(
        'Error',
        'Gagal memproses data ($e)',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  int _getBackendType(String type) {
    switch (type) {
      case 'Keahlian':
        return 0;
      case 'Pendidikan':
        return 1;
      case 'Lokasi':
        return 2;
      case 'Pekerjaan':
        return 3;
      case 'Penghargaan':
        return 4;
      case 'Topik':
        return 5;
      case 'Nomor Telepon':
        return 6;
      default:
        return 0;
    }
  }

  String _getDescriptionForType(String type) {
    switch (type) {
      case 'Keahlian':
        return skillController.text;
      case 'Lokasi':
        return addressController.text;
      case 'Pekerjaan':
        return '${jobTitleController.text} di ${companyController.text}';
      case 'Penghargaan':
        return honorController.text;
      case 'Topik':
        return '${topicController.text}: ${descriptionController.text}';
      case 'Nomor Telepon':
        return phoneController.text;
      default:
        return '';
    }
  }

  Future<void> deleteCredential() async {
    try {
      isLoading.value = true;
      dynamic response;

      if (selectedType.value == 'Pendidikan') {
        if (educationId != null) {
          response = await _educationService.deleteEducation(educationId!);
        }
      } else {
        if (credentialId != null) {
          response = await _credentialService.deleteCredential(credentialId!);
        }
      }

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        refreshUserProfile();
        Get.back();
        Get.snackbar(
          'Sukses',
          'Berhasil menghapus kredensial',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan saat menghapus data',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
