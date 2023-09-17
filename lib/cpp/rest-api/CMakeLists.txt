cmake_minimum_required(VERSION 3.9)
project(RestAPI)

set(CMAKE_CXX_STANDARD 20)

# Specify the path to ZLIB library and include directory
set(ZLIB_LIBRARY "C:/zlib/zlib-1.3/zlib.a")
set(ZLIB_INCLUDE_DIR "C:/zlib/zlib-1.3")

# Include the ZLIB headers
include_directories(${ZLIB_INCLUDE_DIR})

# Specify the location of cpprestsdk (assuming you already have it installed)
set(cpprestsdk_DIR "C:/Users/Owner/vcpkg/packages/cpprestsdk_x86-windows/share/cpprestsdk")
find_package(cpprestsdk REQUIRED)

# Use vcpkg to find nlohmann/json
set(CMAKE_TOOLCHAIN_FILE "C:/Users/Owner/vcpkg/scripts/buildsystems/vcpkg.cmake")

# Define the target name as "rest_api" (with an underscore)
add_executable(rest_api main.cpp)

# Link with the libraries
target_link_libraries(rest_api PRIVATE cpprestsdk::cpprest ${ZLIB_LIBRARY})

# Include the nlohmann/json headers (no need to specify target_link_libraries for nlohmann_json)
target_include_directories(rest_api PRIVATE "C:/Users/Owner/vcpkg/packages/nlohmann-json_x86-windows/include")
