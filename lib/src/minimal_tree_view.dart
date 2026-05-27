import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'flutter_fancy_tree_view.dart';
import 'tree_data.dart';

class Node {
  Node({required this.title}) : children = <Node>[];

  final String title;
  final List<Node> children;
}

class TreeControllerNotifier extends Notifier<TreeController<Node>> {
  @override
  TreeController<Node> build() {
    final root = Node(title: '/');
    generateTreeNodes(root, (parent, title) {
      final child = Node(title: title);
      parent.children.add(child);
      return child;
    });

    final controller = TreeController<Node>(
      roots: root.children,
      childrenProvider: (Node node) => node.children,
    );
    ref.onDispose(controller.dispose);
    return controller;
  }
}

final treeControllerProvider =
    NotifierProvider<TreeControllerNotifier, TreeController<Node>>(
  TreeControllerNotifier.new,
);

final entryScopedProvider = Provider<TreeEntry<Node>>((ref) {
  throw UnimplementedError();
});

class MinimalTreeView extends ConsumerWidget {
  const MinimalTreeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeController = ref.watch(treeControllerProvider);
    return AnimatedTreeView<Node>(
      treeController: treeController,
      duration: Duration.zero,
      nodeBuilder: (BuildContext context, TreeEntry<Node> entry) {
        return ProviderScope(
          overrides: [
            entryScopedProvider.overrideWithValue(entry),
          ],
          child: const NodeItemWidget(),
        );
      },
    );
  }
}

class NodeItemWidget extends HookConsumerWidget {
  const NodeItemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(entryScopedProvider);
    final treeController = ref.read(treeControllerProvider);
    final isHovering = useState(false);

    return TreeIndentation(
      entry: entry,
      child: MouseRegion(
        onEnter: (_) => isHovering.value = true,
        onExit: (_) => isHovering.value = false,
        child: Row(
          children: [
            if (entry.hasChildren)
              ExpandIcon(
                size: 22,
                key: GlobalObjectKey(entry.node),
                isExpanded: entry.isExpanded,
                onPressed: (_) => treeController.toggleExpansion(entry.node),
              )
            else
              const SizedBox(height: 0, width: 8),
            Expanded(
              child: InkWell(
                onTap: (){},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(entry.node.title),
                )
              ),
            ),
            Visibility(
              visible: isHovering.value,
              child: const OptionsButton()
            )
          ],
        ),
      ),
    );
  }
}

class OptionsButton extends StatelessWidget {
  const OptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 16, color: Theme.of(context).colorScheme.outline),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'save',
          child: Row(
            children: [
              Icon(Icons.bookmark_add_outlined, size: 16),
              SizedBox(width: 8),
              Text('Save as...'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'extract',
          child: Row(
            children: [
              Icon(Icons.move_down, size: 16),
              SizedBox(width: 8),
              Text('Extract Widget'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {},
    );
  }
}