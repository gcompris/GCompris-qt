cmake_minimum_required(VERSION 2.8)

project(gcompris C CXX)

# Set c++11 support
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
        set(my_cxx_flags "-std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
        set(my_cxx_flags "-std=c++0x")
else()
        message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${my_cxx_flags}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${my_cxx_flags}")

set(GCOMPRIS_MAJOR_VERSION 0)
set(GCOMPRIS_MINOR_VERSION 30)
set(GCOMPRIS_PATCH_VERSION 0)

set(GCOMPRIS_VERSION ${GCOMPRIS_MAJOR_VERSION}.${GCOMPRIS_MINOR_VERSION})

# An integer value that represents the version of the application
# Increase it at each release
set(GCOMPRIS_VERSION_CODE ${GCOMPRIS_MINOR_VERSION})

# Set executable filename
if(ANDROID)
  set(GCOMPRIS_EXECUTABLE_NAME GCompris)
else()
  set(GCOMPRIS_EXECUTABLE_NAME gcompris-qt)
endif()

# cmake modules setup
find_package(ECM 1.4.0 QUIET NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR} ${CMAKE_SOURCE_DIR}/cmake/)
set(CMAKE_PREFIX_PATH "${Qt5_DIR}/lib/cmake/Qt5")

# KDE po to qm tools
if(ECM_FOUND)
  include(ECMPoQmTools)
  if (IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/po")
    ecm_install_po_files_as_qm(po)
  endif()
endif(ECM_FOUND)

# prevent build in source directory
if("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
    message(SEND_ERROR "Building in the source directory is not supported.")
    message(FATAL_ERROR "Please remove the created \"CMakeCache.txt\" file, the \"CMakeFiles\"
            directory and create a build directory and call \"${CMAKE_COMMAND} <path to the sources>\".")
endif("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")

set(QT_REQUIRED_VERSION 5.3.0)

find_package(Qt5 ${QT_REQUIRED_VERSION} REQUIRED
            Qml Quick Gui Multimedia Core Svg Xml XmlPatterns LinguistTools)

#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
#    message("${_variableName}=${${_variableName}}")
#endforeach()

option(WITH_ACTIVATION_CODE "Include the activation system" OFF)
option(WITH_DEMO_ONLY "Include only demo activities" OFF)

# Set output directory
if(CMAKE_HOST_APPLE)
  set(_bundle_bin gcompris-qt.app/Contents/MacOS)
  set(_data_dest_dir bin/${_bundle_bin})
elseif(ANDROID)
  set(_data_dest_dir android/assets)
else()
  set(_data_dest_dir share/gcompris-qt)
endif()
if(ANDROID)
  # Android .so output
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/android/libs/${ARM_TARGET}/)
  set(GCOMPRIS_TRANSLATIONS_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir} CACHE INTERNAL "" FORCE)
  set(GCOMPRIS_RCC_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir} CACHE INTERNAL "" FORCE)
  if(WITH_ACTIVATION_CODE)
    set(ANDROID_BILLING_PERMISSION '<uses-permission android:name="com.android.vending.BILLING"/>')
    set(ANDROID_PACKAGE "net.gcompris")
  else(WITH_ACTIVATION_CODE)
    set(ANDROID_PACKAGE "net.gcompris.full")
  endif()
  add_subdirectory(android)
else(ANDROID)
  # Desktop build
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(GCOMPRIS_TRANSLATIONS_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir}/translations CACHE INTERNAL "" FORCE)
  set(GCOMPRIS_RCC_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir}/rcc CACHE INTERNAL "" FORCE)
endif(ANDROID)

# Always create these folders
add_custom_command(
  OUTPUT shareFolders
  COMMAND cmake -E make_directory ${GCOMPRIS_TRANSLATIONS_DIR}
  COMMAND cmake -E make_directory ${GCOMPRIS_RCC_DIR}
  )
add_custom_target(
  createShareFolders ALL
  DEPENDS shareFolders
  )

include(cmake/rcc.cmake)

# Translations handling

# Simple command calling the python script
  add_custom_command(
    OUTPUT retrievePoFilesFromSvn
    COMMAND python2 tools/l10n-fetch-po-files.py
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
# Install translations
add_custom_target(getSvnTranslations
  DEPENDS retrievePoFilesFromSvn
  COMMENT "Re-run cmake after this to be able to run BuildTranslations with the latest files"
  )

# Get all po files in po/. You can get them doing : python2 tools/l10n-fetch-po-files.py
file(GLOB TRANSLATIONS_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "po/*.po")
# Set the output dir for the translation files to /bin
foreach(PoSource ${TRANSLATIONS_FILES})
  # Changes the .po extension to .ts
  string(REPLACE ".po" ".ts" TsSource ${PoSource})
  # Removes the po/ folder
  string(REPLACE "po/" "" TsSource ${TsSource})
  # qm filename
  string(REPLACE ".ts" ".qm" QmOutput ${TsSource})

  set(OutTsFile ${CMAKE_BINARY_DIR}/tmp/${TsSource})
  add_custom_command(
    OUTPUT ${QmOutput}
    COMMAND cmake -E make_directory ${GCOMPRIS_TRANSLATIONS_DIR}
    COMMAND cmake -E make_directory ${CMAKE_BINARY_DIR}/tmp
    # Remove the obsolete translations and set po in the ts output file
    COMMAND msgattrib --no-obsolete  ${CMAKE_CURRENT_SOURCE_DIR}/${PoSource} -o ${OutTsFile}
    # Convert the po into ts
    COMMAND lconvert -if po -of ts -i ${OutTsFile} -o ${OutTsFile}
    # Convert the ts in qm removing non finished translations
    COMMAND lrelease -compress -nounfinished ${OutTsFile} -qm ${GCOMPRIS_TRANSLATIONS_DIR}/${QmOutput}
    )
  list(APPEND QM_FILES ${QmOutput})
endforeach()

# Install translations
add_custom_target(BuildTranslations
  DEPENDS ${QM_FILES}
  COMMENT "If you don't have the .po, you need to run make getSvnTranslations first then re-run cmake"
  )

if(CMAKE_HOST_APPLE)
  install(DIRECTORY ${GCOMPRIS_TRANSLATIONS_DIR} DESTINATION ${_bundle_bin})
else()
  install(DIRECTORY ${GCOMPRIS_TRANSLATIONS_DIR} DESTINATION ${_data_dest_dir})
endif()

# Build standalone package option -> if ON, we will copy the required Qt files in the build package.
# If OFF, "make install" will not copy Qt files so only GCompris files will be packaged.
# By default, it is true on Windows (as we deliver NSIS package), macOS (bundled), android (apk) and false on linux (to do make install)
# If you want to create a STGZ package for linux (auto-extractible), override this variable by typing : cmake -DBUILD_STANDALONE=ON
if(UNIX AND NOT ANDROID)
  option(BUILD_STANDALONE "Build a standalone package when typing 'make package'" OFF)
else()
  option(BUILD_STANDALONE "Build a standalone package when typing 'make package'" ON)
endif()

option(WITH_KIOSK_MODE "Set the kiosk mode by default" OFF)

add_subdirectory(src)

