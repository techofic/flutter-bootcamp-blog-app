import 'package:flutter/material.dart';

// ignore: must_be_immutable
class KTextField extends StatefulWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final Icon? prefixIcon;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double borderRadius;
  final Function(String value)? callBackFunction;
  final bool callBack;

  const KTextField({
    Key? key,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.borderRadius = 10,
    this.callBack = false,
    this.callBackFunction,
  }) : super(key: key);

  @override
  _KTextFieldState createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            keyboardType: widget.textInputType,
            textInputAction: widget.textInputAction,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
            ),
            onChanged: (val) {
              if (val != '') {
                if (widget.callBack) {
                  widget.callBackFunction!(val);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
