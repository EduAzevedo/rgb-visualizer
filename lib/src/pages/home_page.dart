// Importando os pacotes necessários
// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rgb_visualizer/src/forms/save_dialog.dart';
import 'package:rgb_visualizer/src/models/saved_color.dart';
import 'package:rgb_visualizer/src/services/db_helper.dart';
import 'package:rgb_visualizer/src/widgets/saved_color_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Color _currentColor;
  List<SavedColor> savedColors = [];

  TextEditingController _redController = TextEditingController();
  TextEditingController _greenController = TextEditingController();
  TextEditingController _blueController = TextEditingController();
  TextEditingController _hexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _currentColor = _getColorFromControllers();
    _loadSavedColors();
  }

  @override
  void dispose() {
    _redController.dispose();
    _greenController.dispose();
    _blueController.dispose();
    _hexController.dispose();
    super.dispose();
  }

  Color _getColorFromControllers() {
    return Color.fromRGBO(
      int.tryParse(_redController.text) ?? 0,
      int.tryParse(_greenController.text) ?? 0,
      int.tryParse(_blueController.text) ?? 0,
      1.0,
    );
  }

  Future<void> _loadSavedColors() async {
    try {
      List<SavedColor> colors = await DatabaseHelper().getSavedColors();
      setState(() {
        savedColors = colors;
      });
    // ignore: empty_catches
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "RGB Visualizer",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const Divider(),
                SizedBox(
                  width: 600,
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    color: _currentColor,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Container();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Insira os valores",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(80, "R", _redController),
                    const SizedBox(width: 10),
                    _buildTextField(80, "G", _greenController),
                    const SizedBox(width: 10),
                    _buildTextField(80, "B", _blueController),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "ou",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: _hexController,
                    onChanged: (_) {
                      _clearRGBFields();
                      _updateColorFromHex();
                    },
                    decoration: const InputDecoration(
                      labelText: "Código HEX",
                      hintStyle: TextStyle(
                        color: Colors.black45,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle:
                          TextStyle(color: Colors.black38, fontSize: 18),
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
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _showSaveDialog(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: const Text(
                      "SALVAR",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                if (savedColors.isNotEmpty)
                  const Text(
                    "SALVOS",
                    style: TextStyle(color: Colors.black),
                  ),
                SizedBox(
                  width: 600,
                  height: 250,
                  child: ListView.builder(
                    itemCount: savedColors.length,
                    itemBuilder: (context, index) {
                      final savedColor = savedColors[index];
                      return SavedColorCard(
                        savedColor: savedColor,
                        removeFromList: _removeFromList,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        floatingActionButton: savedColors.isNotEmpty
            ? FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: _clearSavedColors,
                child:
                    const Icon(Ionicons.trash_bin_outline, color: Colors.white))
            : null);
  }

  Widget _buildTextField(
      double width, String label, TextEditingController controller) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (_) {
          _updateColor();
          _hexController.clear();
        },
        decoration: InputDecoration(
          labelText: label,
          hintStyle: const TextStyle(
            color: Colors.black45,
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black38, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black26),
          ),
        ),
      ),
    );
  }

  void _updateColor() {
    _animationController.reset();
    _animationController.forward();
    setState(() {
      _currentColor = _getColorFromControllers();
    });
  }

  void _updateColorFromHex() {
    String hexColor = _hexController.text.replaceAll("#", "");

    if (hexColor.length == 6) {
      Color color = HexColor("#$hexColor");
      _animationController.reset();
      _animationController.forward();
      setState(() {
        _redController.text = color.red.toString();
        _greenController.text = color.green.toString();
        _blueController.text = color.blue.toString();
        _currentColor = _getColorFromControllers();
      });
    }
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 5,
          child: SizedBox(
            width: 600,
            height: 380,
            child: SaveDialog(onSave: _saveColor),
          ),
        );
      },
    );
  }

  void _clearRGBFields() {
    _redController.clear();
    _greenController.clear();
    _blueController.clear();
  }

  void _saveColor(SaveType saveType, String colorName) async {
    String hexColor = '#${_currentColor.value.toRadixString(16).substring(2)}';

    SavedColor newSavedColor = SaveType.RGB == saveType
        ? SavedColor(
            name: colorName,
            color: _currentColor,
            hex: hexColor,
            isSavedInRGB: true,
          )
        : SavedColor(
            name: colorName,
            color: HexColor(hexColor),
            hex: hexColor,
            isSavedInRGB: false,
          );

    await DatabaseHelper().insertSavedColor(newSavedColor);
    _loadSavedColors();
  }

  void _removeFromList(SavedColor color) async {
    await DatabaseHelper().deleteSavedColor(color.id!);
    _loadSavedColors();
  }

  void _clearSavedColors() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: const Text(
              "Tem certeza de que deseja excluir todas as cores salvas?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().deleteAllSavedColors();
                setState(() {
                  savedColors.clear();
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text(
                "Confirmar",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
