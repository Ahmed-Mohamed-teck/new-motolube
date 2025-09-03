import 'package:flutter/material.dart';

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _HorizontalStepperScreenState();
}

class _HorizontalStepperScreenState extends State<BookServiceScreen> {
  int _currentStep = 0;

  final List<Widget> _stepContents = const [
    Center(child: Text('Step 1 Content', style: TextStyle(fontSize: 20))),
    Center(child: Text('Step 2 Content', style: TextStyle(fontSize: 20))),
    Center(child: Text('Step 3 Content', style: TextStyle(fontSize: 20))),
    Center(child: Text('Step 4 Content', style: TextStyle(fontSize: 20))),
  ];

  void _goToNext() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goToPrevious() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentStep == _stepContents.length - 1;
    final isFirst = _currentStep == 0;

    return Scaffold(
      body: Column(
        children: [
          // Horizontal Step Indicator
          SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_stepContents.length, (index) {
                final isActive = index == _currentStep;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: isActive ? 18 : 14,
                      backgroundColor: isActive ? Colors.amber : Colors.grey[400],
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Step ${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          const Divider(thickness: 1),

          // Step Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
              child: Container(
                key: ValueKey<int>(_currentStep),
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                child: _stepContents[_currentStep],
              ),
            ),
          ),

          // Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isFirst)
                    OutlinedButton(
                      onPressed: _goToPrevious,
                      child: const Text('Back'),
                    ),
                  ElevatedButton(
                    onPressed: isLast ? null : _goToNext,
                    child: Text(isLast ? 'Done' : 'Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
