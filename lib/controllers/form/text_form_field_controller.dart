import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFormFieldController extends GetxController {
  RxBool isFocused = false.obs;
  RxBool isFormError = false.obs;
  RxBool obsecureText = true.obs;
  Rxn<String> errorText = Rxn<String>();

  void handleFocus(bool focus) {
    isFocused.value = focus;
  }

  void validator(String value) {
    if (value.isEmpty) {
      errorText.value = 'Pastikan form sudah terisi!';
      isFormError.value = true;
    } else {
      errorText.value = null;
      isFormError.value = false;
    }
  }

  Color getTextFieldColor({
    required Color defaultColor,
    required Color focusedColor,
    required Color errorColor,
  }) {
    if (isFocused.value) {
      if (isFormError.value) {
        return errorColor;
      } else {
        return focusedColor;
      }
    } else {
      if (isFormError.value) {
        return errorColor;
      } else {
        return defaultColor;
      }
    }
  }
}
