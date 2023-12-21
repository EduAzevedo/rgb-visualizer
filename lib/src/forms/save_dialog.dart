// ignore_for_file: library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:rgb_visualizer/src/models/saved_color.dart';

class SaveDialog extends StatefulWidget {
  final Function(SaveType, String) onSave;

  const SaveDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  _SaveDialogState createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  TextEditingController _colorNameController = TextEditingController();
  SaveType _selectedSaveType = SaveType.RGB;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 224, 224, 224),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "SALVAR COR",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 50,
              child: TextField(
                controller: _colorNameController,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  hintStyle: TextStyle(
                    color: Colors.black45,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.black38, fontSize: 18),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.black26)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.black26)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 300,
                  child: Text(
                    "Salvar como:",
                    textAlign: TextAlign.start,
                  ),
                ),
                _buildSaveTypeRadioButton(SaveType.RGB),
                _buildSaveTypeRadioButton(SaveType.HEX),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveColor,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: const Text(
                  "CONFIRMAR",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveTypeRadioButton(SaveType saveType) {
    return Row(
      children: [
        Radio<SaveType>(
          value: saveType,
          groupValue: _selectedSaveType,
          onChanged: (SaveType? value) {
            setState(() {
              _selectedSaveType = value!;
            });
          },
        ),
        Text(saveType == SaveType.RGB ? 'RGB' : 'HEX'),
      ],
    );
  }

  @override
  void dispose() {
    _colorNameController.dispose();
    super.dispose();
  }

  void _saveColor() {
    String colorName = _colorNameController.text;
    if (colorName.isNotEmpty) {
      widget.onSave(_selectedSaveType, colorName);
      Navigator.of(context).pop();
      _colorNameController.clear();
    }
  }
}
