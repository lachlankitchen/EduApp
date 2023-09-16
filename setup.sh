# Change Directory to the "rest-api" source code directory
cd lib/cpp/rest-api

# Create a "build" directory to contain the build artifacts
mkdir build

# Change Directory to the newly created "build" directory
cd build

# Run CMake to generate build files based on the project's CMakeLists.txt
cmake ..

# Compile the project using the generated build files and Makefile
make

# Execute the resulting REST API application in the background
./rest_api &

# Return to the root directory of the project
cd ../../../../

# Run "flutter pub get" in the background
flutter pub get &

# Run "flutter run" in the background
flutter run -d windows &