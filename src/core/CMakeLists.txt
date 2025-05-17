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
  main.cpp
  config.h.in
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

set(used_qt_modules ${QT_MAJOR}::Qml ${QT_MAJOR}::Quick ${QT_MAJOR}::Widgets ${QT_MAJOR}::Gui ${QT_MAJOR}::Multimedia ${QT_MAJOR}::Core ${QT_MAJOR}::Svg ${QT_MAJOR}::Sensors ${QT_MAJOR}::QuickControls2 ${QT_MAJOR}::QuickTemplates2 ${QT_MAJOR}::Charts ${QT_MAJOR}::QmlWorkerScript ${QT_MAJOR}::CorePrivate)

if(TARGET ${QT_MAJOR}::QuickControls2Basic)
  set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::QuickControls2Basic ${QT_MAJOR}::QuickControls2BasicPrivate)
  # This should not be needed! But for some reason, on windows it does not find
  # automatically the library so we need to install it manually
  if(WIN32)
    get_target_property(QuickControls2BasicLibrary ${QT_MAJOR}::QuickControls2Basic IMPORTED_LOCATION)
    install(FILES ${QuickControls2BasicLibrary} DESTINATION ${CMAKE_INSTALL_BINDIR})
  endif()
endif()

if(TARGET ${QT_MAJOR}::WaylandClient)
    set(used_qt_modules ${used_qt_modules} ${QT_MAJOR}::WaylandClient ${QT_MAJOR}::WaylandClientPrivate)
endif()

if(ANDROID)
  add_library(${GCOMPRIS_EXECUTABLE_NAME} SHARED ${gcompris_SRCS})
elseif(CMAKE_HOST_APPLE)
  add_executable(${GCOMPRIS_EXECUTABLE_NAME} MACOSX_BUNDLE ${gcompris_SRCS} ${gcompris_RES})
elseif(CMAKE_HOST_WIN32)
  add_executable(${GCOMPRIS_EXECUTABLE_NAME} WIN32 ${gcompris_SRCS} ${gcompris_RES})
else()
  add_executable(${GCOMPRIS_EXECUTABLE_NAME} ${gcompris_SRCS} ${gcompris_RES})
endif()

# only build the lib for testing purpose
if(BUILD_TESTING)
  if(WIN32)
    add_library(gcompris_core STATIC ${gcompris_SRCS})
  else()
    add_library(gcompris_core SHARED ${gcompris_SRCS})
  endif()
  target_link_libraries(gcompris_core ${used_qt_modules})
endif()

target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} ${used_qt_modules})

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

install(TARGETS ${GCOMPRIS_EXECUTABLE_NAME}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_BINDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  BUNDLE DESTINATION .)

