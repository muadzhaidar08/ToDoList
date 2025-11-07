import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Skill {
  final String name;
  final String iconName; 

  Skill({required this.name, required this.iconName});

  IconData get iconData {
    switch (iconName.toLowerCase()) {
      case 'flutter': return FontAwesomeIcons.flutter;
      case 'dart': return FontAwesomeIcons.dartLang;
      case 'firebase': return FontAwesomeIcons.fire;
      case 'github': return FontAwesomeIcons.github;
      case 'figma': return FontAwesomeIcons.figma;
      case 'supabase': return FontAwesomeIcons.database;
      default: return Icons.code; 
    }
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] ?? 'Skill Tidak Diketahui',
      iconName: json['icon_name'] ?? 'code', 
    );
  }
}