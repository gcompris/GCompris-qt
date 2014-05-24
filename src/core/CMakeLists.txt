include(qt_helper)

configure_file(config.h.in "${CMAKE_CURRENT_BINARY_DIR}/config.h" @ONLY)

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
)

qt5_wrap_cpp(gcompris_MOC ${gcompris_SRCS})

# Add files that do no need to pass through the moc processor
set(gcompris_SRCS
   ${gcompris_SRCS}
   main.cpp
   config.h.in
)

include_directories(
  "${CMAKE_CURRENT_BINARY_DIR}"   # to find config.h
)

if(ANDROID)
  add_library(GCompris SHARED ${gcompris_SRCS} ${gcompris_MOC})
  qt5_use_modules(GCompris Qml Quick Gui Multimedia Core Svg XmlPatterns)
else()
  add_executable(GCompris MACOSX_BUNDLE ${gcompris_SRCS} ${gcompris_MOC})
  qt5_use_modules(GCompris Qml Quick Gui Multimedia Network XmlPatterns Svg Core)
endif()

target_link_libraries(GCompris ${QT_LIBRARIES})

install(TARGETS GCompris
  ARCHIVE DESTINATION bin
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  BUNDLE DESTINATION .)

# Qt plugins to install
set(_qt_plugins Qt5::QSvgPlugin Qt5::QJpegPlugin Qt5::QTgaPlugin Qt5::QTiffPlugin)
if(CMAKE_HOST_APPLE)
  list(APPEND _qt_plugins Qt5::QCocoaIntegrationPlugin)
elseif(CMAKE_HOST_WIN32)
  list(APPEND _qt_plugins Qt5::QWindowsIntegrationPlugin)
endif()

# Qml plugins to install
if(CMAKE_HOST_WIN32)
  set(_lib_prefix "")
else()
  set(_lib_prefix "lib")
endif()

set(_qml_plugins
  QtQuick/Controls/${_lib_prefix}qtquickcontrolsplugin
  QtQuick/Window.2/${_lib_prefix}windowplugin
  QtQuick/Particles.2/${_lib_prefix}particlesplugin
  QtQuick/Layouts/${_lib_prefix}qquicklayoutsplugin
  QtQuick/Dialogs/${_lib_prefix}dialogplugin
  QtQuick.2/${_lib_prefix}qtquick2plugin
  QtMultimedia/${_lib_prefix}declarative_multimedia)

set(GCOMPRIS_OTHER_LIBS)

if(CMAKE_HOST_APPLE)
  set(_app GCompris.app)
  set(_qtconf_destdir ${_app}/Contents/Resources)
  set(_qt_plugins_destdir ${_app}/Contents/plugins)
  set(_qt_qml_destdir ${_app}/Contents/qml)
  set(GCOMPRIS_BUNDLE "${CMAKE_INSTALL_PREFIX}/${_app}")
else()
  set(_qtconf_destdir bin)
  set(_qt_plugins_destdir bin/plugins)
  set(_qt_qml_destdir bin/qml)
  if(CMAKE_HOST_WIN32)
    set(GCOMPRIS_BUNDLE "${CMAKE_INSTALL_PREFIX}/bin/GCompris.exe")
  else()
    set(GCOMPRIS_BUNDLE "${CMAKE_INSTALL_PREFIX}/bin/GCompris")
  endif()
endif()

# install qt.conf file
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/qt.conf DESTINATION ${_qtconf_destdir})

# install qt plugins
foreach(_plugin ${_qt_plugins})
  installQtPlugin(${_plugin} ${_qt_plugins_destdir} _lib)
  list(APPEND GCOMPRIS_OTHER_LIBS ${_lib})
endforeach()

# install qml plugins
foreach(_plugin ${_qml_plugins})
  installQmlPlugin(${_plugin} ${_qt_qml_destdir} _lib)
  list(APPEND GCOMPRIS_OTHER_LIBS ${_lib})
endforeach()

# install fixup_bundle script to resolve and fixup runtime dependencies
configure_file(${CMAKE_MODULE_PATH}/FixBundle.cmake.in FixBundle.cmake)
install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake)

GCOMPRIS_ADD_RCC(core *.qml *.js resource/*.* resource/bonus/* resource/sounds/*)
