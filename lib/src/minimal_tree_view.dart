import 'package:flutter/material.dart';

import 'flutter_fancy_tree_view.dart';
import 'tree_data.dart';

class Node {
  Node({required this.title}) : children = <Node>[];

  final String title;
  final List<Node> children;
}

class MinimalTreeView extends StatefulWidget {
  const MinimalTreeView({super.key});

  @override
  State<MinimalTreeView> createState() => _MinimalTreeViewState();
}

class _MinimalTreeViewState extends State<MinimalTreeView> {
  late final TreeController<Node> treeController;
  late final Node root = Node(title: '/');

  @override
  void initState() {
    super.initState();
    generateTreeNodes(root, (parent, title) {
      final child = Node(title: title);
      parent.children.add(child);
      return child;
    });

    treeController = TreeController<Node>(
      roots: root.children,
      childrenProvider: (Node node) => node.children,
    );
  }

  @override
  void dispose() {
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTreeView<Node>(
      treeController: treeController,
      duration: Duration.zero,
      nodeBuilder: (BuildContext context, TreeEntry<Node> entry) {
        return TreeIndentation(
          entry: entry,
          child: Row(
            children: [
              if (entry.hasChildren)
                ExpandIcon(
                  key: GlobalObjectKey(entry.node),
                  isExpanded: entry.isExpanded,
                  onPressed: (_) => treeController.toggleExpansion(entry.node),
                )
              else
                const SizedBox(height: 35, width: 8),
              Expanded(
                child: InkWell(
                  onTap: (){},
                  child: Text(entry.node.title)
                ),
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.more_vert, size: 16, color: Theme.of(context).colorScheme.outline),
                ),
                onTap: (){},
              ),
            ],
          ),
        );
      },
    );
  }
}
