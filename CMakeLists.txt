#=============================================================================
# SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
cmake_minimum_required(VERSION 3.16)

project(gcompris-qt C CXX)

# get all the redist dll needed for windows when compiling with vc
set(CMAKE_INSTALL_UCRT_LIBRARIES 1)
include(InstallRequiredSystemLibraries)

# Set c++11 support
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# enable qml debugging for DEBUG builds:
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG")

set(GCOMPRIS_MAJOR_VERSION 25)
set(GCOMPRIS_MINOR_VERSION 0)
set(GCOMPRIS_PATCH_VERSION 0)

if("${CMAKE_ANDROID_ARCH}" STREQUAL "arm64")
  set(GCOMPRIS_PATCH_VERSION 1)
endif()

# Set the BUILD_DATE
string(TIMESTAMP BUILD_DATE %Y%m)

include(FeatureSummary)
include(GNUInstallDirs)

# cmake modules setup
find_package(ECM 1.4.0 QUIET NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake/)

# KDE po to qm tools
if(ECM_FOUND)
  include(ECMAddTests)

  option(BUILD_TESTING "Build and enable unit tests" OFF)
  include(ECMCoverageOption)
endif()

add_compile_definitions(QT_DISABLE_DEPRECATED_BEFORE=0x060500)

# add tools (cppcheck, clang-tidy...) if build on testing mode only
# (slower compilation)
if(BUILD_TESTING)
  include(CodeQualityUtils)
endif()

set(QT_REQUIRED_VERSION 6.5.0)

if(CMAKE_SYSTEM_NAME STREQUAL Android)
  set(ANDROID 1)
  # Require ndk minimum version to 25
  if(ANDROID_NDK_REVISION VERSION_LESS "25.0.0")
    message(FATAL_ERROR "android ndk 25 minimal required, actually using ${ANDROID_NDK_REVISION}")
  endif()
endif()

# Set executable filename
if(ANDROID)
  set(GCOMPRIS_EXECUTABLE_NAME GCompris)
elseif(WIN32)
  set(GCOMPRIS_EXECUTABLE_NAME GCompris)
else()
  set(GCOMPRIS_EXECUTABLE_NAME gcompris-qt)
endif()

set(GCOMPRIS_VERSION ${GCOMPRIS_MAJOR_VERSION}.${GCOMPRIS_MINOR_VERSION})

# An integer value that represents the version of the application
# Increase it at each release
math(EXPR GCOMPRIS_VERSION_CODE "${GCOMPRIS_MAJOR_VERSION}*10000 + ${GCOMPRIS_MINOR_VERSION}*100 + ${GCOMPRIS_PATCH_VERSION}")

