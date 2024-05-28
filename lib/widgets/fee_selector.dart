import 'package:flutter/material.dart';
import 'package:orange/styles/constants.dart';

class FeeSelector extends StatefulWidget {
  final Function(bool) onOptionSelected;
  final double price;
  final int standardFee;

  const FeeSelector(
      {super.key,
      required this.onOptionSelected,
      required this.price,
      required this.standardFee});

  @override
  FeeSelectorState createState() => FeeSelectorState();
}

class FeeSelectorState extends State<FeeSelector> {
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
              price: widget.price,
              standardFee: widget.standardFee),
        ),
      ],
    );
  }
}

class PriorityOption extends StatefulWidget {
  final bool isSelected;
  final Function(bool) onSelected;

  const PriorityOption(
      {super.key, required this.isSelected, required this.onSelected});

  @override
  PriorityOptionState createState() => PriorityOptionState();
}

class PriorityOptionState extends State<PriorityOption> {
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
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Priority (Disabled)',
                  style: AppTextStyles.heading5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Arrives in ~30 minutes\n\$N/A bitcoin network fee',
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
  final double price;
  final int standardFee;

  const StandardOption(
      {super.key,
      required this.isSelected,
      required this.onSelected,
      required this.price,
      required this.standardFee});

  @override
  StandardOptionState createState() => StandardOptionState();
}

class StandardOptionState extends State<StandardOption> {
  @override
  Widget build(BuildContext context) {
    String standardPrice =
        ((widget.standardFee / 100000000) * widget.price).toStringAsFixed(2);
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
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Standard', style: AppTextStyles.heading5),
              ),
              const SizedBox(height: 10),
              Text(
                'Arrives in ~2 hours\n\$$standardPrice bitcoin network fee',
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
