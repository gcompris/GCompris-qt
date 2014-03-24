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

add_custom_command (
      OUTPUT build.xml
      DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/AndroidManifest.xml
      COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
      COMMAND ${ANDROID_LOCATION}/android update project -t android-${ANDROID_API_LEVEL} --name GCompris -p ${CMAKE_CURRENT_BINARY_DIR}
)

# Command to create apk from Makefile
add_custom_target ( apk_debug
   COMMAND ${ANT_LOCATION} debug
   DEPENDS build.xml
)

# Command to create apk from Makefile
add_custom_target ( apk_release
   COMMAND ${ANT_LOCATION} release
   DEPENDS build.xml
)
