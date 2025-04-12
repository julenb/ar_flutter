#!/bin/bash

echo "🧹 Limpiando proyecto Flutter..."
flutter clean

echo "📦 Recuperando paquetes..."
flutter pub get

echo "📁 Instalando dependencias de CocoaPods..."
cd ios
rm -rf Pods Podfile.lock .symlinks
pod install --repo-update
cd ..

echo "🚀 Ejecutando la app en iOS..."
flutter run
