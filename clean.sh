# flutter clean
flutter clean
flutter pub get

# pod deintegrate
cd ios
pod deintegrate
rm -rf Pods
rm -rf Podfile.lock

# pod cache clean
pod cache clean --all

# pod install
pod install --repo-update
cd ..