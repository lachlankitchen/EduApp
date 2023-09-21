# cmake -DCMAKE_TOOLCHAIN_FILE=C:/Users/AHopgood/dev/vcpkg/scripts/buildsystems/vcpkg.cmake ..
# msbuild rest_api.vcxproj //IN SPECIAL VS 2022 CMD CMD PROMPT 
cmake_minimum_required(VERSION 3.9)
project(RestAPI)

set(CMAKE_CXX_STANDARD 17)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

# Specify the path to ZLIB library and include directory
#set(ZLIB_LIBRARY "C:/zlib/zlib-1.3/zlib.a")
#set(ZLIB_INCLUDE_DIR "C:/zlib/zlib-1.3")

# Include the ZLIB headers
include_directories(${ZLIB_INCLUDE_DIR})

# Specify the location of cpprestsdk (assuming you already have it installed)0
find_package(cpprestsdk CONFIG REQUIRED)

# Define the target name as "rest_api" (with an underscore)
add_executable(rest_api main.cpp)

# Link with the libraries (no need to specify the internal libraries)
target_link_libraries(rest_api PRIVATE cpprestsdk::cpprest)

# Include the nlohmann/json headers (no need to specify target_link_libraries for nlohmann_json)
find_package(nlohmann_json CONFIG REQUIRED)
target_link_libraries(rest_api PRIVATE nlohmann_json::nlohmann_json)

