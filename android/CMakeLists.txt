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

# Set a name representing the build type
set(APK_SUFFIX "-")
if(ACTIVATION_MODE STREQUAL "inapp")
  set(APK_SUFFIX "-inapp${APK_SUFFIX}")
elseif(ACTIVATION_MODE STREQUAL "internal")
  set(APK_SUFFIX "-internal${APK_SUFFIX}")
endif(ACTIVATION_MODE STREQUAL "inapp")

if(WITH_DEMO_ONLY)
  set(APK_SUFFIX "-demo${APK_SUFFIX}")
endif(WITH_DEMO_ONLY)

if(WITH_DOWNLOAD)
  set(APK_SUFFIX "-dl${APK_SUFFIX}")
endif(WITH_DOWNLOAD)

if(WITH_KIOSK_MODE)
  set(APK_SUFFIX "-kiosk${APK_SUFFIX}")
endif(WITH_KIOSK_MODE)

# set android package source for androiddeployqt json file
set(PACKAGE_SOURCE_ANDROID ${CMAKE_BINARY_DIR}/tmpAndroid)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/AndroidManifest.xml.cmake ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml @ONLY)

# create json file parsed by the androiddeployqt
set(ANDROID_SDK_ROOT $ENV{ANDROID_SDK_ROOT})
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/configAndroid.json.cmake ${PACKAGE_SOURCE_ANDROID}/configAndroid.json @ONLY)

# Get all po files in po/ to create the values-{locale} in order to have the locales available in android
file(GLOB TRANSLATIONS_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "../po/*.po")
foreach(PoSource ${TRANSLATIONS_FILES})
  # Remove suffix ".po"
  string(REPLACE ".po" "" PoSource ${PoSource})
  # Remove prefix "../po/gcompris_"
  string(REPLACE "../po/gcompris_" "" locale ${PoSource})
  # replace _ par -r for locales with country
  string(REPLACE "_" "-r" locale ${locale})

  add_custom_command(
    OUTPUT ${locale}
    COMMAND cmake -E make_directory ${GCOMPRIS_TRANSLATIONS_DIR}
    COMMAND cmake -E make_directory ${CMAKE_BINARY_DIR}/android/res/values-${locale}
    COMMAND cmake -E copy ${CMAKE_SOURCE_DIR}/android/strings.xml ${CMAKE_BINARY_DIR}/android/res/values-${locale}/strings.xml
    )
  list(APPEND ALL_LOCALES ${locale})
endforeach()

add_custom_command (
  OUTPUT createApkFromAndroidDeployQtDebug
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_CURRENT_BINARY_DIR}/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --debug
  COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_CURRENT_BINARY_DIR}/bin/QtApp-debug.apk ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-debug-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command (
  OUTPUT createApkFromAndroidDeployQtRelease
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_CURRENT_BINARY_DIR}/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --release
  COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_CURRENT_BINARY_DIR}/bin/QtApp-release-unsigned.apk ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command (
  OUTPUT createApkSignedFromAndroidDeployQtRelease
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
  COMMAND jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $ENV{ANDROID_KEYSTORE} -storepass $ENV{ANDROID_KEYSTORE_PASSWD} ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk gcompris
)

add_custom_command (
  OUTPUT createApkSignedAlignedFromAndroidDeployQtRelease
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
  COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-aligned-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
  COMMAND ${ANDROID_SDK_ROOT}/build-tools/21.1.2/zipalign -v 4 ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-aligned-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command (
  OUTPUT apkInstall
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-aligned-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
  COMMAND ${ANDROID_SDK_ROOT}/platform-tools/adb install -r ${CMAKE_CURRENT_BINARY_DIR}/bin/GCompris-Android-release-signed-aligned-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

# Command to create apk from Makefile
add_custom_target (apk_debug
   DEPENDS ${ALL_LOCALES} createApkFromAndroidDeployQtDebug java_src
)

# Command to create apk from Makefile
add_custom_target (apk_release
   DEPENDS ${ALL_LOCALES} createApkFromAndroidDeployQtRelease java_src
)

# Command to create signed apk from Makefile
add_custom_target (apk_signed
   DEPENDS ${ALL_LOCALES} createApkSignedFromAndroidDeployQtRelease java_src
)

# Command to create signed aligned apk from Makefile
add_custom_target (apk_signed_aligned
   DEPENDS ${ALL_LOCALES} createApkSignedAlignedFromAndroidDeployQtRelease java_src
)

# Command to install the signed aligned apk through adb from Makefile
add_custom_target (apk_install
   DEPENDS apkInstall
)
