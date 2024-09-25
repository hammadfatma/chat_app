import 'package:chat_app/core/helpers/extensions.dart';
import 'package:chat_app/core/helpers/spacing.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/features/auth/ui/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

void provideBottomSheet({
  required BuildContext context,
  required void Function()? onPressed,
  required Key? key,
  required String hintText,
  required String buttonText,
  required TextInputType? keyboardType,
  required void Function(String?)? onSaved,
  required String? Function(String?)? validator,
}) {
  showModalBottomSheet(
    backgroundColor: ColorsManager.ligtGray,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      hintText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    IconButton.filled(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: showTextFormField(
                    validator: validator,
                    keyboardType: keyboardType,
                    onSaved: onSaved,
                  ),
                ),
                verticalSpace(16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  onPressed: onPressed,
                  child: Center(
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
