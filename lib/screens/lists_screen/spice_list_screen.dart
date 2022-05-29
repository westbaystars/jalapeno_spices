import 'package:flutter/material.dart';

import 'package:jalapeno_spices/components/spice_tile.dart';
import 'package:jalapeno_spices/data/repository.dart';
import 'package:jalapeno_spices/models/models.dart';
import 'package:jalapeno_spices/screens/empty_screen/empty_spice_screen.dart';
import 'package:jalapeno_spices/screens/item_screen/spice_item_screen.dart';
import 'package:provider/provider.dart';

class SpiceListScreen extends StatefulWidget {
  final SpiceManager manager;
  const SpiceListScreen({Key? key, required this.manager}) : super(key: key);

  @override
  State<SpiceListScreen> createState() => _SpiceListScreenState();
}

class _SpiceListScreenState extends State<SpiceListScreen> {
  late Offset _tapDownPosition;

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);

    return StreamBuilder<List<SpiceItem>>(
      stream: repository.watchAllSpices(),
      builder: (context, AsyncSnapshot<List<SpiceItem>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final spiceItems = snapshot.data ?? [];

          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.59,
            children: List.generate(spiceItems.length, (index) {
              final itemSpice = spiceItems[index];

              return GestureDetector(
                child: SpiceTile(
                  key: Key(itemSpice.id.toString()),
                  item: itemSpice,
                  onComplete: (change) {
                    if (change != null) {
                      widget.manager.lowItem(index, change);
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SpiceItemScreen(
                          manager: widget.manager,
                          originalItem: itemSpice,
                          onCreate: (_) {},
                          onUpdate: (item) {
                            widget.manager.updateItem(item, index);
                            repository.updateSpice(item);
                            Navigator.pop(context);
                          },
                        )),
                  );
                },
                onTapDown: (TapDownDetails details){
                  _tapDownPosition = details.globalPosition;
                },
                onLongPress: () async {
                  final RenderObject? overlay = Overlay.of(context)!.context.findRenderObject();

                  await showMenu(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    position: RelativeRect.fromLTRB(
                      _tapDownPosition.dx,
                      _tapDownPosition.dy,
                      overlay!.semanticBounds.width - _tapDownPosition.dx,
                      overlay.semanticBounds.height - _tapDownPosition.dy,
                    ),
                    items: [
                      const PopupMenuItem(
                        child: Icon(Icons.delete),
                        value: 'Delete',
                      ),
                    ],
                  ).then((value) {
                    if (value == 'Delete') {
                      deleteSpice(repository, itemSpice);
                    }
                  });
                },
              );
            }),
          );
        } else {
          return const EmptySpiceScreen();
        }
      },
    );
  }

  void deleteSpice(Repository repository, SpiceItem spiceItem) async {
    if (spiceItem.id != null) {
      repository.deleteSpice(spiceItem);

      setState(() {});
    } else {
      // ignore: avoid_print
      print('Spice id is null');
    }
  }
}
