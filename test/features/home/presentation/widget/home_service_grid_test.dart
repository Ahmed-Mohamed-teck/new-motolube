import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/home/domain/entity/main_category_entity.dart';
import 'package:newmotorlube/features/home/domain/repository/i_home_repository.dart';
import 'package:newmotorlube/features/home/domain/use_case/get_main_categories_use_case.dart';
import 'package:newmotorlube/features/home/presentaion/screen/base_home_screen.dart';
import 'package:newmotorlube/features/home/presentaion/view_model/main_categories_state.dart';
import 'package:newmotorlube/features/home/presentaion/view_model/main_categories_view_model.dart';
import 'package:newmotorlube/features/home/presentaion/widget/home_service_grid.dart';
import 'package:newmotorlube/features/home/provider/home_provider.dart' as home;

void main() {
  const categories = [
    MainCategoryEntity(id: '1', titleEn: 'Oil change', titleAr: 'تغيير الزيت'),
    MainCategoryEntity(id: '2', titleEn: 'Brakes', titleAr: 'الفرامل'),
    MainCategoryEntity(id: '3', titleEn: 'Battery', titleAr: 'البطارية'),
    MainCategoryEntity(id: '4', titleEn: 'Tires', titleAr: 'الإطارات'),
    MainCategoryEntity(id: '5', titleEn: 'Inspection', titleAr: 'الفحص'),
    MainCategoryEntity(
      id: '6',
      titleEn: 'Air conditioning',
      titleAr: 'التكييف',
    ),
  ];

  testWidgets('renders services in a scrollable horizontal rail', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(categories));
    await tester.pump();

    final listFinder = find.byKey(
      const PageStorageKey<String>('home-services-horizontal-list'),
    );
    final listView = tester.widget<ListView>(listFinder);
    final scrollable = tester.state<ScrollableState>(
      find.descendant(of: listFinder, matching: find.byType(Scrollable)),
    );

    expect(listView.scrollDirection, Axis.horizontal);
    expect(scrollable.position.maxScrollExtent, greaterThan(0));

    await tester.drag(listFinder, const Offset(-220, 0));
    await tester.pumpAndSettle();

    expect(scrollable.position.pixels, greaterThan(0));
  });

  testWidgets('selects a service and opens the booking tab when tapped', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(categories));
    await tester.pump();

    final context = tester.element(find.byType(HomeServiceGrid));
    final container = ProviderScope.containerOf(context);

    await tester.tap(find.byKey(const ValueKey<String>('home-service-1')));
    await tester.pump();

    expect(container.read(home.selectedMainCategoryProvider)?.id, '1');
    expect(container.read(currentNavBottomIndexProvider), 2);
  });
}

Widget _buildSubject(List<MainCategoryEntity> categories) {
  return ProviderScope(
    overrides: [
      home.mainCategoriesViewModelProvider.overrideWith(
        (ref) => _LoadedMainCategoriesViewModel(categories),
      ),
    ],
    child: const MaterialApp(
      home: Scaffold(body: HomeServiceGrid(isAuthenticated: true)),
    ),
  );
}

class _LoadedMainCategoriesViewModel extends MainCategoriesViewModel {
  _LoadedMainCategoriesViewModel(List<MainCategoryEntity> categories)
    : super(GetMainCategoriesUseCase(_FakeHomeRepository())) {
    state = MainCategoriesLoaded(categories);
  }
}

class _FakeHomeRepository implements IHomeRepository {
  @override
  Future<List<MainCategoryEntity>> getMainCategories() async => const [];
}
