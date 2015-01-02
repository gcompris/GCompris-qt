#android build
# copied/inspired from stellarium project (http://www.stellarium.org/wiki/index.php/Building_for_Android)

LIST(APPEND JAVA_SRCS "src/com/android/vending/billing/IInAppBillingService.aidl" "src/net/gcompris/GComprisActivity.java")

FOREACH(JavaSource ${JAVA_SRCS})
  ADD_CUSTOM_COMMAND(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${JavaSource}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${JavaSource} ${CMAKE_CURRENT_BINARY_DIR}/${JavaSource}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${JavaSource}
    )
  LIST(APPEND TARGET_JAVA_FILES ${CMAKE_CURRENT_BINARY_DIR}/${JavaSource})
ENDFOREACH()

ADD_CUSTOM_TARGET (java_src DEPENDS ${TARGET_JAVA_FILES})

find_program(ANDROID_DEPLOY_QT NAMES androiddeployqt PATHS ${_qt5Core_install_prefix}/bin/ )

# Look for androiddeployqt program
if (NOT ANDROID_DEPLOY_QT)
  message(FATAL_ERROR "Could not find androiddeployqt. Make sure you set all the Qt5_* paths to the Qt for android compiled version.")
endif(NOT ANDROID_DEPLOY_QT)

# Set version
set(ANDROID_VERSION_NAME ${GCOMPRIS_VERSION})

# set android package source for androiddeployqt json file
set(PACKAGE_SOURCE_ANDROID ${CMAKE_BINARY_DIR}/tmpAndroid)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/AndroidManifest.xml.cmake ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml @ONLY)

# create json file parsed by the androiddeployqt
set(ANDROID_SDK $ENV{ANDROID_SDK})
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/configAndroid.json.cmake ${PACKAGE_SOURCE_ANDROID}/configAndroid.json @ONLY)

add_custom_command (
  OUTPUT createApkFromAndroidDeployQtDebug
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_CURRENT_BINARY_DIR}/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --debug
  COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_CURRENT_BINARY_DIR}/bin/QtApp-debug.apk ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-debug-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
)

add_custom_command (
  OUTPUT createApkFromAndroidDeployQtRelease
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_CURRENT_BINARY_DIR}/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --release
  COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_CURRENT_BINARY_DIR}/bin/QtApp-release-unsigned.apk ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
)

add_custom_command (
  OUTPUT createApkSignedFromAndroidDeployQtRelease
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
  COMMAND jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $ENV{ANDROID_KEYSTORE} -storepass $ENV{ANDROID_KEYSTORE_PASSWD} ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk gcompris
)

add_custom_command (
  OUTPUT createApkSignedAlignedFromAndroidDeployQtRelease
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
  COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-aligned-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
  COMMAND ${ANDROID_SDK}/build-tools/20.0.0/zipalign -v 4 ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-aligned-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
)

add_custom_command (
  OUTPUT apkInstall
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-aligned-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
  COMMAND ${ANDROID_SDK}/platform-tools/adb install -r ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-aligned-${ANDROID_ABI}-${GCOMPRIS_VERSION}.apk
)

# Command to create apk from Makefile
add_custom_target (apk_debug
   DEPENDS createApkFromAndroidDeployQtDebug java_src
)

# Command to create apk from Makefile
add_custom_target (apk_release
   DEPENDS createApkFromAndroidDeployQtRelease java_src
)

# Command to create signed apk from Makefile
add_custom_target (apk_signed
   DEPENDS createApkSignedFromAndroidDeployQtRelease java_src
)

# Command to create signed aligned apk from Makefile
add_custom_target (apk_signed_aligned
   DEPENDS createApkSignedAlignedFromAndroidDeployQtRelease java_src
)

# Command to install the signed aligned apk through adb from Makefile
add_custom_target (apk_install
   DEPENDS apkInstall
)
