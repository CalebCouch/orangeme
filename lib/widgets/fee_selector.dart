import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';


class FeeSelector extends StatefulWidget {
  final Function(String) onOptionSelected;

  const FeeSelector({super.key, required this.onOptionSelected});

  @override
  _FeeSelectorState createState() => _FeeSelectorState();
}

class _FeeSelectorState extends State<FeeSelector> {
  int _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<int>(
                value: 0,
                groupValue: _selectedValue,
                onChanged: (int? value) {
                  setState(() {
                    _selectedValue = value!;
                    widget.onOptionSelected('priority true');
                  });
                },
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Priority',
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Arrives in ~30 minutes\n\$3.19 bitcoin network fee',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<int>(
                value: 1,
                groupValue: _selectedValue,
                onChanged: (int? value) {
                  setState(() {
                    _selectedValue = value!;
                    widget.onOptionSelected('standard true');
                  });
                },
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Standard',
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Arrives in ~2 hours\n\$2.08 bitcoin network fee',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
