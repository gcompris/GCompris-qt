#=============================================================================
# SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
#android build
# copied/inspired from stellarium project (http://www.stellarium.org/wiki/index.php/Building_for_Android)

list(APPEND JAVA_SRCS "src/net/gcompris/GComprisActivity.java")

foreach(JavaSource ${JAVA_SRCS})
  add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/android-build/${JavaSource}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${JavaSource} ${CMAKE_BINARY_DIR}/android-build/${JavaSource}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${JavaSource}
    )
  list(APPEND TARGET_JAVA_FILES ${CMAKE_BINARY_DIR}/android-build/${JavaSource})
endforeach()

add_custom_target(java_src DEPENDS ${TARGET_JAVA_FILES})

find_program(ANDROID_DEPLOY_QT NAMES androiddeployqt PATHS ${_qt5Core_install_prefix}/bin/)

# Look for androiddeployqt program
if(NOT ANDROID_DEPLOY_QT)
  message(FATAL_ERROR "Could not find androiddeployqt. Make sure you set all the Qt5_* paths to the Qt for android compiled version.")
endif()

# Set version
set(ANDROID_VERSION_NAME ${GCOMPRIS_VERSION})

# Set a name representing the build type
set(APK_SUFFIX "-")

# _HOST have been removed from ECM in https://cgit.kde.org/extra-cmake-modules.git/commit/?id=731ba7036effcc430f98031e7f2a9826f6234cba
set(_HOST "${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}")
string(TOLOWER "${_HOST}" _HOST)

if(WITH_DOWNLOAD)
  set(APK_SUFFIX "-dl${APK_SUFFIX}")
endif()

if(WITH_KIOSK_MODE)
  set(APK_SUFFIX "-kiosk${APK_SUFFIX}")
endif()

if(Qt5Widgets_VERSION VERSION_GREATER_EQUAL "5.14.0")
  set(STDCPP_PATH "\"stdcpp-path\": \"${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/\"")
else()
  set(STDCPP_PATH ",\"stdcpp-path\": \"${ANDROID_NDK}/sources/cxx-stl/llvm-libc++/libs/${ANDROID_ABI}/libc++_shared.so\"")
endif()

set(ANDROID_TOOLCHAIN arm-linux-androideabi)
if("${CMAKE_ANDROID_ARCH}" STREQUAL "arm64")
  set(ANDROID_TOOLCHAIN aarch64-linux-android)
endif()

# set android package source for androiddeployqt json file
set(PACKAGE_SOURCE_ANDROID ${CMAKE_BINARY_DIR}/tmpAndroid)
set(ANDROID_SDK_ROOT $ENV{ANDROID_SDK_ROOT})

if(Qt5Widgets_VERSION VERSION_GREATER_EQUAL "5.14.0")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/AndroidManifest.xml.cmake ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml @ONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/configAndroid.json.cmake ${PACKAGE_SOURCE_ANDROID}/configAndroid.json @ONLY)
  # TODO Remove this file as soon as we have moved to plugins instead of rcc files for activities
  # This way, we'll use the one provided by Qt
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/build_5.14.gradle ${PACKAGE_SOURCE_ANDROID}/build.gradle @ONLY)
else()
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/AndroidManifest_5.12.xml.cmake ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml @ONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/configAndroid_5.12.json.cmake ${PACKAGE_SOURCE_ANDROID}/configAndroid.json @ONLY)
endif()

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
    COMMAND cmake -E make_directory ${CMAKE_BINARY_DIR}/android-build/res/values-${locale}
    COMMAND cmake -E copy ${CMAKE_SOURCE_DIR}/android/strings.xml ${CMAKE_BINARY_DIR}/android-build/res/values-${locale}/strings.xml
    )
  list(APPEND ALL_LOCALES ${locale})
endforeach()

add_custom_command(
  OUTPUT createApkFromAndroidDeployQtDebug
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_BINARY_DIR}/android-build/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --debug --gradle
  COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_BINARY_DIR}/android-build/build/outputs/apk/debug/android-build-debug.apk ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-debug-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command(
  OUTPUT createApkFromAndroidDeployQtRelease
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_BINARY_DIR}/android-build/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --release --gradle
  COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_BINARY_DIR}/android-build/build/outputs/apk/release/android-build-release-unsigned.apk ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-release-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command(
  OUTPUT createApkSignedAlignedFromAndroidDeployQtRelease
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_BINARY_DIR}/android-build/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --gradle --sign $ENV{ANDROID_KEYSTORE} gcompris --storepass $ENV{ANDROID_KEYSTORE_PASSWD}
    COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_BINARY_DIR}/android-build/build/outputs/apk/release/android-build-release-signed.apk ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-release-signed-aligned-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command(
  OUTPUT createAabFromAndroidDeploy
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_BINARY_DIR}/android-build/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --aab --release --gradle
  COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_BINARY_DIR}/android-build/build/outputs/bundle/release/android-build-release.aab ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-release${APK_SUFFIX}${GCOMPRIS_VERSION}.aab
  )

