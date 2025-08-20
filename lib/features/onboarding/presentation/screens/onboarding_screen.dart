import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/current_locale_provider.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/ui_components/shared_ui.dart';
import '../../../../generated/l10n.dart';
import '../../onboarding_page_data.dart';
import 'package:intl/intl.dart';



class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;


  late List<OnboardingPageData> _pages;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = [
      OnboardingPageData(
        imageAsset: 'assets/onboarding/onboarding-1.png',
        title: S.of(context).onBoardingTitle1,
        subtitle: S.of(context).onBoardingDescription1,
      ),
      OnboardingPageData(
        imageAsset: 'assets/onboarding/onboarding-2.png',
        title: S.of(context).onBoardingTitle2,
        subtitle:  S.of(context).onBoardingDescription2,
      ),
      OnboardingPageData(
        imageAsset: 'assets/onboarding/onboarding-3.png',
        title: S.of(context).onBoardingTitle3,
        subtitle:  S.of(context).onBoardingDescription3,
      ),
    ];
  }


  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, 'loginScreen');
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Top bar: globe icon + skip
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.public),
                    onPressed: () {
                      buildShowLangBottomSheet(context,ref);
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _goToLogin,
                    child:  Text(appLang.skip,style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, i) {
                    final page = _pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Example: load from assets. Replace with your own images.
                        Image.asset(
                          page.imageAsset,
                          height: 240,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.subtitle,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Dot indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final isActive = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.lightPrimary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Next / Get Started button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.amber[600],
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: Text(isLast ? S.of(context).start : S.of(context).next),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

}