# prevent build in source directory
if("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
    message(SEND_ERROR "Building in the source directory is not supported.")
    message(FATAL_ERROR "Please remove the created \"CMakeCache.txt\" file, the \"CMakeFiles\"
            directory and create a build directory and call \"${CMAKE_COMMAND} <path to the sources>\".")
endif()

set(QT_MAJOR Qt6)

set(QT_COMPONENTS Qml Quick Gui Multimedia Core Svg Network LinguistTools Sensors QuickControls2 QuickTemplates2 Charts Widgets QmlWorkerScript)

find_package(${QT_MAJOR} ${QT_REQUIRED_VERSION} COMPONENTS
    ${QT_COMPONENTS})

set_package_properties(${QT_MAJOR} PROPERTIES TYPE REQUIRED)
foreach(COMPONENT ${QT_COMPONENTS})
  set_package_properties(${QT_MAJOR}${COMPONENT} PROPERTIES TYPE REQUIRED)
endforeach()

# It seems to only be present on some Linux distributions, not FreeBSD for example and starting Qt6.6 so not enforcing it
find_package(${QT_MAJOR} ${QT_REQUIRED_VERSION} OPTIONAL_COMPONENTS QuickControls2Basic)


# Set Qt policy, introduced in Qt6.8
if(QT_KNOWN_POLICY_QTP0004)
  qt6_policy(SET QTP0004 NEW)
endif()

# Starting C++20, emit() is a function in standard library. To avoid using Qt keywords like signals, slots, emit, we define this variable
add_definitions(
    -DQT_USE_QSTRINGBUILDER
    -DQT_NO_CAST_TO_ASCII
    -DQT_NO_URL_CAST_FROM_STRING
    -DQT_NO_KEYWORDS
    -DQT_NO_FOREACH
)

if(UNIX AND NOT APPLE AND NOT ANDROID)
  find_package(${QT_MAJOR} ${QT_REQUIRED_VERSION} OPTIONAL_COMPONENTS WaylandClient)
endif()

# For systems where ICU is not packaged with Qt installer
# And we want to package it from system
option(SHIP_SYSTEM_ICU "Ship system ICU in packages and not the one packaged by Qt" OFF)
if(SHIP_SYSTEM_ICU)
  find_package(ICU COMPONENTS data uc i18n)
  set_package_properties(ICU PROPERTIES TYPE REQUIRED)
endif()

if((UNIX AND NOT APPLE AND NOT ANDROID) OR WIN32)
  find_package(OpenSSL)
  set_package_properties(OpenSSL PROPERTIES TYPE REQUIRED)
endif()

option(COMPILE_DOC "Enable compilation of GCompris docbook" OFF)
if(COMPILE_DOC)
  find_package(KF6 QUIET COMPONENTS DocTools)
endif()

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

if(ECM_FOUND)
    include(KDEInstallDirs)

    if(ECM_VERSION VERSION_GREATER "1.6.0")
        add_subdirectory(images)
        install(FILES org.kde.gcompris.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
        install(FILES org.kde.gcompris.desktop DESTINATION ${KDE_INSTALL_APPDIR})
    else()
        message(STATUS "ECM_VERSION is ${ECM_VERSION}, icons and desktop files won't be installed.")
    endif()
endif()

# Tell CMake to run moc when necessary:
set(CMAKE_AUTOMOC ON)

# As moc files are generated in the binary dir, tell CMake
# to always look for includes there:
set(CMAKE_INCLUDE_CURRENT_DIR ON)

#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
#    message("${_variableName}=${${_variableName}}")
#endforeach()

option(WITH_RCC "Use rcc for activities instead of qml plugins" ON)

option(WITH_DOWNLOAD "Internal download" ON)
# @FIXME These permissions should be removed if download is disable
#        but it makes the application crash on exit (tested on Android 6)
set(ANDROID_INTERNET_PERMISSION "<uses-permission android:name=\"android.permission.INTERNET\" />")
set(ANDROID_ACCESS_NETWORK_STATE_PERMISSION "<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\" />")

set(GRAPHICAL_RENDERER "auto" CACHE STRING "Policy for choosing the renderer backend [opengl|software|auto]")

# Set output directory
if(CMAKE_HOST_APPLE)
  set(_bundle_bin gcompris-qt.app/Contents/MacOS)
  set(_data_dest_dir ${CMAKE_INSTALL_BINDIR}/${_bundle_bin}/../Resources)
else()
  set(_data_dest_dir ${CMAKE_INSTALL_DATADIR}/${GCOMPRIS_EXECUTABLE_NAME})
endif()
if(ANDROID)
  # Android .so output
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/android-build/libs/${ANDROID_ABI}/)
  set(GCOMPRIS_TRANSLATIONS_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir} CACHE INTERNAL "" FORCE)
  set(GCOMPRIS_RCC_DIR ${CMAKE_BINARY_DIR}/android-build/assets/${_data_dest_dir}/rcc CACHE INTERNAL "" FORCE)
  set(ANDROID_PACKAGE "net.gcompris.full")
  add_subdirectory(android)
elseif(CMAKE_HOST_APPLE)
  # MacOSX build
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(GCOMPRIS_TRANSLATIONS_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir}/translations CACHE INTERNAL "" FORCE)
  set(GCOMPRIS_RCC_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir}/rcc CACHE INTERNAL "" FORCE)
