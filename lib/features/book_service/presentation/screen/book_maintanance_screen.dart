import 'package:flutter/material.dart';
import 'package:newmotorlube/features/user_cars/presentation/widget/user_car_list_item.dart';

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _HorizontalStepperScreenState();
}

class _HorizontalStepperScreenState extends State<BookServiceScreen> {
  int _currentStep = 0;
  int? _selectedCar;
  int? _selectedService;

  final List<Map<String, String>> _cars = [
    {
      'image': 'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg',
      'model': 'Nissan Sunny 2022',
      'plate': 'ABC-1234',
      'chassis': 'JTNBE46KX63012345',
    },
    {
      'image': 'https://images.pexels.com/photos/210017/pexels-photo-210017.jpeg',
      'model': 'Toyota Camry 2022',
      'plate': 'XYZ-9876',
      'chassis': 'JTNBE46KX63012345',
    },
  ];

  final List<String> _services = [
    'Basic Services',
    'Major Services',
    'Car Repair',
    'Batteries',
    'Car Wash',
  ];

  List<Widget> get _stepContents => [
        _buildCarStep(),
        _buildServiceStep(),
        const Center(child: Text('Step 3 Content', style: TextStyle(fontSize: 20))),
        const Center(child: Text('Step 4 Content', style: TextStyle(fontSize: 20))),
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

  Widget _buildCarStep() {
    return ListView.separated(
      itemCount: _cars.length,
      itemBuilder: (context, index) {
        final car = _cars[index];
        final isSelected = _selectedCar == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedCar = index),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.amber : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CarCard(
              car: CarInfo(
                imageUrl: car['image']!,
                model: car['model']!,
                plate: car['plate']!,
                chassis: car['chassis']!,
              ),
              heroTag: 'car-$index',
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }

  Widget _buildServiceStep() {
    return ListView.separated(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final isSelected = _selectedService == index;
        return Card(
          color: isSelected ? Colors.amber[100] : null,
          child: ListTile(
            title: Text(_services[index]),
            onTap: () => setState(() => _selectedService = index),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = _stepContents;
    final isLast = _currentStep == steps.length - 1;
    final isFirst = _currentStep == 0;

    return Scaffold(
      body: Column(
        children: [
          // Horizontal Step Indicator
          SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(steps.length, (index) {
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
                child: steps[_currentStep],
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
