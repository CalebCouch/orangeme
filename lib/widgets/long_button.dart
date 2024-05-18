import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class LongButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isEnabled;

  const LongButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (!isEnabled) {
              return AppColors.grey;
            } else if (states.contains(MaterialState.pressed)) {
              return AppColors.orange;
            }
            return AppColors.orange;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 48)), 
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 18,
            color: isEnabled ? AppColors.white : AppColors.black, 
          ),
        ),
      ),
    );
  }
}
