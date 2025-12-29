import 'package:flutter/material.dart';
import 'package:newmotorlube/main.dart';

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <_ManagerCard>[
      _ManagerCard(
        title: 'Customers',
        description: 'Customers control panel',
        icon: Icons.person,
        color: Colors.blue,
        routeName: 'adminCustomersPage',
      ),
      _ManagerCard(
        title: 'Technicians',
        description: 'Technicians control panel',
        icon: Icons.engineering,
        color: Colors.green,
        routeName: 'adminTechPage',
      ),
      _ManagerCard(
        title: 'Coupons',
        description: 'Create discount coupons',
        icon: Icons.discount,
        color: Colors.amber,
        routeName: 'couponListPage',
      ),
      _ManagerCard(
        title: 'Ratings',
        description: 'View customer ratings',
        icon: Icons.rate_review,
        color: Colors.black87,
        routeName: 'ratingResultsPage',
      ),
      _ManagerCard(
        title: 'Promotions',
        description: 'Promotion control panel',
        icon: Icons.campaign,
        color: Colors.purple,
        routeName: 'promotionControlPanel',
      ),
      _ManagerCard(
        title: 'Create Promotion',
        description: 'Add a new promotion',
        icon: Icons.add_circle,
        color: Colors.teal,
        routeName: 'createPromotionScreen',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return _ManagerOptionCard(card: card);
          },
        ),
      ),
    );
  }
}

class _ManagerCard {
  const _ManagerCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.routeName,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String routeName;
}

class _ManagerOptionCard extends StatelessWidget {
  const _ManagerOptionCard({required this.card});

  final _ManagerCard card;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: card.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: card.color,
              radius: 24,
              child: Icon(card.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              card.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: card.color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                card.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) async {
    try {
      await Navigator.of(navigatorKey.currentContext ?? context)
          .pushNamed(card.routeName);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Route "${card.routeName}" is not available.')),
      );
    }
  }
}
