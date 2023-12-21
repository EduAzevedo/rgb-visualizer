import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rgb_visualizer/src/models/saved_color.dart';

class SavedColorCard extends StatefulWidget {
  final SavedColor savedColor;
  final Function(SavedColor) removeFromList;
  const SavedColorCard(
      {Key? key, required this.savedColor, required this.removeFromList})
      : super(key: key);

  @override
  State<SavedColorCard> createState() => _SavedColorCardState();
}

class _SavedColorCardState extends State<SavedColorCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.savedColor.color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.savedColor.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.savedColor.isSavedInRGB
                      ? "RGB(${widget.savedColor.color.red}, ${widget.savedColor.color.green}, ${widget.savedColor.color.blue})"
                      : "HEX: ${widget.savedColor.hex}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showColorOptionsModal(
                    context, widget.savedColor, widget.removeFromList);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorOptionsModal(BuildContext context, SavedColor savedColor,
      Function(SavedColor) removeFromList) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.savedColor.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: widget.savedColor.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: FittedBox(
                      child: Text(
                        widget.savedColor.isSavedInRGB
                            ? "RGB(${widget.savedColor.color.red}, ${widget.savedColor.color.green}, ${widget.savedColor.color.blue})"
                            : "HEX: ${widget.savedColor.hex}",
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _copyToClipboard(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Ionicons.clipboard_outline, color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "COPIAR",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  removeFromList(savedColor);
                  Navigator.of(context).pop();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Ionicons.trash_outline,
                      color: Colors.red,
                    ),
                    Text(
                      "Remover",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyToClipboard(BuildContext context) {
    String codeToCopy = widget.savedColor.isSavedInRGB
        ? "RGB(${widget.savedColor.color.red}, ${widget.savedColor.color.green}, ${widget.savedColor.color.blue})"
        : widget.savedColor.hex.toString().toUpperCase();

    Clipboard.setData(ClipboardData(text: codeToCopy));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Código copiado para a área de transferência')),
    );
  }
}
