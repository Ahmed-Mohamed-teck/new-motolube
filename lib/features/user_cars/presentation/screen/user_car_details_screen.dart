import 'package:flutter/material.dart';
import 'package:newmotorlube/core/widget/image_loader.dart';
import 'package:newmotorlube/core/widget/internal_app_bar.dart';
import '../../domain/entity/car_entity.dart';

class UserCarDetailsScreen extends StatefulWidget {
  const UserCarDetailsScreen({super.key, required this.car});
  final CarEntity car;

  @override
  State<UserCarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<UserCarDetailsScreen> {
  final _pageCtrl = PageController();
  final _thumbScrollCtrl = ScrollController();
  int _page = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _thumbScrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasImages = car.carImages.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: InternalAppBar(title: 'Car details'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // === Top gallery =================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 16 / 10,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            PageView.builder(
                              controller: _pageCtrl,
                              itemCount: hasImages ? car.carImages.length : 1,
                              onPageChanged: (i) {
                                setState(() => _page = i);
                                // Optional: keep selected thumb visible
                                _ensureThumbVisible(i);
                              },
                              itemBuilder: (_, i) {
                                final src = hasImages
                                    ? car.carImages[i]
                                    : 'assets/placeholder_car.jpg';
                                final isAsset = src.trim().toLowerCase().startsWith('assets/');
                                final img = isAsset
                                    ? Image.asset(src, fit: BoxFit.cover)
                                    : Image.network(src, fit: BoxFit.cover);

                                return Container(
                                  color: isDark ? Colors.black : const Color(0xFFF2F2F2),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(child: img),
                                      // subtle gradient for text/icons legibility
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        height: 120,
                                        child: IgnorePointer(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [Colors.black54, Colors.transparent],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // car name over image
                                      Positioned(
                                        left: 12,
                                        right: 12,
                                        bottom: 12,
                                        child: Text(
                                          '${car.carModel} • ${car.modelYear}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            shadows: const [Shadow(blurRadius: 6, color: Colors.black54)],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // page dots (kept)
                            if (hasImages && car.carImages.length > 1)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _Dots(
                                  count: car.carImages.length,
                                  index: _page,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // === ADDED: Thumbnail strip =================================
                    if (hasImages && car.carImages.length > 1)
                      SizedBox(
                        height: 70,
                        child: ListView.separated(
                          controller: _thumbScrollCtrl,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          itemCount: car.carImages.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final src = car.carImages[i];
                            final isSelected = i == _page;
                            return GestureDetector(
                              onTap: () {
                                _pageCtrl.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.dividerColor.withOpacity(.5),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                      color: theme.colorScheme.primary.withOpacity(.15),
                                    )
                                  ]
                                      : null,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: _ThumbImage(src: src),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // === Summary card ================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _Card(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.directions_car, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${car.manufacturer}",
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(car.carModel, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _Chip(icon: Icons.numbers, label: car.arabicPlate.join()),
                                _Chip(icon: Icons.event, label: car.modelYear),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // === Details list ================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _Card(
                  child: Column(
                    children:  [
                      _InfoTile(title: 'Car name', value: '', icon: Icons.directions_car_filled),
                      _Divider(),
                      _InfoTile(title: 'Car model', value: '', icon: Icons.view_in_ar),
                      _Divider(),
                      _InfoTile(title: 'Plate', value: '', icon: Icons.credit_card),
                      _Divider(),
                      _InfoTile(title: 'Chassis (VIN)', value: '', icon: Icons.qr_code_2),
                      _Divider(),
                      _InfoTile(title: 'Year of manufacture', value: '', icon: Icons.event),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // === Actions ======================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {/* TODO: open edit flow */},
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit info'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {/* TODO: confirm delete */},
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('Delete car'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.redAccent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ensure the selected thumbnail stays visible when you swipe the PageView.
  void _ensureThumbVisible(int index) {
    if (!_thumbScrollCtrl.hasClients) return;
    const itemExtent = 98.0; // width 90 + separator 8
    final target = (index * itemExtent) - (itemExtent * 1.5);
    _thumbScrollCtrl.animateTo(
      target.clamp(0, _thumbScrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

// ======= Small building blocks ===============================================

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(.4)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(.05),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor)),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),

      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 20,
      thickness: 1,
      color: Theme.of(context).dividerColor.withOpacity(.3),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final selected = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: selected ? 16 : 6,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white70,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

// Small helper to render a thumb from asset or network.
class _ThumbImage extends StatelessWidget {
  const _ThumbImage({required this.src});
  final String src;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), child: ImageLoader(url: src, placeholder: Center(child: Icon(Icons.broken_image))));
  }
}

