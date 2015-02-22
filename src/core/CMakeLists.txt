include(qt_helper)

configure_file(config.h.in "${CMAKE_CURRENT_BINARY_DIR}/config.h" @ONLY)

if(WITH_ACTIVATION_CODE)
  add_definitions(-DWITH_ACTIVATION_CODE)
endif()

if(WITH_KIOSK_MODE)
  add_definitions(-DWITH_KIOSK_MODE)
endif()

# Note: put .cpp files before .h files in the following or cmake messes up
# moc generation -- WTF! 
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
   DownloadManager.cpp
   DownloadManager.h
)

qt5_wrap_cpp(gcompris_MOC ${gcompris_SRCS})

# Add files that do no need to pass through the moc processor
set(gcompris_SRCS
   ${gcompris_SRCS}
   main.cpp
   config.h.in
)

if(WITH_ACTIVATION_CODE AND ANDROID)
  list(APPEND gcompris_SRCS ApplicationSettingsAndroid.cpp)
else()
  list(APPEND gcompris_SRCS ApplicationSettingsDefault.cpp)
endif()

include_directories(
  "${CMAKE_CURRENT_BINARY_DIR}"   # to find config.h
)

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
  set(gcompris_RES
    ${GCOMPRIS_RESOURCES}/${gcompris_icon}
  )
endif()

if(ANDROID)
  add_library(${GCOMPRIS_EXECUTABLE_NAME} SHARED ${gcompris_SRCS} ${gcompris_MOC})
  qt5_use_modules(${GCOMPRIS_EXECUTABLE_NAME} Qml Quick Gui Multimedia Core Svg Xml XmlPatterns AndroidExtras)
else()
  add_executable(${GCOMPRIS_EXECUTABLE_NAME} MACOSX_BUNDLE ${gcompris_SRCS} ${gcompris_MOC} ${gcompris_RES})
  qt5_use_modules(${GCOMPRIS_EXECUTABLE_NAME} Qml Quick Gui Multimedia Network XmlPatterns Svg Xml Core)
endif()

target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} ${QT_LIBRARIES})

