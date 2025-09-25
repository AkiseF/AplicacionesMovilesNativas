import 'package:flutter/material.dart';

class ListItem {
  final int id;
  final String title;
  final String description;

  ListItem({required this.id, required this.title, required this.description});
}

class CustomListItem extends StatelessWidget {
  final ListItem item;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;

  const CustomListItem({
    super.key,
    required this.item,
    this.onTap,
    this.trailing,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: leading ?? CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            '${item.id}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.description),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<ListItem> items;
  final Function(ListItem)? onItemTap;
  final String? title;
  final String? description;

  const CustomListView({
    super.key,
    required this.items,
    this.onItemTap,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null || description != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (title != null && description != null)
                  const SizedBox(height: 8),
                if (description != null)
                  Text(
                    description!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CustomListItem(
                item: item,
                onTap: onItemTap != null ? () => onItemTap!(item) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}