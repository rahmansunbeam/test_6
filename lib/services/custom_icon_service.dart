import 'package:flutter/widgets.dart';

class CustomIcon {
  CustomIcon._();

  static const _kFontFam = 'Custom Icon';
  static const _kFontPkg = null;

  static const IconData info =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sunny =
      IconData(0xf185, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData moon =
      IconData(0xf186, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
