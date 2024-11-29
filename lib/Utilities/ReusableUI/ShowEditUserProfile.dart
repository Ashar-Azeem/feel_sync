import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Future<String?> showUserTextEditor(
    BuildContext context, String title, String initialText) {
  TextEditingController textController =
      TextEditingController(text: initialText);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: initialText.length,
    );
  });
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 100.w,
          child: TextField(
            onTap: () => textController.selection =
                TextSelection(baseOffset: 0, extentOffset: initialText.length),
            minLines: 1,
            maxLines: 5,
            controller: textController,
            decoration: InputDecoration(
              labelText: 'Edit your ${title.toLowerCase()} here',
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(textController.text);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        // contentPadding:
        //     EdgeInsets.only(left: 5.h, right: 5.h, top: 3.h, bottom: 3.h),
      );
    },
  );
}
