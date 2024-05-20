import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class FeeOption {
  final String title;
  final String subtitle;

  FeeOption({required this.title, required this.subtitle});
}

class FeeSelector extends StatefulWidget {
  final List<FeeOption> options;
  final Function(int) onOptionSelected;

  const FeeSelector({Key? key, required this.options, required this.onOptionSelected}) : super(key: key);

  @override
  FeeSelectorState createState() => FeeSelectorState();
}

class FeeSelectorState extends State<FeeSelector> {
  int _selectedOptionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedOptionIndex = index;
              widget.onOptionSelected(_selectedOptionIndex);
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<int>(
                value: index,
                groupValue: _selectedOptionIndex,
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      _selectedOptionIndex = value;
                      widget.onOptionSelected(_selectedOptionIndex);
                    });
                  }
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      option.title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    option.subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