GCOMPRIS_ADD_RCC(core *.qml *.js resource/*.* resource/bonus/* resource/sounds/* resource/fonts/* qmldir)

# Installation
# ============

install(TARGETS ${GCOMPRIS_EXECUTABLE_NAME}
  ARCHIVE DESTINATION bin
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  BUNDLE DESTINATION .)

if(BUILD_STANDALONE)
  # Qt plugins to install
  set(_qt_plugins Qt5::QJpegPlugin)
  if(APPLE)
    list(APPEND _qt_plugins Qt5::QTgaPlugin Qt5::QTiffPlugin Qt5::QCocoaIntegrationPlugin)
  elseif(WIN32)
    list(APPEND _qt_plugins Qt5::QWindowsIntegrationPlugin)
  elseif(UNIX AND NOT ANDROID)
    list(APPEND _qt_plugins Qt5::QXcbIntegrationPlugin)
  endif()

  # Qml plugins to install
  if(WIN32)
    set(_lib_prefix "")
  else()
    set(_lib_prefix "lib")
  endif()

  set(_qt_plugins2 imageformats/${_lib_prefix}qsvg)
  if(UNIX AND NOT ANDROID)
    list(APPEND _qt_plugins2 mediaservice/${_lib_prefix}gstaudiodecoder
      mediaservice/${_lib_prefix}gstcamerabin
      mediaservice/${_lib_prefix}gstmediacapture
      mediaservice/${_lib_prefix}gstmediaplayer)
  endif()

  set(_qml_plugins
    QtQuick/Controls/${_lib_prefix}qtquickcontrolsplugin
    QtQuick/Window.2/${_lib_prefix}windowplugin
    QtQuick/Particles.2/${_lib_prefix}particlesplugin
    QtQuick/Layouts/${_lib_prefix}qquicklayoutsplugin
    QtQuick.2/${_lib_prefix}qtquick2plugin
    QtMultimedia/${_lib_prefix}declarative_multimedia)

  if(NOT WIN32)
    list(APPEND QtAudioEngine/${_lib_prefix}declarative_audioengine)
  endif()

  set(GCOMPRIS_OTHER_LIBS)

  if(APPLE)
    set(_app gcompris-qt.app)
    set(_qtconf_destdir ${_app}/Contents/Resources)
    set(_qt_plugins_destdir ${_app}/Contents/plugins)
    set(_qt_qml_destdir ${_app}/Contents/qml)
    set(GCOMPRIS_BUNDLE "\${CMAKE_INSTALL_PREFIX}/${_app}")
    set_target_properties(gcompris-qt PROPERTIES
      MACOSX_BUNDLE_INFO_STRING "${GCOMPRIS_VERSION}, Copyright 2000-2014 Bruno Coudoin and Others"
      MACOSX_BUNDLE_ICON_FILE "${gcompris_icon}"
      MACOSX_BUNDLE_GUI_IDENTIFIER "net.gcompris"
      MACOSX_BUNDLE_LONG_VERSION_STRING "${GCOMPRIS_MAJOR_VERSION}.${GCOMPRIS_MINOR_VERSION}.${GCOMPRIS_PATCH_VERSION}"
      MACOSX_BUNDLE_BUNDLE_NAME "gcompris-qt"
      MACOSX_BUNDLE_SHORT_VERSION_STRING "${GCOMPRIS_VERSION}"
      MACOSX_BUNDLE_BUNDLE_VERSION "${GCOMPRIS_VERSION}"
      MACOSX_BUNDLE_COPYRIGHT "Copyright 2000-2014 Bruno Coudoin and Others.")
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
    installQtPlugin2(${_plugin} ${_qt_plugins_destdir} _lib)
    list(APPEND GCOMPRIS_OTHER_LIBS ${_lib})
  endforeach()

  # install qml plugins
  foreach(_plugin ${_qml_plugins})
    installQmlPlugin(${_plugin} ${_qt_qml_destdir} _lib)
    list(APPEND GCOMPRIS_OTHER_LIBS ${_lib})
  endforeach()

  # install QtGraphicalEffects (which is not a lib but only qml files)
  set(_qml_subdir QtGraphicalEffects)
  getQtQmlPath(_qt_qml_path)
  install(DIRECTORY ${_qt_qml_path}/QtGraphicalEffects DESTINATION ${_qt_qml_destdir})
endif(BUILD_STANDALONE)

# Hack: do not fixup Qt and Qml plugins on Windows because fixup_bundle takes ages (cmake bug ?) -> Johnny : we need this even if it takes time because some required dependencies are pulled here
#if(WIN32) set(GCOMPRIS_OTHER_LIBS "") endif()

# install fixup_bundle script to resolve and fixup runtime dependencies
if(BUILD_STANDALONE)
  configure_file(${CMAKE_SOURCE_DIR}/cmake/FixBundle.cmake.in FixBundle.cmake)
  install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake)

  # install a startup script for linux bundle
  if(UNIX)
    install(PROGRAMS ../../tools/gcompris-qt.sh DESTINATION bin)
  endif()
endif()

# Packaging
# =========

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "GCompris is a high quality educational software suite comprising of numerous activities for children aged 2 to 10.")
set(CPACK_PACKAGE_VERSION_MAJOR ${GCOMPRIS_MAJOR_VERSION})
set(CPACK_PACKAGE_VERSION_MINOR ${GCOMPRIS_MINOR_VERSION})
set(CPACK_PACKAGE_VERSION_PATCH ${GCOMPRIS_PATCH_VERSION})
set(CPACK_PACKAGE_VERSION ${GCOMPRIS_VERSION})
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/COPYING")
set(CPACK_RESOURCE_FILE_README "${PROJECT_SOURCE_DIR}/README")

if(WIN32)
  set(CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/installer\\\\gcompris-header.bmp")
  set(CPACK_NSIS_MUI_ICON "${PROJECT_SOURCE_DIR}/installer\\\\GCompris-install.ico")
  set(CPACK_NSIS_MUI_UNIICON "${PROJECT_SOURCE_DIR}/installer\\\\GCompris-uninstall.ico")
  set(CPACK_NSIS_EXECUTABLES_DIRECTORY "bin")
  set(CPACK_PACKAGE_EXECUTABLES "${GCOMPRIS_EXECUTABLE_NAME}" "${GCOMPRIS_EXECUTABLE_NAME}")
else(WIN32)
  set(CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/GCompris64.png")
endif()

if(APPLE)
  set(CPACK_GENERATOR "DragNDrop")
  set(CPACK_DMG_DS_STORE "${GCOMPRIS_RESOURCES}/dmg_DS_Store")
  set(CPACK_DMG_BACKGROUND_IMAGE "${GCOMPRIS_RESOURCES}/dmg_background.png")
elseif(WIN32)
  set(CPACK_GENERATOR "NSIS")
else()
  set(CPACK_GENERATOR "STGZ")
endif()
include(CPack)
