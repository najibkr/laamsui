// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() {
  try {
    final files = Directory('./tools/icons/glyphs').listSync();
    var buffer = StringBuffer();
    buffer.write('// ignore_for_file: constant_identifier_names\n\n');
    buffer.write("import 'package:flutter/widgets.dart';\n\n");
    buffer.write('''
/// You can use [LaamsIcons] using the following examples
/// in your flutter project:
/// ```dart
///  final icon = Icon(LaamsIcons.star_outline, size:20, color: Colors.blue);
/// ```
''');
    buffer.write('class LaamsIcons {\n');

    for (var file in files) {
      var iconsName = file.path.split('/').last.split('.').first;
      print('Generationg $iconsName');
      final content = File(file.path).readAsStringSync();
      final iconsMap = Map<String, int>.from(jsonDecode(content));
      var newIcons = StringBuffer();

      final suffix = switch (iconsName) {
        'Ionicons' => '',
        'MaterialCommunityIcons' => '1',
        // 'AntDesign' => '2',
        // 'Entypo' => '2',
        // 'Feather' => '3',
        // 'Fontisto' => '4',
        // 'Foundation' => '5',
        // 'Octicons' => '7',
        // 'SimpleLineIcons' => '8',
        // 'Zocial' => '9',
        _ => '',
      };

      iconsMap.forEach((key, value) {
        if (key.startsWith(RegExp(r'[0-9]'))) key = 'n$key';
        newIcons.write('''
          /// $iconsName $key
          static const ${key.replaceAll("-", "_")}$suffix = IconData(
            $value,
            fontFamily: '$iconsName',
            fontPackage: 'laamsui',
            // matchTextDirection: true,
          );
''');
      });

      buffer.write(newIcons.toString());

      // print(iconsMap);
    }

    buffer.write('}');
    const path = './lib/src/laams_icons.dart';
    var iconsFile = File(path);

    if (iconsFile.existsSync()) {
      iconsFile.writeAsStringSync(buffer.toString());
    } else {
      iconsFile.createSync();
      iconsFile.writeAsStringSync(buffer.toString());
    }

    print('---------------------------------------');
    print('Successfully generated all the icons');
    print('---------------------------------------');
  } catch (e) {
    print('Error generating icons $e');
  }
}
