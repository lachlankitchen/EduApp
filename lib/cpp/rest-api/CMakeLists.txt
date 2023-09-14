cmake_minimum_required(VERSION 3.9)
project(RestAPI)

set(CMAKE_CXX_STANDARD 20)  # Set to the desired C++ standard version (e.g., 11, 14, 17, 20)

set (CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(cpprestsdk REQUIRED)

add_executable(rest_api main.cpp)

target_link_libraries(rest_api PRIVATE cpprestsdk::cpprest)
