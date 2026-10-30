import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = Get.find();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: 'shreeshahegde@gmail.com');
  final passwordController = TextEditingController(text: 'password');

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final rememberMe = true.obs;

  void togglePassword() => obscurePassword.toggle();

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    try {
      isLoading.value = true;
      await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
        rememberMe: rememberMe.value,
      );
      Get.offAllNamed(AppRoutes.shell);
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validateEmail(String? v) => Validators.email(v);
  String? validatePassword(String? v) => Validators.password(v);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
