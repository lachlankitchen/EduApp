# Execute the resulting REST API application in the background
cd lib/cpp/rest-api/build/Debug

./rest_api.exe &
echo "Started the REST API application in the background."

# Return to the root directory of the project
cd ../../../../../
echo "Returned to the root directory of the project."

# Run "flutter pub get" in the background
flutter pub get &
echo "Running 'flutter pub get' in the background."

# Run "flutter run" in the background
flutter run -d windows &
echo "Running 'flutter run' in the background."