else()
  # Desktop build
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
  set(GCOMPRIS_TRANSLATIONS_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir}/translations CACHE INTERNAL "" FORCE)
  set(GCOMPRIS_RCC_DIR ${CMAKE_BINARY_DIR}/${_data_dest_dir}/rcc CACHE INTERNAL "" FORCE)
endif()

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

# Get all supported locales by GCompris from LanguageList.qml file, excluded the commented ones
file(STRINGS "${CMAKE_SOURCE_DIR}/src/core/LanguageList.qml" handledGComprisLocaleList ENCODING UTF-8 REGEX "[^//]{.*UTF-8")
foreach(localeLine ${handledGComprisLocaleList})
  # We match the pattern locale.UTF-8
  string(REGEX MATCH ".*\"([a-zA-Z_@]*)\.UTF-8.*" _ ${localeLine})
  set(localeFull ${CMAKE_MATCH_1})
  list(APPEND gcomprisLocales ${localeFull})
  # Add simplified locale
  string(REGEX MATCH "([a-zA-Z@]*)_.*" _ ${localeFull})
  set(localeShort ${CMAKE_MATCH_1})
  list(APPEND gcomprisLocales ${localeShort})

endforeach()
# Remove all duplicated shortened locales
list(REMOVE_DUPLICATES gcomprisLocales)

#skipping translations can be useful during dev builds
option(SKIP_TRANSLATIONS "Skip building translation files" OFF)
if(NOT SKIP_TRANSLATIONS)
  # Get all po files in poqm/
  file(GLOB TRANSLATIONS_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "poqm/*/gcompris_qt.po")
  foreach(PoSource ${TRANSLATIONS_FILES})
    # Get the locale
    string(REGEX MATCH "poqm/([a-zA-Z@_\-]*)/gcompris_qt.po" _ ${PoSource})
    set(locale ${CMAKE_MATCH_1})

    # search in src/core/LanguageList the line corresponding to the locale. If exists, then add the custom_command
    if(NOT ${locale} IN_LIST gcomprisLocales)
      message(STATUS "Locale ${locale} not supported by GCompris")
      continue()
    endif()
    message(STATUS "Locale ${locale} is supported by GCompris")

    # Changes the .po extension to .ts
    string(REPLACE ".po" ".ts" TsSource ${PoSource})
    # Replace qt in gcompris_qt.po with the locale
    string(REPLACE "qt" "${locale}" TsSource ${TsSource})
    # Removes the poqm/${locale} folder prefix
    string(REPLACE "poqm/${locale}/" "" TsSource ${TsSource})
    # qm extension filename
    string(REPLACE ".ts" ".qm" QmOutput ${TsSource})

    set(OutTsFile ${CMAKE_BINARY_DIR}/tmp/${TsSource})

    add_custom_command(
      OUTPUT ${QmOutput}
      COMMAND cmake -E make_directory ${GCOMPRIS_TRANSLATIONS_DIR}
      COMMAND cmake -E make_directory ${CMAKE_BINARY_DIR}/tmp
      # Remove the obsolete translations and set po in the ts output file
      COMMAND msgattrib --no-obsolete  ${CMAKE_CURRENT_SOURCE_DIR}/${PoSource} -o ${OutTsFile}
      # Convert the po into ts
      COMMAND ${QT_MAJOR}::lconvert -if po -of ts -i ${OutTsFile} -o ${OutTsFile}
      # Convert the ts in qm removing non finished translations
      COMMAND ${QT_MAJOR}::lrelease -removeidentical -nounfinished ${OutTsFile} -qm ${GCOMPRIS_TRANSLATIONS_DIR}/${QmOutput}
      )
    list(APPEND QM_FILES ${QmOutput})
  endforeach()
endif()
  
# Install translations
add_custom_target(BuildTranslations ALL
    DEPENDS ${QM_FILES}
)

if(CMAKE_HOST_APPLE)
  install(DIRECTORY ${GCOMPRIS_TRANSLATIONS_DIR} DESTINATION ${_bundle_bin})
