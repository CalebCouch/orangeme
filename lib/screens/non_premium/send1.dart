import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'send2.dart';

class Send1 extends StatefulWidget {
  final int balance;
  const Send1({super.key, required this.balance});

  @override
  Send1State createState() => Send1State();
}

class Send1State extends State<Send1> {
  late FocusNode _focusNode;
  late double enteredAmount;
  late double maxAmountToSpend;
  final NumberFormat satoshiFormat = NumberFormat('#,### sats');
  bool isAmountIncreased = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    enteredAmount = 0.0;
    maxAmountToSpend = widget.balance?.toDouble() ?? 0.0;
    _focusNode.addListener(handleFocusChange);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void handleFocusChange() {
    if (!_focusNode.hasFocus) {
      double newValue = double.tryParse(_controller.text) ?? 0.0;
      if (newValue <= maxAmountToSpend) {
        setState(() => enteredAmount = newValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Amount'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                AmountSection(
                  enteredAmount: enteredAmount,
                  onAmountChanged: handleTextFieldChange,
                  maxAmountToSpend: maxAmountToSpend,
                  satoshiFormat: satoshiFormat,
                  onTap: () {
                    _focusNode.requestFocus();
                  },
                ),
                const SizedBox(height: 16),
                SliderSection(
                  enteredAmount: enteredAmount,
                  maxAmountToSpend: maxAmountToSpend,
                  onSliderChanged: onSliderChanged,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isAmountIncreased
                      ? () {
                          //reset the button state incase the user backtracks
                          setState(() {
                            isAmountIncreased = false;
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Send2(
                                amount: enteredAmount,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        isAmountIncreased ? Colors.orange : Colors.grey),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 50)),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16),
                InvisibleTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: handleTextFieldChange,
                  onSubmitted: (_) => printEnteredAmount(),
                ),
              ],
            ),
          ),
          if (widget.balance == 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: Text(
                    'You have no funds.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void onSliderChanged(double value) {
    setState(() {
      enteredAmount = value;
      isAmountIncreased = true;
    });
  }

  void handleTextFieldChange(String value) {
    if (value.isEmpty) {
      setState(() => enteredAmount = 0.0);
    } else {
      double newValue = double.tryParse(value) ?? 0.0;
      if (newValue > maxAmountToSpend) {
        showExceedBalanceWarning();
      } else {
        setState(() {
          enteredAmount = newValue;
          isAmountIncreased = true;
        });
      }
    }
  }

  void printEnteredAmount() {
    print('Entered amount: $enteredAmount');
  }

  void showExceedBalanceWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text(
            "You have exceeded your balance.",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class AmountSection extends StatelessWidget {
  final double enteredAmount;
  final ValueChanged<String> onAmountChanged;
  final double maxAmountToSpend;
  final NumberFormat satoshiFormat;
  final VoidCallback onTap;

  const AmountSection({
    super.key,
    required this.enteredAmount,
    required this.onAmountChanged,
    required this.maxAmountToSpend,
    required this.satoshiFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              satoshiFormat.format(enteredAmount),
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Tap the amount to edit',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class SliderSection extends StatelessWidget {
  final double enteredAmount;
  final double maxAmountToSpend;
  final ValueChanged<double> onSliderChanged;

  const SliderSection({
    super.key,
    required this.enteredAmount,
    required this.maxAmountToSpend,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Slider(
          value: enteredAmount,
          min: 0.0,
          max: maxAmountToSpend,
          onChanged: onSliderChanged,
          label: '\$${enteredAmount.toStringAsFixed(2)}',
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
        const SizedBox(height: 16),
        const Text(
          'Slide to increase amount',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Text(
          "Balance: ${maxAmountToSpend.toInt()} sats",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ],
    );
  }
}

class InvisibleTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  const InvisibleTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.transparent),
        cursorColor: Colors.transparent,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
