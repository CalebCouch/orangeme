import 'package:flutter/material.dart';
import 'package:orange/bip39_wordlist.dart';
import 'package:orange/screens/spending/spending_dashboard.dart';

class ImportSeed extends StatefulWidget {
  const ImportSeed({super.key});
  @override
  ImportSeedState createState() => ImportSeedState();
}

class ImportSeedState extends State<ImportSeed> {
  String seed = ''; // State variable for the text input
  final List<TextEditingController> _controllers =
      List.generate(12, (index) => TextEditingController());
  final List<bool> _isValid = List.generate(12, (index) => false);
  bool _isButtonEnabled = false;

  void validateWord(int index) {
    final inputWord = _controllers[index].text.toLowerCase().trim();
    // Check if the input word is in the BIP39 word list
    if (bip39WordList.contains(inputWord)) {
      setState(() {
        _isValid[index] = true; // Word is valid
      });
    } else {
      setState(() {
        _isValid[index] = false; // Word is invalid
      });
    }
    _checkButton();
  }

  void _checkButton() {
    bool allValid = _isValid.every((isValid) => isValid);

    setState(() {
      _isButtonEnabled = allValid;
    });
  }

  Future<void> writeSeedToFile(String content) async {
    //write seed to file
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import a 12 Word Seed Phrase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (_, rowIndex) {
                  // Calculate the indexes for the two words in the current row
                  int index1 = rowIndex * 2;
                  int index2 = index1 + 1;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: wordInputField(index1),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: wordInputField(index2),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: _isButtonEnabled
                      ? () {
                          // Concatenate words to form the seed phrase
                          final seedPhrase =
                              _controllers.map((c) => c.text).join(' ').trim();
                          print("Seed Phrase: $seedPhrase");
                          // Proceed with the seed phrase
                          writeSeedToFile(seedPhrase);
                          print('Proceed button pressed');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SpendingDashboard()));
                        }
                      : null,
                  child: const Text(
                    'Proceed',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget wordInputField(int index) {
    return Row(
      children: [
        Text('${index + 1}.', style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _controllers[index],
            decoration: InputDecoration(
              hintText: 'Word ${index + 1}',
              suffixIcon: _isValid[index]
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
            ),
            onChanged: (_) => validateWord(index),
          ),
        ),
      ],
    );
  }
}
