cmake_minimum_required(VERSION 2.8.12)

project(gcompris C CXX)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${my_cxx_flags}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${my_cxx_flags}")

set(GCOMPRIS_MAJOR_VERSION 0)
set(GCOMPRIS_MINOR_VERSION 5)
set(GCOMPRIS_PATCH_VERSION 0)

set(GCOMPRIS_VERSION ${GCOMPRIS_MAJOR_VERSION}.${GCOMPRIS_MINOR_VERSION}.${GCOMPRIS_PATCH_VERSION})

# cmake modules setup
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/")

# Compile 3rd party
#add_subdirectory(3rdparty)
#find_package(ECM 0.0.11 REQUIRED NO_MODULE)
find_package(KConfig REQUIRED)

set(QT_REQUIRED_VERSION 5.2.0)

find_package(Qt5 ${QT_REQUIRED_VERSION} CONFIG REQUIRED Qml Quick Gui Multimedia Core Svg XmlPatterns)

#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
#    message("${_variableName}=${${_variableName}}")
#endforeach()

# To have src/core/*{.qml/.js} files and activities.txt in qtcreator project
file(GLOB gcompris_SRCS src/core/*.qml src/core/*.js src/activities/activities.txt)
set(gcompris_SRCS ${QML_SRC} ${gcompris_SRCS})

# Set output directory
if(ANDROID)
# Android .so output
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/android/libs/${ARM_TARGET}/)
add_subdirectory(android)
else(ANDROID)
# Desktop build
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
endif(ANDROID)

add_subdirectory(src)

