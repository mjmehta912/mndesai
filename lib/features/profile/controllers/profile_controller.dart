import 'package:get/get.dart';
import 'package:mndesai/features/authentication/login/screens/login_screen.dart';
import 'package:mndesai/utils/dialogs/app_dialogs.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  var fullName = ''.obs;
  var userId = ''.obs;
  var userType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      fullName.value = await SecureStorageHelper.read('fullName') ?? 'Unknown';

      userType.value = await SecureStorageHelper.read('userType') ?? 'guest';
      userId.value = await SecureStorageHelper.read('userId') ?? '';
    } catch (e) {
      showErrorSnackbar(
        'Failed to Load User Info',
        'There was an issue loading your profile data. Please try again.',
      );
    }
  }

  Future<void> logoutUser() async {
    isLoading.value = true;
    try {
      await SecureStorageHelper.clearAll();

      Get.offAll(
        () => LoginScreen(),
      );

      showSuccessSnackbar(
        'Logged Out',
        'You have been successfully logged out.',
      );
    } catch (e) {
      showErrorSnackbar(
        'Logout Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
