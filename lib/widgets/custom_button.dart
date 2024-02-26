import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final Function? callback;
  final Widget? title;
  const CustomBtn({super.key, this.title, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: 200.0, // Set the width directly in the Container
        height: 50.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              20.0), // Set the height directly in the Container
          child: Container(
            color: const Color.fromARGB(255, 34, 17, 112),
            child: TextButton(
              onPressed: () => callback!(),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                // Set any additional styles here
              ),
              child: title!,
            ),
          ),
        ),
      ),
    );
  }
}
