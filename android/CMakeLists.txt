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

find_program(ANDROID_DEPLOY_QT NAMES androiddeployqt PATHS ${QT_HOST_PATH}/${QT6_HOST_INFO_BINDIR})

# Look for androiddeployqt program
if(NOT ANDROID_DEPLOY_QT)
  message(FATAL_ERROR "Could not find androiddeployqt. Make sure you set all the Qt6_* paths to the Qt for android compiled version.")
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

set(STDCPP_PATH "\"stdcpp-path\": \"${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/\"")

set(ANDROID_TOOLCHAIN arm-linux-androideabi)
if("${CMAKE_ANDROID_ARCH}" STREQUAL "arm64")
  set(ANDROID_TOOLCHAIN aarch64-linux-android)
endif()

# set android package source for androiddeployqt json file
set(PACKAGE_SOURCE_ANDROID ${CMAKE_BINARY_DIR}/tmpAndroid)
set(ANDROID_SDK_ROOT $ENV{ANDROID_SDK_ROOT})

# Copied from ECM
file(GLOB build-tools LIST_DIRECTORIES TRUE RELATIVE ${ANDROID_SDK_ROOT}/build-tools ${ANDROID_SDK_ROOT}/build-tools/*)
list(SORT build-tools COMPARE NATURAL)
list(GET build-tools -1 _default_sdk)
set(ANDROID_SDK_BUILD_TOOLS_REVISION "${_default_sdk}" CACHE STRING "Android Build Tools version")

# Copied from ~/Qt/6.4.2/android_armv7/lib/cmake/Qt6Core/Qt6AndroidMacros.cmake
set(QT_ANDROID_ARCHITECTURES "")
set(architecture_record_list "")
foreach(abi IN LISTS qt_android_abis CMAKE_ANDROID_ARCH_ABI)
  if(abi STREQUAL "x86")
    set(arch_value "i686-linux-android")
  elseif(abi STREQUAL "x86_64")
    set(arch_value "x86_64-linux-android")
  elseif(abi STREQUAL "arm64-v8a")
    set(arch_value "aarch64-linux-android")
  elseif(abi)
    set(arch_value "arm-linux-androideabi")
  endif()
  list(APPEND architecture_record_list "\"${abi}\":\"${arch_value}\"")
endforeach()

list(JOIN architecture_record_list "," QT_ANDROID_ARCHITECTURES)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/AndroidManifest.xml.cmake ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml @ONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/configAndroid.json.cmake ${PACKAGE_SOURCE_ANDROID}/configAndroid.json @ONLY)
# TODO Remove this file as soon as we have moved to plugins instead of rcc files for activities
# This way, we'll use the one provided by Qt
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/build.gradle ${PACKAGE_SOURCE_ANDROID}/build.gradle @ONLY)

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
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_BINARY_DIR}/android-build/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --debug --apk ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-debug-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command(
  OUTPUT createApkFromAndroidDeployQtRelease
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_BINARY_DIR}/android-build/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --release --apk ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-release-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command(
  OUTPUT createApkSignedAlignedFromAndroidDeployQtRelease
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_BINARY_DIR}/android-build/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --release --sign $ENV{ANDROID_KEYSTORE} gcompris --storepass $ENV{ANDROID_KEYSTORE_PASSWD} --verbose --apk ${CMAKE_BINARY_DIR}/android-build/GCompris-Android-release-signed-aligned-${ANDROID_ABI}${APK_SUFFIX}${GCOMPRIS_VERSION}.apk
)

add_custom_command(
  OUTPUT createAabFromAndroidDeploy
  DEPENDS ${PACKAGE_SOURCE_ANDROID}/AndroidManifest.xml
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR} ${PACKAGE_SOURCE_ANDROID}
  COMMAND ${ANDROID_DEPLOY_QT} --output ${CMAKE_BINARY_DIR}/android-build/ --input ${PACKAGE_SOURCE_ANDROID}/configAndroid.json --aab --release
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

set(suffix_libssl ".so")

find_program(LLVM_STRIP NAMES llvm-strip PATHS ${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/)

ExternalProject_Add(
  ext_openssl
  DOWNLOAD_DIR ${CMAKE_BINARY_DIR}
  SOURCE_DIR ${OPENSSL_DIR}
  URL https://github.com/openssl/openssl/releases/download/openssl-3.0.15/openssl-3.0.15.tar.gz
  URL_HASH SHA256=23c666d0edf20f14249b3d8f0368acaee9ab585b09e1de82107c66e1f3ec9533
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
  ${CMAKE_COMMAND} -E env PATH=${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin:$ENV{PATH}
  ./Configure --prefix=${CMAKE_BINARY_DIR}/android-build --openssldir=./ssl android-${CMAKE_ANDROID_ARCH} shared
  BUILD_COMMAND
  ${CMAKE_COMMAND} -E env PATH=${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin:$ENV{PATH}
  make SHLIB_VERSION_NUMBER= SHLIB_EXT= build_libs &&
  ${LLVM_STRIP} --strip-all libcrypto.so &&
  ${LLVM_STRIP} --strip-all libssl.so &&
  cp libcrypto.so libcrypto_3.so &&
  cp libssl.so libssl_3.so
  INSTALL_COMMAND
  ${CMAKE_COMMAND} -E make_directory "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}" &&
  ${CMAKE_COMMAND} -E copy "${OPENSSL_DIR}/libcrypto_3.so" "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/" &&
  ${CMAKE_COMMAND} -E copy "${OPENSSL_DIR}/libssl_3.so" "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/"
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
