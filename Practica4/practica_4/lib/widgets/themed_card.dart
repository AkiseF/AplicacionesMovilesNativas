import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool showThemeAccent;
  final double? elevation;

  const ThemedCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.onTap,
    this.showThemeAccent = true,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final primaryColor = Theme.of(context).primaryColor;
        
        Widget cardChild = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // Add a subtle border with theme color if showThemeAccent is true
            border: showThemeAccent 
              ? Border.all(
                  color: primaryColor.withValues(alpha: 0.2),
                  width: 1,
                )
              : null,
            // Add a subtle gradient overlay
            gradient: showThemeAccent
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.transparent,
                    primaryColor.withValues(alpha: 0.03),
                  ],
                )
              : null,
          ),
          child: Card(
            elevation: elevation ?? 4,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: padding != null 
              ? Padding(padding: padding!, child: child)
              : child,
          ),
        );

        if (onTap != null) {
          cardChild = InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: cardChild,
          );
        }

        return Container(
          margin: margin ?? const EdgeInsets.all(8),
          child: cardChild,
        );
      },
    );
  }
}

class ThemedGameModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ThemedGameModeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final primaryColor = Theme.of(context).primaryColor;
        
        return ThemedCard(
          onTap: onTap,
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: primaryColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        );
      },
    );
  }
}