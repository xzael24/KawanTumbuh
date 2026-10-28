import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kawan_tumbuh/main.dart';

void main() {
  testWidgets('SplashScreen tampil dengan benar', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const KawanTumbuhApp());

    // Cek teks KawanTumbuh dan tagline ada di layar
    expect(find.text('KawanTumbuh'), findsOneWidget);
    expect(find.text('Teman Tumbuh Si Kecil'), findsOneWidget);
  });
}
