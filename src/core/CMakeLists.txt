#=============================================================================
# SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
include(qt_helper)

configure_file(config.h.in "${CMAKE_CURRENT_BINARY_DIR}/config.h" @ONLY)

if(WITH_KIOSK_MODE)
  add_definitions(-DWITH_KIOSK_MODE)
endif()

if (UBUNTU_TOUCH)
  add_definitions(-DUBUNTUTOUCH)
endif()

set(gcompris_SRCS
  ActivityInfo.cpp
  ActivityInfo.h
  ActivityInfoTree.cpp
  ActivityInfoTree.h
  ApplicationInfo.cpp
  ApplicationInfo.h
  ApplicationSettings.cpp
  ApplicationSettings.h
  File.cpp
  File.h
  Dataset.cpp
  Dataset.h
  Directory.cpp
  Directory.h
  DownloadManager.cpp
  DownloadManager.h
  GImageGrabber.cpp
  GImageGrabber.h
  config.h.in
  ClientNetworkMessages.cpp
  ClientNetworkMessages.h
  netconst.h
  synth/ADSRenvelope.cpp
  synth/ADSRenvelope.h
  GSynth.cpp
  GSynth.h
  synth/linearSynthesis.cpp
  synth/linearSynthesis.h
  synth/modulation.cpp
  synth/modulation.h
  synth/generator.cpp
  synth/generator.h
  synth/preset.h
  synth/preset.cpp
  synth/waveform.cpp
  synth/waveform.h
)
if(WITH_RCC)
  list(APPEND gcompris_SRCS GComprisPlugin.cpp GComprisPlugin.h)
endif()

if(ANDROID)
  list(APPEND gcompris_SRCS ApplicationAndroid.cpp)
else()
  list(APPEND gcompris_SRCS ApplicationInfoDefault.cpp)
endif()

# Resources
set(GCOMPRIS_RESOURCES "${PROJECT_SOURCE_DIR}/installer")
if(CMAKE_HOST_WIN32)
  set(gcompris_icon GCompris.ico)
  set(gcompris_RES
    ${GCOMPRIS_RESOURCES}/${gcompris_icon}
    GCompris.rc
  )
elseif(CMAKE_HOST_APPLE)
  set(gcompris_icon GCompris.icns)
  set(gcompris_RES ${GCOMPRIS_RESOURCES}/${gcompris_icon})
  set_source_files_properties(${gcompris_RES} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
endif()

set(used_qt_modules ${QT_MAJOR}::Qml ${QT_MAJOR}::Quick ${QT_MAJOR}::Gui ${QT_MAJOR}::Multimedia ${QT_MAJOR}::Core ${QT_MAJOR}::Svg ${QT_MAJOR}::Sensors ${QT_MAJOR}::QuickControls2 ${QT_MAJOR}::QuickTemplates2 ${QT_MAJOR}::QmlWorkerScript)

if(TARGET ${QT_MAJOR}::CorePrivate)
  set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::CorePrivate)
endif()

if(QT_VERSION VERSION_LESS "6.9.0")
  set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::Widgets ${QT_MAJOR}::Charts)
else()
  set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::Graphs ${QT_MAJOR}::Quick3D)
endif()

if(TARGET ${QT_MAJOR}::QuickControls2Basic)
  set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::QuickControls2Basic)
  if(TARGET ${QT_MAJOR}::QuickControls2BasicPrivate)
    set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::QuickControls2BasicPrivate)
  endif()

  # This should not be needed! But for some reason, on windows it does not find
  # automatically the library so we need to install it manually
  if(WIN32)
    get_target_property(QuickControls2BasicLibrary ${QT_MAJOR}::QuickControls2Basic IMPORTED_LOCATION)
    install(FILES ${QuickControls2BasicLibrary} DESTINATION ${CMAKE_INSTALL_BINDIR})
  endif()
endif()

if(TARGET ${QT_MAJOR}::WaylandClient)
  set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::WaylandClient)
  if(TARGET ${QT_MAJOR}::WaylandClientPrivate)
    set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::WaylandClientPrivate)
  endif()
endif()

if(ANDROID)
  add_library(${GCOMPRIS_EXECUTABLE_NAME} SHARED main.cpp)
elseif(CMAKE_HOST_APPLE)
  add_executable(${GCOMPRIS_EXECUTABLE_NAME} MACOSX_BUNDLE ${gcompris_RES} main.cpp)
elseif(CMAKE_HOST_WIN32)
  add_executable(${GCOMPRIS_EXECUTABLE_NAME} WIN32 ${gcompris_RES} main.cpp)
else()
  add_executable(${GCOMPRIS_EXECUTABLE_NAME} ${gcompris_RES} main.cpp)
endif()

add_library(gcompris_core STATIC ${gcompris_SRCS})
target_link_libraries(gcompris_core ${used_qt_modules})

target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} gcompris_core ${used_qt_modules})

if (USE_16KB_PAGESIZE)
  target_link_options(${GCOMPRIS_EXECUTABLE_NAME} PRIVATE "-Wl,-z,max-page-size=16384")
endif()

if(WITH_RCC)
  GCOMPRIS_ADD_RCC(core
    QML_FILES
    *.qml
    *.js
    RESOURCES
    resource/*.${COMPRESSED_AUDIO}
    resource/*.gif
    resource/*.png
    resource/*.svg
    resource/*.pem
    resource/bonus/*
    resource/sounds/*
    resource/fonts/*.*
    qmldir
    COPYING
  )
else()
  add_library(core SHARED)
  file(GLOB core_qml_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.qml *.js)
  file(GLOB core_resources_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} resource/*.${COMPRESSED_AUDIO} resource/*.gif resource/*.png resource/*.svg resource/*.pem resource/bonus/* resource/sounds/* resource/fonts/*.*)

  set_source_files_properties(GCSingletonFontLoader.qml GCStyle.qml PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
    )
  qt_add_qml_module(
    core
    URI core
    RESOURCE_PREFIX /gcompris/src/
    VERSION 1.0
    QML_FILES
    ${core_qml_files}
    RESOURCES
    ${core_resources_files}
    )
  target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} core)
endif()

if(ANDROID)
  set_property(TARGET ${GCOMPRIS_EXECUTABLE_NAME} PROPERTY SUFFIX "_${CMAKE_ANDROID_ARCH_ABI}.so")
endif()
# Installation
# ============

if(PACKAGE_GCOMPRIS)
  include(PackageGCompris.cmake)
endif()
