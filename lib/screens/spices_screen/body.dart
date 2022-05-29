import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jalapeno_spices/data/repository.dart';
import 'package:jalapeno_spices/models/spice_item.dart';
import 'package:jalapeno_spices/models/spice_manager.dart';
import 'package:jalapeno_spices/screens/empty_screen/empty_spice_screen.dart';
import 'package:jalapeno_spices/screens/lists_screen/spice_list_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);

    return StreamBuilder<List<SpiceItem>>(
        stream: repository.watchAllSpices(),
        builder: (context, AsyncSnapshot<List<SpiceItem>> snapshot) {
          final spiceItems = snapshot.data ?? [];

          if (spiceItems.isNotEmpty) {
            return Consumer<SpiceManager>(
              builder: (context, manager, child) {
                return SpiceListScreen(manager: manager);
              },
            );
          } else {
            return const EmptySpiceScreen();
          }
        });
  }
}
