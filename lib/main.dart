import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sos_project_mobile/screens/android/sosapp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Força os ícones da barra de status a ficarem escuros (pretos)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Barra transparente
      statusBarIconBrightness: Brightness.dark, // Ícones pretos (Android)
      statusBarBrightness: Brightness.light, // Ícones pretos (iOS)
    ),
  );

  if (Platform.isAndroid) {
    debugPrint('App no android');
  }
  if (Platform.isIOS) {
    debugPrint('App no IOS');
  }
  runApp(SOSApp());
}
