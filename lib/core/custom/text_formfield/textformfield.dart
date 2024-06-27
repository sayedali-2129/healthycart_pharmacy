import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class TextfieldWidget extends StatelessWidget {
  const TextfieldWidget({
    super.key,
    this.controller,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
    this.validator,
    this.maxlines,
    this.minlines,
    this.labelText,
    this.fontSize,
    this.hintText,
    this.textInputAction,
    this.onChanged,
    this.onSubmit, this.prefixText, this.suffixText,
  });
  final TextEditingController? controller;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxlines;
  final int? minlines;
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final String? suffixText;
  final double? fontSize;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        onChanged: onChanged,
        textInputAction: textInputAction,
        textCapitalization: TextCapitalization.sentences,
        minLines: maxlines,
        maxLines: maxlines,
        validator: validator,
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readOnly!,
        cursorColor: BColors.black,
        onFieldSubmitted: onSubmit,
        style:  Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: fontSize ??14,
                                    ),
        decoration: InputDecoration(
          suffixText: suffixText,
          prefixText:prefixText ,
          suffixStyle:Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 16) ,
          prefixStyle:Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 16) ,
          labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w600),
          hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w600),
          hintText: hintText,
          labelText: labelText,
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: BColors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
