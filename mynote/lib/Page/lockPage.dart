import 'package:flutter/material.dart';
import 'package:mynote/Components/noteCard.dart';
import 'package:mynote/Page/protectedNotePage.dart'; // keep if you need it elsewhere

class LockPage extends StatefulWidget {
  const LockPage({super.key, required this.noteId});

  final int noteId;

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  final int pinLength = 4;
  final List<String> enteredPin = [];

  // ── helpers ─────────────────────────────────────────────
  void _onDigitPressed(String digit) {
    if (enteredPin.length < pinLength) {
      setState(() => enteredPin.add(digit));
      if (enteredPin.length == pinLength) _onPinComplete();
    }
  }

  void _onBackspace() {
    if (enteredPin.isNotEmpty) {
      setState(() => enteredPin.removeLast());
    }
  }

  void _onClear() => setState(enteredPin.clear);

  void _onPinComplete() {
    final pin = enteredPin.join();
    debugPrint('Entered PIN "$pin" for note ${widget.noteId}');

    // TODO: validate the PIN here
    if (pin == '1234')
        Navigator.push(context,MaterialPageRoute(builder: (context) => const ProtectedNotePage()));
    else
      _onClear();
  }

  // ── UI bits ─────────────────────────────────────────────
  Widget _buildKey(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 100,
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 55, 55, 55),
          ),
        ),
      ),
    );
  }

  String get _maskedPin {
    // build "* _ _ _" style string
    return List.generate(
      pinLength,
      (i) => i < enteredPin.length ? '*' : '_',
    ).join('  ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Header
          const Center(
            child: Text(
              'Locked',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 55, 55),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Icon(
            Icons.lock,
            size: 30,
            color: Color.fromARGB(255, 55, 55, 55),
          ),
          const SizedBox(height: 60),

          // PIN display
          Center(
            child: Text(
              _maskedPin,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Color.fromARGB(255, 55, 55, 55),
              ),
            ),
          ),
          const SizedBox(height: 90),

          // Number pad
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('1', () => _onDigitPressed('1')),
                  _buildKey('2', () => _onDigitPressed('2')),
                  _buildKey('3', () => _onDigitPressed('3')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('4', () => _onDigitPressed('4')),
                  _buildKey('5', () => _onDigitPressed('5')),
                  _buildKey('6', () => _onDigitPressed('6')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('7', () => _onDigitPressed('7')),
                  _buildKey('8', () => _onDigitPressed('8')),
                  _buildKey('9', () => _onDigitPressed('9')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKey('←', _onBackspace),
                  _buildKey('0', () => _onDigitPressed('0')),
                  _buildKey('Clear', _onClear),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
