// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

enum SaveType {
  RGB,
  HEX,
}

class SavedColor {
  int? id;
  final String name;
  final Color color;
  final String hex;
  final bool isSavedInRGB;

  SavedColor({
    this.id,
    required this.name,
    required this.color,
    required this.hex,
    required this.isSavedInRGB,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color.value,
      'hex': hex,
      'isSavedInRGB': isSavedInRGB ? 1 : 0,
    };
  }

  factory SavedColor.fromMap(Map<String, dynamic> map) {
    return SavedColor(
      id: map['id'] as int,
      name: map['name'] as String,
      color: Color(map['color'] as int),
      hex: map['hex'] as String,
      isSavedInRGB: map['isSavedInRGB'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedColor.fromJson(String source) =>
      SavedColor.fromMap(json.decode(source) as Map<String, dynamic>);
}