elseif(ANDROID)
  install(DIRECTORY ${GCOMPRIS_TRANSLATIONS_DIR} DESTINATION ${CMAKE_INSTALL_DATADIR})
else()
  install(DIRECTORY ${GCOMPRIS_TRANSLATIONS_DIR} DESTINATION ${_data_dest_dir})
endif()

# Build standalone package option -> if ON, we will copy the required Qt files in the build package.
# If OFF, "make install" will not copy Qt files so only GCompris files will be packaged.
# By default, it is true on Windows (as we deliver NSIS package), macOS (bundled), android (apk) and false on linux (to do make install)
# If you want to create a STGZ package for linux (auto-extractible), override this variable by typing : cmake -DBUILD_STANDALONE=ON
if(UNIX AND NOT ANDROID AND NOT APPLE)
  option(BUILD_STANDALONE "Build a standalone package when typing 'make package'" OFF)
else()
  option(BUILD_STANDALONE "Build a standalone package when typing 'make package'" ON)
endif()

# Default to Release if we build a package
if(BUILD_STANDALONE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build." FORCE)
endif()

option(WITH_KIOSK_MODE "Set the kiosk mode by default" OFF)

if(WIN32)
  set(COMPRESSED_AUDIO "mp3" CACHE STRING "Compressed Audio format [ogg|aac|mp3]")
elseif(APPLE)
  set(COMPRESSED_AUDIO "aac" CACHE STRING "Compressed Audio format [ogg|aac|mp3]")
else()
  set(COMPRESSED_AUDIO "ogg" CACHE STRING "Compressed Audio format [ogg|aac|mp3]")
endif()

file(GLOB_RECURSE OGG_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/ "*.ogg")

foreach(OGG_FILE ${OGG_FILES})
  # This should only replace the extension
  string(REGEX REPLACE "ogg$" "aac" AAC_FILE ${OGG_FILE})
  add_custom_command(
    OUTPUT ${AAC_FILE}
    # Put the good line depending on your installation
    COMMAND avconv -v warning -i ${OGG_FILE} -acodec libvo_aacenc ${AAC_FILE}
    #COMMAND ffmpeg -v warning -i ${OGG_FILE} -acodec aac -strict -2 ${AAC_FILE}
    )
  list(APPEND AAC_FILES ${AAC_FILE})

  # This should only replace the extension
  string(REGEX REPLACE "ogg$" "mp3" MP3_FILE ${OGG_FILE})
  add_custom_command(
    OUTPUT ${MP3_FILE}
    # Put the good line depending on your installation
    #COMMAND avconv -v warning -i ${OGG_FILE} -acodec mp3 ${MP3_FILE}
    COMMAND ffmpeg -v warning -i ${OGG_FILE} -acodec mp3 -strict -2 ${MP3_FILE}
    )
  list(APPEND MP3_FILES ${MP3_FILE})
endforeach()

add_custom_target(
  createAacFromOgg
  DEPENDS ${AAC_FILES}
  )

add_custom_target(
  createMp3FromOgg
  DEPENDS ${MP3_FILES}
  )

if(ANDROID)
  set(GCOMPRIS_ASSETS_DIR ${GCOMPRIS_RCC_DIR}/../../../ CACHE INTERNAL "" FORCE)
else()
  set(GCOMPRIS_ASSETS_DIR ${GCOMPRIS_RCC_DIR} CACHE INTERNAL "" FORCE)
endif()

# predownload assets (voices and images) and install them in the rcc folder
set(DOWNLOAD_ASSETS "" CACHE STRING "Download and packages images and voices. use a list like: words,en,fr,pt_BR,music to retrieve multiple files")
add_custom_command(
    OUTPUT predownloadAssets
    COMMAND python3 tools/download-assets.py ${DOWNLOAD_ASSETS} ${COMPRESSED_AUDIO} ${GCOMPRIS_ASSETS_DIR}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )

add_custom_command(
    OUTPUT assetsFolders
    COMMAND cmake -E make_directory "${GCOMPRIS_ASSETS_DIR}/data3"
    COMMAND cmake -E make_directory "${GCOMPRIS_ASSETS_DIR}/data3/voices-${COMPRESSED_AUDIO}"
    COMMAND cmake -E make_directory "${GCOMPRIS_ASSETS_DIR}/data3/words"
    COMMAND cmake -E make_directory "${GCOMPRIS_ASSETS_DIR}/data3/backgroundMusic"
    )
# Install assets
add_custom_target(getAssets
  DEPENDS assetsFolders predownloadAssets
  )

add_custom_command(
    OUTPUT doBundleConvertedOggs
    COMMAND 7z a converted_ogg_to_${COMPRESSED_AUDIO}-${GCOMPRIS_VERSION}.7z '-ir!src/*${COMPRESSED_AUDIO}'
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
# Bundle oggs ready to be uploaded on a server. This ease build on system without the appropriate audio
# conversion tools.
add_custom_target(BundleConvertedOggs
  DEPENDS doBundleConvertedOggs
  COMMENT "Bundle the converted oggs to upload them on a server. First set COMPRESSED_AUDIO appropriately."
  )

add_custom_command(
    OUTPUT doDlAndInstallBundledConvertedOggs
    COMMAND curl -fsS -o converted_ogg_to_${COMPRESSED_AUDIO}-${GCOMPRIS_VERSION}.7z
            https://gcompris.net/download/converted_ogg_to_${COMPRESSED_AUDIO}-${GCOMPRIS_VERSION}.7z
    COMMAND 7z x -y converted_ogg_to_${COMPRESSED_AUDIO}-${GCOMPRIS_VERSION}.7z
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
# Download and install bundled converted oggs
add_custom_target(DlAndInstallBundledConvertedOggs
  DEPENDS doDlAndInstallBundledConvertedOggs
  COMMENT "Download the bundled converted oggs and install them in the source dir"
  )

if(${GCOMPRIS_PATCH_VERSION} STREQUAL 0)
  set(ARCHIVE_NAME ${CMAKE_PROJECT_NAME}-${GCOMPRIS_VERSION})
else()
  set(ARCHIVE_NAME ${CMAKE_PROJECT_NAME}-${GCOMPRIS_VERSION}.${GCOMPRIS_PATCH_VERSION})
endif()

add_custom_target(dist
    COMMAND git archive --prefix=${ARCHIVE_NAME}/ HEAD
        | xz > ${CMAKE_BINARY_DIR}/${ARCHIVE_NAME}.tar.xz
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})

if(KF6_FOUND)
    add_subdirectory(docs/docbook)
endif()

# qml-box2d
include(cmake/box2d.cmake)

add_subdirectory(src)

if (UBUNTU_TOUCH)
    add_subdirectory(platforms/ubuntutouch)
endif ()

# only enable unit tests for linux
if(BUILD_TESTING)
  enable_testing()
  add_subdirectory(tests)
endif()

add_custom_target(binaries)
add_dependencies(binaries ${GCOMPRIS_EXECUTABLE_NAME} rcc_activities all_activities)
if(WITH_RCC)
  add_dependencies(binaries rcc_menu rcc_core)
endif()

# Add a target to automatise the filling of the files requiring info for the releases: appdata/publiccode release date, fastlane changelog
string(TIMESTAMP currentDay "%Y-%m-%d")
add_custom_command(
    OUTPUT doUpdateReleaseDate
    COMMAND ./tools/bump_version.sh -v ${GCOMPRIS_VERSION} -r ${currentDay}
    COMMAND python3 ./tools/fdroid_update_fastlane_metadata.py ${GCOMPRIS_VERSION_CODE}
    COMMAND python3 ./tools/android_format_changelog.py ${GCOMPRIS_VERSION_CODE}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
add_custom_target(updateReleaseDate
  DEPENDS doUpdateReleaseDate
  COMMENT "Run the scripts to bump the version if not already done. It assumes the changelog is already created for this version."
  )
  
