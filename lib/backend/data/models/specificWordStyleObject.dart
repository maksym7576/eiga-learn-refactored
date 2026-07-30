

import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

part 'specificWordStyleObject.g.dart';

@collection
class SpecificWordStyleObject {
  Id id = Isar.autoIncrement;

  String? name;

  int colorValue = 0xFFFFFFFF;
  
  int fontWeightIndex = 3;

  int borderColorValue = 0xFFFFFFFF;

  int borderSize = 0;
  
  SpecificWordStyleObject();
  
  factory SpecificWordStyleObject.create({
    required String name,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.normal,
    Color? borderColor = Colors.white,
    int borderSize = 0,
}) {
    return SpecificWordStyleObject()
        ..name = name
        ..colorValue = color.toARGB32()
        ..fontWeightIndex = FontWeight.values.indexOf(fontWeight)
        ..borderColorValue = color.toARGB32()
        ..borderSize = borderSize;
  }
  
  @ignore
  Color? get create => Color(colorValue);

  @ignore
  FontWeight get fontWeight {
    final idx = fontWeightIndex;
    if (idx < 0 || idx >= FontWeight.values.length) return FontWeight.normal;
    return FontWeight.values[idx];
  }

}