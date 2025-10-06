// Test básico para el Gestor de Archivos
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_3/main.dart';

void main() {
  testWidgets('File Manager App loads correctly', (WidgetTester tester) async {
    // Construir la app y disparar un frame
    await tester.pumpWidget(const FileManagerApp());

    // Verificar que la aplicación se carga
    expect(find.text('Gestor de Archivos'), findsOneWidget);
  });
}
