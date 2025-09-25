# Widgets Personalizados

Esta carpeta contiene widgets reutilizables extraídos de las pantallas principales de la aplicación.

## Widgets disponibles:

### NavigationCard
Widget para tarjetas de navegación con icono, título, subtítulo y acción de tap.

**Uso:**
```dart
NavigationCard(
  title: 'Título',
  subtitle: 'Subtítulo',
  icon: Icons.star,
  onTap: () => // Acción
)
```

### ProgressIndicatorWidget
Widget animado que muestra progreso con indicador circular y lineal.

**Uso:**
```dart
ProgressIndicatorWidget(
  onStart: () => // Callback opcional
)
```

### ImageCarousel
Widget para mostrar una secuencia de iconos con navegación.

**Uso:**
```dart
ImageCarousel(
  icons: [Icons.star, Icons.home],
  names: ['Estrella', 'Casa'],
)
```

### InfoListWidget
Widget para mostrar listas de información con iconos.

**Uso:**
```dart
InfoListWidget(
  title: 'Información',
  items: [
    InfoListItem(
      icon: Icons.info,
      text: 'Texto informativo',
      iconColor: Colors.blue,
    ),
  ],
)
```

### CustomListWidget
Widget para listas personalizadas con elementos clickeables.

**Uso:**
```dart
CustomListView(
  items: listItems,
  title: 'Mi Lista',
  onItemTap: (item) => // Callback
)
```

### FormFieldWidget
Widgets para campos de formulario con diferentes tipos.

**Uso:**
```dart
CustomFormField(
  controller: controller,
  label: 'Campo',
  type: FormFieldType.text,
)
```

### SettingsWidgets
Widgets para elementos de configuración (checkbox, radio, switch).

**Uso:**
```dart
SettingsSection(
  title: 'Configuración',
  children: [
    SettingsCheckboxTile(
      title: 'Opción',
      value: true,
      onChanged: (value) => // Callback
    ),
  ],
)
```

### CustomButton
Widget para botones personalizados con diferentes tipos.

**Uso:**
```dart
CustomButton(
  text: 'Botón',
  type: ButtonType.elevated,
  onPressed: () => // Callback
)
```

### ResultDisplay
Widget para mostrar resultados y estados.

**Uso:**
```dart
ResultDisplay(
  title: 'Resultado',
  content: 'Contenido del resultado',
)
```

## Importación

Para usar todos los widgets:
```dart
import '../widgets/widgets.dart';
```

O importar widgets individuales:
```dart
import '../widgets/navigation_card.dart';
```