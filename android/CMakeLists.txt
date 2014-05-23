#android build
# copied/inspired from stellarium project (http://www.stellarium.org/wiki/index.php/Building_for_Android)

file(GLOB SRC_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "src/*/*/*/*")

find_program(ANDROID_LOCATION NAMES android android.bat)
find_program(ANT_LOCATION NAMES ant)

# Look for ant and android programs
if (NOT ANT_LOCATION)
  message(FATAL_ERROR "Could not find ant. Please install ant and add it to the search path.")
endif(NOT ANT_LOCATION)
if (NOT ANDROID_LOCATION)
  message(FATAL_ERROR "Could not find 'Android SDK and AVD Manager'. Please install the android sdk and add the <android-sdk>/tools directory to the search path.")
endif(NOT ANDROID_LOCATION)

# Set version
set(ANDROID_VERSION_NAME ${GCOMPRIS_VERSION})
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/AndroidManifest.xml.cmake ${CMAKE_CURRENT_BINARY_DIR}/AndroidManifest.xml @ONLY)

### androiddeployqt modified version

# Find qmake version 5
find_program(QT_QMAKE_EXECUTABLE NAMES qmake-qt5 qmake)

# create json file parsed by the androiddeployqt
set(ANDROID_SDK $ENV{ANDROID_SDK})
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/configAndroid.json.cmake ${CMAKE_CURRENT_BINARY_DIR}/configAndroid.json @ONLY)

add_custom_command (
  OUTPUT createApkFromAndroidDeployQt
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
  COMMAND ${QT_QMAKE_EXECUTABLE} && make && ./androiddeployqt --output ${CMAKE_CURRENT_BINARY_DIR}/ --input ${CMAKE_CURRENT_BINARY_DIR}/configAndroid.json
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/tools/copyQtAndroidData
)

# Command to create apk from Makefile
add_custom_target ( apk_debug
   COMMAND ${ANT_LOCATION} debug
   DEPENDS createApkFromAndroidDeployQt
)

# Command to create apk from Makefile
add_custom_target ( apk_release
   COMMAND ${ANT_LOCATION} release
   DEPENDS createApkFromAndroidDeployQt
)
