import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DateTime selectedDate;

  const HomeAppBar({super.key, required this.selectedDate});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40); // Increased height to accommodate the custom design

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false, // No back button
      titleSpacing: 0,
      elevation: 0,
      toolbarHeight: preferredSize.height,
      backgroundColor:
          theme.scaffoldBackgroundColor, // Match scaffold background
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.wb_sunny_outlined, // Icon that resembles the image
                color: theme.colorScheme.surface,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                DateFormat('EEEE, d').format(selectedDate), // e.g., Tuesday, 16
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'Sunny, 24°C', // Hardcoded for now
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