add_custom_command(
  OUTPUT apkInstall
  DEPENDS ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-release-signed-aligned-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
  COMMAND ${ANDROID_SDK_ROOT}/platform-tools/adb install -r ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-release-signed-aligned-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

# Command to create apk from Makefile
add_custom_target(apk_debug
  DEPENDS ${ALL_LOCALES} move_translations_to_assets createApkFromAndroidDeployQtDebug java_src
)

# Command to create apk from Makefile
add_custom_target(apk_release
  DEPENDS ${ALL_LOCALES} move_translations_to_assets createApkFromAndroidDeployQtRelease java_src
)

# Command to create aligned signed apk from Makefile
add_custom_target(apk_aligned_signed
  DEPENDS ${ALL_LOCALES} move_translations_to_assets createApkSignedAlignedFromAndroidDeployQtRelease java_src
)

# Command to create aab from Makefile
add_custom_target(aab_release
  DEPENDS ${ALL_LOCALES} move_translations_to_assets createAabFromAndroidDeploy java_src
)

# Command to install the signed aligned apk through adb from Makefile
add_custom_target(apk_install
  DEPENDS apkInstall
)

# compile openssl needed to download from https
include(ExternalProject)
set(OPENSSL_DIR "${CMAKE_BINARY_DIR}/external/openssl/")

# For Qt 5.12.5 and above 5.13.0, it needs libcrypto_1_1.so and libssl_1_1.so
set(suffix_libssl ".so")
if(Qt5Core_VERSION VERSION_GREATER_EQUAL "5.12.5" AND NOT Qt5Core_VERSION MATCHES "5.13.0")
  set(suffix_libssl "_1_1.so")
endif()

find_program(LLVM_STRIP NAMES llvm-strip PATHS ${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/)

ExternalProject_Add(
  ext_openssl
  DOWNLOAD_DIR ${CMAKE_BINARY_DIR}
  SOURCE_DIR ${OPENSSL_DIR}
  URL https://www.openssl.org/source/openssl-1.1.1w.tar.gz
  URL_HASH SHA256=cf3098950cb4d853ad95c0841f1f9c6d3dc102dccfcacd521d93925208b76ac8
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
  ${CMAKE_COMMAND} -E env PATH=${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin:$ENV{PATH}
  ./Configure --prefix=${CMAKE_BINARY_DIR}/android-build --openssldir=./ssl android-${CMAKE_ANDROID_ARCH} shared -D__ANDROID_API__=${CMAKE_ANDROID_API}
  BUILD_COMMAND
  ${CMAKE_COMMAND} -E env PATH=${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin:$ENV{PATH}
  make SHLIB_VERSION_NUMBER= SHLIB_EXT=${suffix_libssl} build_libs &&
  ${LLVM_STRIP} --strip-all libcrypto${suffix_libssl} &&
  ${LLVM_STRIP} --strip-all libcrypto${suffix_libssl}
  INSTALL_COMMAND
  ${CMAKE_COMMAND} -E copy "${OPENSSL_DIR}/libcrypto${suffix_libssl}" "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/" &&
  ${CMAKE_COMMAND} -E copy "${OPENSSL_DIR}/libssl${suffix_libssl}" "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/"
  )

#
add_custom_command(
  OUTPUT move_translations_to_assets
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${GCOMPRIS_TRANSLATIONS_DIR} ${CMAKE_BINARY_DIR}/android-build/assets/share/GCompris
  )

if(TARGET create-apk)
  set(PACKAGE_DIR ${PACKAGE_SOURCE_ANDROID})
  set_target_properties(create-apk-GCompris PROPERTIES ANDROID_APK_DIR "${PACKAGE_DIR}")
  add_custom_target(gcompris-move-metadata ALL
    COMMAND cmake -E echo "Moving GCompris shared Android resources"
    COMMAND cmake -E make_directory ${PACKAGE_SOURCE_ANDROID}
    COMMAND cmake -E copy_directory "${CMAKE_CURRENT_SOURCE_DIR}" "${PACKAGE_SOURCE_ANDROID}"
    )
  add_dependencies(create-apk gcompris-move-metadata)
endif()
