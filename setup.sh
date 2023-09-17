# Change Directory to the "rest-api" source code directory
cd lib/cpp/rest-api
echo "Changed directory to rest-api source code."

# Remove the "build" directory if it exists
rm -r build
echo "Removed the existing 'build' directory."

# Create a "build" directory to contain the build artifacts
mkdir build
echo "Created a new 'build' directory."

# Change Directory to the newly created "build" directory
cd build
echo "Changed directory to 'build'."

# Run CMake to generate build files based on the project's CMakeLists.txt
cmake -G "MinGW Makefiles" ..
echo "Generated build files with CMake."

# Compile the project using the generated build files and Makefile
make &
echo "Compiled the project."

# Execute the resulting REST API application in the background
./rest_api #&
echo "Started the REST API application in the background."

# Return to the root directory of the project
cd ../../../../
echo "Returned to the root directory of the project."

# Run "flutter pub get" in the background
flutter pub get &
echo "Running 'flutter pub get' in the background."

# Run "flutter run" in the background
flutter run -d windows &
echo "Running 'flutter run' in the background."