if(BUILD_STANDALONE)
  # Qt plugins to install
  set(_qt_plugins "")

  set(default_plugins ${QT_MAJOR}::QSvgPlugin ${QT_MAJOR}::QWebpPlugin ${QT_MAJOR}::QGifPlugin ${QT_MAJOR}::genericSensorPlugin ${QT_MAJOR}::QtSensorGesturePlugin ${QT_MAJOR}::QShakeSensorGesturePlugin)
  if(WIN32)
    set(default_plugins ${default_plugins} ${QT_MAJOR}::QICOPlugin ${QT_MAJOR}::QWindowsIntegrationPlugin ${QT_MAJOR}::QWindowsAudioPlugin ${QT_MAJOR}::AudioCaptureServicePlugin ${QT_MAJOR}::DSServicePlugin)
  elseif(ANDROID)
    set(default_plugins ${default_plugins} ${QT_MAJOR}::QAndroidIntegrationPlugin)
  elseif(APPLE)
    set(default_plugins ${default_plugins} ${QT_MAJOR}::QICNSPlugin ${QT_MAJOR}::QTgaPlugin ${QT_MAJOR}::QTiffPlugin ${QT_MAJOR}::QCocoaIntegrationPlugin)
  else()
    set(default_plugins ${default_plugins} ${QT_MAJOR}::QComposePlatformInputContextPlugin ${QT_MAJOR}::QXcbIntegrationPlugin ${QT_MAJOR}::QXcbEglIntegrationPlugin ${QT_MAJOR}::QXcbGlxIntegrationPlugin ${QT_MAJOR}::QAlsaPlugin ${QT_MAJOR}::QPulseAudioPlugin ${QT_MAJOR}::QWaylandIntegrationPlugin ${QT_MAJOR}::QWaylandXdgShellIntegrationPlugin ${QT_MAJOR}::QWaylandEglPlatformIntegrationPlugin ${QT_MAJOR}::QWaylandEglClientBufferPlugin)
  endif()

  # First plugins should be used on all platforms
  foreach(_plugin ${default_plugins})
    if(TARGET ${_plugin})
      message(STATUS "${_plugin} will be included in the package")
      list(APPEND _qt_plugins ${_plugin})
    else()
      message(STATUS "${_plugin} is not a plugin for this system")
    endif()
  endforeach()

  # Qml plugins to install
  if(WIN32)
    set(_lib_prefix "")
  else()
    set(_lib_prefix "lib")
  endif()

  set(_qt_plugins2 "")
  # Seems to be everywhere
  list(APPEND _qt_plugins2 tls/${_lib_prefix}qopensslbackend)
  list(APPEND _qt_plugins2 multimedia/${_lib_prefix}ffmpegmediaplugin)

  if(ANDROID)
    list(APPEND _qt_plugins2 multimedia/${_lib_prefix}androidmediaplugin)
  elseif(WIN32)
    list(APPEND _qt_plugins2 multimedia/${_lib_prefix}windowsmediaplugin)
  elseif(APPLE)
    list(APPEND _qt_plugins2 multimedia/${_lib_prefix}darwinmediaplugin)
  endif()

   set(_qml_plugins
     QtQml/Models/${_lib_prefix}modelsplugin
     QtQml/WorkerScript/${_lib_prefix}workerscriptplugin
     QtCore/${_lib_prefix}qtqmlcoreplugin
     QtQuick/Controls/Basic/impl/${_lib_prefix}qtquickcontrols2basicstyleimplplugin
     QtQuick/Controls/Basic/${_lib_prefix}qtquickcontrols2basicstyleplugin
     QtQuick/Controls/impl/${_lib_prefix}qtquickcontrols2implplugin
     QtQuick/Effects/${_lib_prefix}effectsplugin
     QtQuick/Window/${_lib_prefix}quickwindowplugin
     QtQuick/Particles/${_lib_prefix}particlesplugin
     QtQuick/${_lib_prefix}qtquick2plugin
     QtQuick/Shapes/${_lib_prefix}qmlshapesplugin
     QtMultimedia/${_lib_prefix}quickmultimediaplugin
     QtSensors/${_lib_prefix}sensorsquickplugin
     QtCharts/${_lib_prefix}qtchartsqml2plugin)

  # TODO Double check for ubuntutouch, we may need qtquickcontrols2/templates2!
  if(NOT UBUNTUTOUCH)
    list(APPEND _qml_plugins
      QtQuick/Controls/${_lib_prefix}qtquickcontrols2plugin
      QtQuick/Templates/${_lib_prefix}qtquicktemplates2plugin
      QtQuick/Layouts/${_lib_prefix}qquicklayoutsplugin)
  endif()

  set(GCOMPRIS_OTHER_LIBS)

  if(APPLE)
    set(_app gcompris-qt.app)
    set(_qtconf_destdir ${_app}/Contents/Resources)
    set(_qt_plugins_destdir ${_app}/Contents/plugins)
    set(_qt_qml_destdir ${_app}/Contents/qml)
    set(GCOMPRIS_BUNDLE "\${CMAKE_INSTALL_PREFIX}/${_app}")
    set_target_properties(gcompris-qt PROPERTIES
      MACOSX_BUNDLE_INFO_STRING "GCompris, Educational game for children 2 to 10"
      MACOSX_BUNDLE_ICON_FILE "${gcompris_icon}"
      MACOSX_BUNDLE_GUI_IDENTIFIER "net.gcompris"
      MACOSX_BUNDLE_LONG_VERSION_STRING "${GCOMPRIS_MAJOR_VERSION}.${GCOMPRIS_MINOR_VERSION}.${GCOMPRIS_PATCH_VERSION}"
      MACOSX_BUNDLE_BUNDLE_NAME "gcompris-qt"
      MACOSX_BUNDLE_SHORT_VERSION_STRING "${GCOMPRIS_VERSION}"
      MACOSX_BUNDLE_BUNDLE_VERSION "${GCOMPRIS_VERSION}"
      MACOSX_BUNDLE_COPYRIGHT "AGPL-3.0 License, SPDX-FileCopyrightText: 2000-2022 Timothee Giet and Others.")
    set_source_files_properties(${GCOMPRIS_RESOURCES}/${gcompris_icon} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
  else()
    set(_qtconf_destdir bin)
    set(_qt_plugins_destdir bin/plugins)
    set(_qt_qml_destdir bin/qml)
    if(CMAKE_HOST_WIN32)
      set(GCOMPRIS_BUNDLE "\${CMAKE_INSTALL_PREFIX}/bin/${GCOMPRIS_EXECUTABLE_NAME}.exe")
    else()
      set(GCOMPRIS_BUNDLE "\${CMAKE_INSTALL_PREFIX}/bin/${GCOMPRIS_EXECUTABLE_NAME}")
    endif()
  endif()

  # install qt.conf file
  install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/qt.conf DESTINATION ${_qtconf_destdir})

  # install qt plugins
  foreach(_plugin ${_qt_plugins})
    installQtPlugin(${_plugin} ${_qt_plugins_destdir} _lib)
    list(APPEND GCOMPRIS_OTHER_LIBS ${_lib})
  endforeach()
  foreach(_plugin ${_qt_plugins2})
    if(APPLE)
      installQtPlugin2(${_plugin} ${_qt_plugins_destdir}/../Plugins _lib)
    else()
      installQtPlugin2(${_plugin} ${_qt_plugins_destdir} _lib)
    endif()
    list(APPEND GCOMPRIS_OTHER_LIBS ${_lib})
  endforeach()

  # install qml plugins
  foreach(_plugin ${_qml_plugins})
    installQmlPlugin(${_plugin} ${_qt_qml_destdir} _lib)
    list(APPEND GCOMPRIS_OTHER_LIBS ${_lib})
  endforeach()

  if(UNIX AND NOT APPLE AND NOT ANDROID)
    if(SHIP_SYSTEM_ICU)
      file(GLOB ICU_DATA_LIBRARY "${ICU_DATA_LIBRARY_RELEASE}.[0-9][0-9]")
      file(GLOB ICU_I18N_LIBRARY "${ICU_I18N_LIBRARY_RELEASE}.[0-9][0-9]")
      file(GLOB ICU_UC_LIBRARY "${ICU_UC_LIBRARY_RELEASE}.[0-9][0-9]")
      install(FILES "${ICU_DATA_LIBRARY}" DESTINATION bin)
      install(FILES "${ICU_DATA_LIBRARY}.1" DESTINATION bin)
      install(FILES "${ICU_I18N_LIBRARY}" DESTINATION bin)
      install(FILES "${ICU_I18N_LIBRARY}.1" DESTINATION bin)
      install(FILES "${ICU_UC_LIBRARY}" DESTINATION bin)
      install(FILES "${ICU_UC_LIBRARY}.1" DESTINATION bin)
      target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} ${ICU_LIBRARIES})
    endif()

    # package OpenSSL libs from system
    install(FILES "${OPENSSL_SSL_LIBRARY}" DESTINATION bin)
    install(FILES "${OPENSSL_CRYPTO_LIBRARY}" DESTINATION bin)
    install(FILES "${OPENSSL_SSL_LIBRARY}.3" DESTINATION bin)
    install(FILES "${OPENSSL_CRYPTO_LIBRARY}.3" DESTINATION bin)
    target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} OpenSSL::SSL OpenSSL::Crypto)
  endif()

  #Add OpenSSL support on Windows builds
  if(WIN32)
    if(MINGW)
      if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        #64bit
        set(OPENSSL_DLL_SUFFIX "-x64")
      endif()
      install(FILES "${OPENSSL_ROOT_DIR}/bin/libcrypto-3${OPENSSL_DLL_SUFFIX}.dll" DESTINATION bin)
      install(FILES "${OPENSSL_ROOT_DIR}/bin/libssl-3${OPENSSL_DLL_SUFFIX}.dll" DESTINATION bin)
    endif()
    target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} OpenSSL::SSL OpenSSL::Crypto)
  endif()

