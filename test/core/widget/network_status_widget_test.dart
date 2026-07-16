import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/core/widget/network_status_widget.dart';
import 'package:newmotorlube/generated/l10n.dart';

void main() {
  const offlineDelay = Duration(seconds: 2);
  const onlineMessageDuration = Duration(seconds: 3);

  testWidgets('does not show a warning for a transient offline event', (
    tester,
  ) async {
    final connectivity = FakeNetworkConnectivity(ConnectivityResult.wifi);
    addTearDown(connectivity.dispose);

    await tester.pumpWidget(
      _testApp(
        connectivity,
        offlineDelay: offlineDelay,
        onlineMessageDuration: onlineMessageDuration,
      ),
    );
    await tester.pump();

    connectivity.emit(ConnectivityResult.none);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    connectivity.emit(ConnectivityResult.wifi);
    await tester.pump();
    await tester.pump(offlineDelay);

    expect(find.text('No Internet Connection'), findsNothing);
    expect(find.text('Back Online'), findsNothing);
  });

  testWidgets('shows offline only after the status is confirmed', (
    tester,
  ) async {
    final connectivity = FakeNetworkConnectivity(ConnectivityResult.wifi);
    addTearDown(connectivity.dispose);

    await tester.pumpWidget(
      _testApp(
        connectivity,
        offlineDelay: offlineDelay,
        onlineMessageDuration: onlineMessageDuration,
      ),
    );
    await tester.pump();

    connectivity.emit(ConnectivityResult.none);
    await tester.pump();

    expect(find.text('No Internet Connection'), findsNothing);

    await tester.pump(offlineDelay);
    await tester.pump();

    expect(find.text('No Internet Connection'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
  });

  testWidgets('accepts other transports and briefly shows recovery', (
    tester,
  ) async {
    final connectivity = FakeNetworkConnectivity(ConnectivityResult.none);
    addTearDown(connectivity.dispose);

    await tester.pumpWidget(
      _testApp(
        connectivity,
        offlineDelay: offlineDelay,
        onlineMessageDuration: onlineMessageDuration,
      ),
    );
    await tester.pump(offlineDelay);
    await tester.pump();
    expect(find.text('No Internet Connection'), findsOneWidget);

    connectivity.emit(ConnectivityResult.other);
    await tester.pump();

    expect(find.text('Back Online'), findsOneWidget);
    expect(find.byIcon(Icons.wifi), findsOneWidget);

    await tester.pump(onlineMessageDuration);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Back Online'), findsNothing);
  });
}

Widget _testApp(
  NetworkConnectivity connectivity, {
  required Duration offlineDelay,
  required Duration onlineMessageDuration,
}) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(
      body: NetworkStatusWidget(
        connectivity: connectivity,
        offlineConfirmationDelay: offlineDelay,
        onlineMessageDuration: onlineMessageDuration,
        child: const SizedBox.expand(),
      ),
    ),
  );
}

class FakeNetworkConnectivity implements NetworkConnectivity {
  FakeNetworkConnectivity(ConnectivityResult initialResult)
    : _currentResult = [initialResult];

  final StreamController<List<ConnectivityResult>> _controller =
      StreamController<List<ConnectivityResult>>.broadcast();
  List<ConnectivityResult> _currentResult;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return _currentResult;
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _controller.stream;
  }

  void emit(ConnectivityResult result) {
    _currentResult = [result];
    _controller.add(_currentResult);
  }

  Future<void> dispose() => _controller.close();
}
