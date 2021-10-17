import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String lable;
  final String text;
  final ValueChanged<String> onChanged;

  const TextFieldWidget(
      {Key? key,
      required this.lable,
      required this.text,
      required this.onChanged})
      : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.lable),
          const SizedBox(
            height: 8,
          ),
          TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              controller: controller,
              onChanged: widget.onChanged)
        ],
      );
}
