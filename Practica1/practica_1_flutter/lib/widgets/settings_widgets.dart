import 'package:flutter/material.dart';

class SettingsCheckboxTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? subtitle;

  const SettingsCheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      subtitle: subtitle,
      value: value,
      onChanged: (newValue) => onChanged(newValue ?? false),
    );
  }
}

class SettingsRadioTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final Widget? subtitle;

  const SettingsRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Note: Using deprecated RadioListTile for compatibility
    // Consider migrating to RadioGroup when available in stable
    return RadioListTile<T>(
      title: Text(title),
      subtitle: subtitle,
      value: value,
      groupValue: groupValue,
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? subtitle;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }
}