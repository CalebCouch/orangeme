import 'package:flutter/material.dart';

class PaymentOptionsWidget extends StatefulWidget {
  final Function(String)? onSignUp;
  final VoidCallback? onOptOut;
  final bool showOptOutButton;

  const PaymentOptionsWidget(
      {super.key, this.onSignUp, this.onOptOut, this.showOptOutButton = true});

  @override
  PaymentOptionsWidgetState createState() => PaymentOptionsWidgetState();
}

class PaymentOptionsWidgetState extends State<PaymentOptionsWidget> {
  String? _selectedPaymentOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ListTile(
          title: Text(
            '\$5 per month',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          leading: Radio<String>(
            value: 'monthly',
            groupValue: _selectedPaymentOption,
            onChanged: (value) {
              setState(() {
                _selectedPaymentOption = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text('One time purchase \$120',
              style: Theme.of(context).textTheme.displayMedium),
          leading: Radio<String>(
            value: 'one_time',
            groupValue: _selectedPaymentOption,
            onChanged: (value) {
              setState(() {
                _selectedPaymentOption = value;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _selectedPaymentOption != null
              ? () {
                  widget.onSignUp?.call(_selectedPaymentOption!);
                }
              : null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.grey[700],
            disabledForegroundColor: Colors.white,
          ),
          child: const Text('Sign Up'),
        ),
        const SizedBox(height: 10),
        if (widget.showOptOutButton)
          ElevatedButton(
            onPressed: widget.onOptOut,
            child: const Text('Opt Out'),
          ),
      ],
    );
  }
}
