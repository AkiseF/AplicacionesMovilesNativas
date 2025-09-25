import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  final String title;
  final String content;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  const ResultDisplay({
    super.key,
    required this.title,
    required this.content,
    this.backgroundColor,
    this.titleStyle,
    this.contentStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle ?? const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: contentStyle ?? const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class CounterDisplay extends StatelessWidget {
  final String label;
  final int count;
  final TextStyle? labelStyle;
  final TextStyle? countStyle;

  const CounterDisplay({
    super.key,
    required this.label,
    required this.count,
    this.labelStyle,
    this.countStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label $count veces',
      style: labelStyle ?? const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class StatusDisplay extends StatelessWidget {
  final String status;
  final bool isLoading;
  final Widget? loadingWidget;
  final Color? statusColor;

  const StatusDisplay({
    super.key,
    required this.status,
    this.isLoading = false,
    this.loadingWidget,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: statusColor ?? Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.info, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            const Text(
              'Estado de la Actividad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            if (isLoading) ...[
              const SizedBox(height: 16),
              loadingWidget ?? const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}