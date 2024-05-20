// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:orange/styles/constants.dart';

// class NumberPad extends StatelessWidget {
//   final void Function(String) onNumberPressed;

//   NumberPad({required this.onNumberPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: GridView.count(
//         crossAxisCount: 3,
//         childAspectRatio: 2.0,
//         mainAxisSpacing: 16.0,
//         crossAxisSpacing: 16.0,
//         children: [
//           NumberButton(number: '1', onPressed: onNumberPressed),
//           NumberButton(number: '2', onPressed: onNumberPressed),
//           NumberButton(number: '3', onPressed: onNumberPressed),
//           NumberButton(number: '4', onPressed: onNumberPressed),
//           NumberButton(number: '5', onPressed: onNumberPressed),
//           NumberButton(number: '6', onPressed: onNumberPressed),
//           NumberButton(number: '7', onPressed: onNumberPressed),
//           NumberButton(number: '8', onPressed: onNumberPressed),
//           NumberButton(number: '9', onPressed: onNumberPressed),
//           NumberButton(number: '.', onPressed: onNumberPressed),
//           NumberButton(number: '0', onPressed: onNumberPressed),
//           NumberButton(
//             svgIcon: '<svg xmlns="http://www.w3.org/2000/svg" width="25" height="24" viewBox="0 0 25 24" fill="none"><path d="M16.4027 20.8519C16.2137 20.8519 16.0247 20.781 15.8792 20.6389L7.56732 12.5291C7.42257 12.3881 7.34082 12.1943 7.34082 11.9921C7.34082 11.79 7.42257 11.5965 7.56732 11.4551L15.8627 3.36114C16.1586 3.07239 16.6341 3.07764 16.9232 3.37426C17.2123 3.67089 17.2067 4.14564 16.9101 4.43514L9.1652 11.9921L16.9262 19.5649C17.2228 19.854 17.2288 20.3291 16.9393 20.6258C16.7927 20.7761 16.5973 20.8519 16.4027 20.8519Z" fill="white"/></svg>',
//             onPressed: onNumberPressed,
//             number: 'backspace',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NumberButton extends StatelessWidget {
//   final String number;
//   final String? svgIcon;
//   final void Function(String) onPressed;

//   NumberButton({required this.number, this.svgIcon, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => onPressed(number),
//         borderRadius: BorderRadius.zero,
//         child: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//           height: 48,
//           child: svgIcon != null
//               ? SvgPicture.string(
//                   svgIcon!,
//                   width: 24,
//                   height: 24,
//                   color: AppColors.white,
//                 )
//               : Text(
//                   number,
//                   style: const TextStyle(fontSize: 24, color: AppColors.white),
//                 ),
//         ),
//       ),
//     );
//   }
// }


// //place this in any file to use the numberpad
//  //         onNumberPressed: (String number) {
//  //           example printing pressed number
//  //           print('Pressed: $number');
//  //        },
//  //      ),
