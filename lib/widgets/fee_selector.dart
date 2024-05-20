import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class FeeSelector extends StatefulWidget {
  final Function(bool) onOptionSelected;

  const FeeSelector({Key? key, required this.onOptionSelected}) : super(key: key);

  @override
  _FeeSelectorState createState() => _FeeSelectorState();
}

class _FeeSelectorState extends State<FeeSelector> {
  bool _isPrioritySelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: PriorityOption(
            isSelected: _isPrioritySelected,
            onSelected: (selected) {
              setState(() {
                _isPrioritySelected = selected;
                widget.onOptionSelected(_isPrioritySelected);
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: StandardOption(
            isSelected: !_isPrioritySelected,
            onSelected: (selected) {
              setState(() {
                _isPrioritySelected = !selected;
                widget.onOptionSelected(_isPrioritySelected);
              });
            },
          ),
        ),
      ],
    );
  }
}

class PriorityOption extends StatefulWidget {
  final bool isSelected;
  final Function(bool) onSelected;

  const PriorityOption({Key? key, required this.isSelected, required this.onSelected}) : super(key: key);

  @override
  _PriorityOptionState createState() => _PriorityOptionState();
}

class _PriorityOptionState extends State<PriorityOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isSelected) {
          widget.onSelected(true);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<bool>(
            value: true,
            groupValue: widget.isSelected,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2), 
            activeColor: AppColors.white, 
            onChanged: (bool? value) {
              if (value != null && value != widget.isSelected) {
                widget.onSelected(value);
              }
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Priority',
                  style: AppTextStyles.textLG.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Arrives in ~30 minutes\n\$3.19 bitcoin network fee',
                style: AppTextStyles.textMD.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StandardOption extends StatefulWidget {
  final bool isSelected;
  final Function(bool) onSelected;

  const StandardOption({Key? key, required this.isSelected, required this.onSelected}) : super(key: key);

  @override
  _StandardOptionState createState() => _StandardOptionState();
}

class _StandardOptionState extends State<StandardOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isSelected) {
          widget.onSelected(true);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<bool>(
            value: true,
            groupValue: widget.isSelected,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            activeColor: AppColors.white, 
            onChanged: (bool? value) {
              if (value != null && value != widget.isSelected) {
                widget.onSelected(value);
              }
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Standard',
                  style: AppTextStyles.textLG.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Arrives in ~2 hours\n\$2.08 bitcoin network fee',
                style: AppTextStyles.textMD.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