endif()

# install fixup_bundle script to resolve and fixup runtime dependencies
if(BUILD_STANDALONE AND NOT ANDROID)
  # Specify the path to get the Qt libraries
  get_target_property(QtCore_location ${QT_MAJOR}::Core LOCATION)
  get_filename_component(QT_LIBS_DIRECTORY ${QtCore_location} DIRECTORY)
  configure_file(${CMAKE_SOURCE_DIR}/cmake/FixBundle.cmake.in FixBundle.cmake)
  install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake)

  # install a startup script for linux bundle
  if(UNIX AND NOT APPLE AND NOT UBUNTUTOUCH)
    install(PROGRAMS ../../tools/gcompris-qt.sh DESTINATION ${CMAKE_INSTALL_BINDIR})
  endif()
endif()

if(WIN32 AND NOT MINGW)
# install libEGL.dll, libGLESv2.dll, d3dcompiler_47.dll from Qt installation. Not sure if there is a clean way to get them...
# Qt6_Dir is like C:/Qt/Qt6.5.3/mingw_64/lib/cmake/Qt6
    #install(FILES ${Qt6_DIR}/../../../bin/libEGL.dll DESTINATION bin)
    #install(FILES ${Qt6_DIR}/../../../bin/libGLESv2.dll DESTINATION bin)
    #install(FILES ${Qt6_DIR}/../../../bin/d3dcompiler_47.dll DESTINATION bin)
    #target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} ${Qt6_DIR}/../../libEGL.lib)
    #target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} ${Qt6_DIR}/../../libGLESv2.lib)
    #install(FILES ${Qt6_DIR}/../../../bin/opengl32sw.dll DESTINATION bin)
    # CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS contains visual c++ libraries
    install(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION bin)
