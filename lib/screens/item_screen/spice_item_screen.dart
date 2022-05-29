import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:jalapeno_spices/data/repository.dart';
import 'package:jalapeno_spices/models/models.dart';


class SpiceItemScreen extends StatefulWidget {
  final Function(SpiceItem) onCreate;
  final Function(SpiceItem) onUpdate;
  final SpiceItem? originalItem;
  final bool isUpdating;
  final SpiceManager manager;

  const SpiceItemScreen({Key? key, required this.onCreate, required this.onUpdate, this.originalItem, required this.manager}) : isUpdating = (originalItem != null), super(key: key);

  @override
  _SpiceItemScreenState createState() => _SpiceItemScreenState();
}

class _SpiceItemScreenState extends State<SpiceItemScreen> {
  final _nameController =  TextEditingController();
  String _name = '';
  final _dateController = TextEditingController();
  DateTime _selected_date = DateTime.now().add(Duration(days: 9*30));

  @override
  void initState() {
    final originalItem = widget.originalItem;
    if (originalItem != null) {
      _nameController.text = originalItem.name;
      _name = originalItem.name;
      _dateController.text = DateFormat.yMMMMd().format(originalItem.expiration_date);
      _selected_date = originalItem.expiration_date;
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });

    _dateController.addListener(() {
      setState(() {
        _selected_date = DateTime.parse(_dateController.text);
      });
    });

    widget.manager.getOldSpices();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      child: const Icon(Icons.arrow_back_ios_new, size: 19),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  // build nameField
                  buildNameField(),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      final genDate = DateTime(
                        _selected_date.year,
                        _selected_date.month,
                        _selected_date.day,
                      );

                      final spiceItem = SpiceItem(
                        id: widget.originalItem?.id ?? "0",
                        name: _nameController.text,
                        expiration_date: genDate,
                        is_low: false,
                      );

                      if (widget.isUpdating) {
                        widget.onUpdate(spiceItem);
                        repository.updateSpice(spiceItem);
                      } else {
                        widget.onCreate(spiceItem);
                        repository.insertSpice(spiceItem);
                      }
                      widget.manager.addItem(spiceItem);
                      widget.manager.saveOldSpices();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        width: size.width * 0.75,
        height: size.width * 0.1,
        child: TextField(
          controller: _nameController,
          cursorHeight: 18,
          cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
          style: Theme.of(context).textTheme.headline2,
          decoration: const InputDecoration(
            hintText: 'Name of the spice',
            contentPadding: EdgeInsets.symmetric(vertical: 15 ,horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
