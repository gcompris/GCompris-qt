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

# _HOST have been removed from ECM in https://cgit.kde.org/extra-cmake-modules.git/commit/?id=731ba7036effcc430f98031e7f2a9826f6234cba
set(_HOST "${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}")
string(TOLOWER "${_HOST}" _HOST)

if(WITH_DEMO_ONLY)
  set(APK_SUFFIX "-demo${APK_SUFFIX}")
endif(WITH_DEMO_ONLY)

if(WITH_DOWNLOAD)
  set(APK_SUFFIX "-dl${APK_SUFFIX}")
endif(WITH_DOWNLOAD)

if(WITH_KIOSK_MODE)
  set(APK_SUFFIX "-kiosk${APK_SUFFIX}")
endif(WITH_KIOSK_MODE)

# specific clang addition
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set(STDCPP_PATH ",\"stdcpp-path\": \"${ANDROID_NDK}/sources/cxx-stl/llvm-libc++/libs/${ANDROID_ABI}/libc++_shared.so\"")
  set(REMOVE_mandroid_FLAG_FOR_CLANG "sed -i -e 's/-mandroid//' Configure")
endif()

set(ANDROID_TOOLCHAIN arm-linux-androideabi)
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
   DEPENDS ${ALL_LOCALES} move_translations_to_assets package_openssl createApkFromAndroidDeployQtDebug java_src
)

# Command to create apk from Makefile
add_custom_target (apk_release
   DEPENDS ${ALL_LOCALES} move_translations_to_assets package_openssl createApkFromAndroidDeployQtRelease java_src
)

# Command to create signed apk from Makefile
add_custom_target (apk_signed
   DEPENDS ${ALL_LOCALES} move_translations_to_assets package_openssl createApkSignedFromAndroidDeployQtRelease java_src
)

# Command to create signed aligned apk from Makefile
add_custom_target (apk_signed_aligned
   DEPENDS ${ALL_LOCALES} move_translations_to_assets package_openssl createApkSignedAlignedFromAndroidDeployQtRelease java_src
)

# Command to install the signed aligned apk through adb from Makefile
add_custom_target (apk_install
   DEPENDS apkInstall
)

# compile openssl needed to download from https
include(ExternalProject)
set(OPENSSL_DIR "${CMAKE_BINARY_DIR}/external/openssl/")
configure_file("build_openssl.sh.in" "build_openssl.sh" @ONLY)

ExternalProject_Add(
  ext_openssl
  DOWNLOAD_DIR ${CMAKE_BINARY_DIR}
  SOURCE_DIR ${OPENSSL_DIR}
  URL https://www.openssl.org/source/openssl-1.0.2q.tar.gz
  URL_HASH SHA256=5744cfcbcec2b1b48629f7354203bc1e5e9b5466998bbccc5b5fcde3b18eb684
  CONFIGURE_COMMAND echo "Configuration not needed"
  BUILD_COMMAND sh "${CMAKE_CURRENT_BINARY_DIR}/build_openssl.sh" <SOURCE_DIR>
  INSTALL_COMMAND ""
  )

add_custom_command( 
  OUTPUT package_openssl
  COMMAND ${CMAKE_COMMAND} -E copy "${OPENSSL_DIR}/libcrypto.so.1.0.0" "${CMAKE_BINARY_DIR}/android/libs/${ANDROID_ABI}/libcrypto.so"
  COMMAND ${CMAKE_COMMAND} -E copy "${OPENSSL_DIR}/libssl.so.1.0.0" "${CMAKE_BINARY_DIR}/android/libs/${ANDROID_ABI}/libssl.so"
  )

#
add_custom_command(
  OUTPUT move_translations_to_assets
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${GCOMPRIS_TRANSLATIONS_DIR} ${CMAKE_BINARY_DIR}/android/assets/share/GCompris
  )

if (TARGET create-apk)
   set(PACKAGE_DIR ${PACKAGE_SOURCE_ANDROID})
   set_target_properties(create-apk-GCompris PROPERTIES ANDROID_APK_DIR "${PACKAGE_DIR}")
   add_custom_target(gcompris-move-metadata ALL
      COMMAND cmake -E echo "Moving GCompris shared Android resources"
      COMMAND cmake -E make_directory ${PACKAGE_SOURCE_ANDROID}
      COMMAND cmake -E copy_directory "${CMAKE_CURRENT_SOURCE_DIR}" "${PACKAGE_SOURCE_ANDROID}"
   )
   add_dependencies(create-apk gcompris-move-metadata)
endif()