endif()

# Packaging
# =========

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "GCompris is a high quality educational software suite, including a large number of activities for children aged 2 to 10.")
set(CPACK_PACKAGE_VERSION_MAJOR ${GCOMPRIS_MAJOR_VERSION})
set(CPACK_PACKAGE_VERSION_MINOR ${GCOMPRIS_MINOR_VERSION})
set(CPACK_PACKAGE_VERSION_PATCH ${GCOMPRIS_PATCH_VERSION})
set(CPACK_PACKAGE_VERSION ${GCOMPRIS_VERSION})
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSES/AGPL-3.0-only.txt")
set(CPACK_RESOURCE_FILE_README "${PROJECT_SOURCE_DIR}/README")

if(WIN32)
  set(CPACK_PACKAGE_INSTALL_DIRECTORY "${GCOMPRIS_EXECUTABLE_NAME}-Qt")
  set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${GCOMPRIS_EXECUTABLE_NAME}-Qt")
  set(CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/installer\\\\gcompris-header.bmp")
  set(CPACK_NSIS_MUI_ICON "${PROJECT_SOURCE_DIR}/installer\\\\GCompris-install.ico")
  set(CPACK_NSIS_MUI_UNIICON "${PROJECT_SOURCE_DIR}/installer\\\\GCompris-uninstall.ico")
  set(CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP "${PROJECT_SOURCE_DIR}/installer\\\\welcome-page.bmp")
  set(CPACK_NSIS_MUI_UNWELCOMEFINISHPAGE_BITMAP "${PROJECT_SOURCE_DIR}/installer\\\\welcome-page.bmp")
  set(CPACK_NSIS_MANIFEST_DPI_AWARE ON)
  set(CPACK_NSIS_EXECUTABLES_DIRECTORY "bin")
  set(CPACK_PACKAGE_EXECUTABLES "${GCOMPRIS_EXECUTABLE_NAME};GCompris")
  set(CPACK_CREATE_DESKTOP_LINKS "${GCOMPRIS_EXECUTABLE_NAME};GCompris")
  set(CPACK_NSIS_MODIFY_PATH "ON")
  set(CPACK_NSIS_URL_INFO_ABOUT "https:\\\\\\\\gcompris.net")
  set(CPACK_NSIS_DISPLAY_NAME "GCompris Educational Software")
  set(CPACK_NSIS_WELCOME_TITLE_3LINES "ON")
  set(CPACK_NSIS_MUI_FINISHPAGE_RUN "${GCOMPRIS_EXECUTABLE_NAME}")
  set(CPACK_PACKAGE_VENDOR "GCompris team")

  set(CPACK_WIX_UPGRADE_GUID "1902A562-DA6F-4E3D-A56F-1B1D4273C724")
  set(CPACK_WIX_PRODUCT_ICON "${PROJECT_SOURCE_DIR}/installer/GCompris-install.ico")
  set(CPACK_WIX_UI_BANNER "${PROJECT_SOURCE_DIR}/installer/gcompris-header-wix.bmp")
  set(CPACK_WIX_UI_DIALOG "${PROJECT_SOURCE_DIR}/installer/welcome-page-wix.bmp")
  set(CPACK_WIX_PROPERTY_ARPURLINFOABOUT "https://gcompris.net")
  set(CPACK_WIX_PROPERTY_ARPCONTACT "support@gcompris.net")
  set(CPACK_WIX_PROGRAM_MENU_FOLDER "GCompris Educational Software")

  # Create shortcuts in menu to be able to launch in software or opengl mode
  list(APPEND CPACK_NSIS_CREATE_ICONS_EXTRA "  CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\GCompris (Safe Mode).lnk' '$INSTDIR\\\\bin\\\\${GCOMPRIS_EXECUTABLE_NAME}.exe' '--renderer=software'")
  list(APPEND CPACK_NSIS_CREATE_ICONS_EXTRA "  CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\GCompris.lnk' '$INSTDIR\\\\bin\\\\${GCOMPRIS_EXECUTABLE_NAME}.exe' '--renderer=direct3d11'")
  string(REPLACE ";" "\n" CPACK_NSIS_CREATE_ICONS_EXTRA "${CPACK_NSIS_CREATE_ICONS_EXTRA}")
else()
  set(CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/images/256-apps-gcompris-qt.png")
endif()

if(APPLE)
  set(CPACK_GENERATOR "DragNDrop")
elseif(WIN32)
  set(CPACK_GENERATOR "NSIS")
else()
  set(CPACK_GENERATOR "STGZ")
endif()
include(CPack)
