import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/spice_item.dart';

class SpiceTile extends StatefulWidget {
  final SpiceItem item;
  final Function(bool?)? onComplete;
  const SpiceTile({Key? key, required this.item ,this.onComplete}) : super(key: key);

  @override
  State<SpiceTile> createState() => _SpiceTileState();
}

class _SpiceTileState extends State<SpiceTile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.38,
          width: size.width * 0.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                    ),
                    elevation: 5,
                    color: Theme.of(context).cardColor,
                    shadowColor: Theme.of(context).shadowColor,
                    child: SizedBox(
                      height: size.height * 0.3,
                      width: size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              widget.item.name,
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                          Text('Expires on:' , style: const TextStyle(color: Colors.grey, fontSize: 14)),
                            const SizedBox(height: 3),
                            buildDate(),
                            const SizedBox(height: 8),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                /*
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        widget.item.name,
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      buildDate(),
                    ],
                  ),
                ),
                 */
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDate() {
    final dateString = DateFormat("MMM dd, yyyy").format(widget.item.expiration_date);
    return Text(dateString , style: const TextStyle(color: Colors.grey, fontSize: 14));
  }
}
