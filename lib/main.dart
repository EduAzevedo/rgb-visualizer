import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rgb_visualizer/src/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme()),
  ));
}
