#=============================================================================
# SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
include(qt_helper)

install(TARGETS ${GCOMPRIS_TEACHERS_EXECUTABLE_NAME}
  ARCHIVE DESTINATION bin
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  BUNDLE DESTINATION .)

if(BUILD_STANDALONE)
  # Qt plugins to install
  set(_qt_plugins "")

  set(default_plugins ${QT_MAJOR}::QSvgPlugin ${QT_MAJOR}::QWebpPlugin ${QT_MAJOR}::QGifPlugin ${QT_MAJOR}::genericSensorPlugin ${QT_MAJOR}::QtSensorGesturePlugin ${QT_MAJOR}::QShakeSensorGesturePlugin ${QT_MAJOR}::QSQLiteDriverPlugin)
  if(WIN32)
    set(default_plugins ${default_plugins} ${QT_MAJOR}::QICOPlugin ${QT_MAJOR}::QWindowsIntegrationPlugin ${QT_MAJOR}::QWindowsAudioPlugin ${QT_MAJOR}::AudioCaptureServicePlugin ${QT_MAJOR}::DSServicePlugin)
  elseif(ANDROID)
    set(default_plugins ${default_plugins} ${QT_MAJOR}::QAndroidIntegrationPlugin)
  elseif(APPLE)
    set(default_plugins ${default_plugins} ${QT_MAJOR}::QICNSPlugin ${QT_MAJOR}::QTgaPlugin ${QT_MAJOR}::QTiffPlugin ${QT_MAJOR}::QCocoaIntegrationPlugin)
  else()
    set(default_plugins ${default_plugins} ${QT_MAJOR}::QComposePlatformInputContextPlugin ${QT_MAJOR}::QXcbIntegrationPlugin ${QT_MAJOR}::QXcbEglIntegrationPlugin ${QT_MAJOR}::QXcbGlxIntegrationPlugin ${QT_MAJOR}::QWaylandIntegrationPlugin ${QT_MAJOR}::QWaylandXdgShellIntegrationPlugin ${QT_MAJOR}::QWaylandEglPlatformIntegrationPlugin ${QT_MAJOR}::QWaylandEglClientBufferPlugin)
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
    QtSensors/${_lib_prefix}sensorsquickplugin
    QtCharts/${_lib_prefix}qtchartsqml2plugin
    QtQuick/Controls/${_lib_prefix}qtquickcontrols2plugin
    QtQuick/Templates/${_lib_prefix}qtquicktemplates2plugin
    QtQuick/Layouts/${_lib_prefix}qquicklayoutsplugin
    QtCore/${_lib_prefix}qtqmlcoreplugin
    QtQuick/Dialogs/${_lib_prefix}qtquickdialogsplugin)
  
  set(GCOMPRIS_OTHER_LIBS)

  if(APPLE)
    set(_app gcompris-teachers.app)
    set(_qtconf_destdir ${_app}/Contents/Resources)
    set(_qt_plugins_destdir ${_app}/Contents/plugins)
    set(_qt_qml_destdir ${_app}/Contents/qml)
    set(GCOMPRIS_BUNDLE "\${CMAKE_INSTALL_PREFIX}/${_app}")
    set_target_properties(gcompris-teachers PROPERTIES
      MACOSX_BUNDLE_INFO_STRING "GCompris, Educational game for children 2 to 10"
      MACOSX_BUNDLE_ICON_FILE "${gcompris_icon}"
      MACOSX_BUNDLE_GUI_IDENTIFIER "net.gcompris"
      MACOSX_BUNDLE_LONG_VERSION_STRING "${GCOMPRIS_MAJOR_VERSION}.${GCOMPRIS_MINOR_VERSION}.${GCOMPRIS_PATCH_VERSION}"
      MACOSX_BUNDLE_BUNDLE_NAME "gcompris-teachers"
      MACOSX_BUNDLE_SHORT_VERSION_STRING "${GCOMPRIS_VERSION}"
      MACOSX_BUNDLE_BUNDLE_VERSION "${GCOMPRIS_VERSION}"
      MACOSX_BUNDLE_COPYRIGHT "AGPL-3.0 License, SPDX-FileCopyrightText: 2000-2025 Timothee Giet and Others.")
    set_source_files_properties(${GCOMPRIS_RESOURCES}/${gcompris_icon} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
  else()
    set(_qtconf_destdir bin)
    set(_qt_plugins_destdir bin/plugins)
    set(_qt_qml_destdir bin/qml)
    if(CMAKE_HOST_WIN32)
      set(GCOMPRIS_BUNDLE "\${CMAKE_INSTALL_PREFIX}/bin/${GCOMPRIS_TEACHERS_EXECUTABLE_NAME}.exe")
    else()
      set(GCOMPRIS_BUNDLE "\${CMAKE_INSTALL_PREFIX}/bin/${GCOMPRIS_TEACHERS_EXECUTABLE_NAME}")
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
      target_link_libraries(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} ${ICU_LIBRARIES})
    endif()

    # package OpenSSL libs from system
    install_with_symlinks(FILE ${OPENSSL_SSL_LIBRARY} DESTINATION bin)
    install_with_symlinks(FILE ${OPENSSL_CRYPTO_LIBRARY} DESTINATION bin)
    target_link_libraries(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} OpenSSL::SSL OpenSSL::Crypto)
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
    target_link_libraries(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} OpenSSL::SSL OpenSSL::Crypto)
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
    install(PROGRAMS ../../tools/gcompris-teachers.sh DESTINATION ${CMAKE_INSTALL_BINDIR})
  endif()
endif()


if(WIN32 AND NOT MINGW)
# install libEGL.dll, libGLESv2.dll, d3dcompiler_47.dll from Qt installation. Not sure if there is a clean way to get them...
# Qt6_Dir is like C:/Qt/Qt6.5.3/mingw_64/lib/cmake/Qt6
    #install(FILES ${Qt6_DIR}/../../../bin/libEGL.dll DESTINATION bin)
    #install(FILES ${Qt6_DIR}/../../../bin/libGLESv2.dll DESTINATION bin)
    #install(FILES ${Qt6_DIR}/../../../bin/d3dcompiler_47.dll DESTINATION bin)
    #target_link_libraries(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} ${Qt6_DIR}/../../libEGL.lib)
    #target_link_libraries(${GCOMPRIS_TEACHERS_EXECUTABLE_NAME} ${Qt6_DIR}/../../libGLESv2.lib)
    #install(FILES ${Qt6_DIR}/../../../bin/opengl32sw.dll DESTINATION bin)
    # CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS contains visual c++ libraries
    install(FILES ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} DESTINATION bin)
endif()

# Packaging
# =========

set(CPACK_PACKAGE_NAME "gcompris-teachers")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "GCompris Teachers is an administration tool for teachers to communicate with GCompris devices.")
set(CPACK_PACKAGE_VERSION_MAJOR ${GCOMPRIS_MAJOR_VERSION})
set(CPACK_PACKAGE_VERSION_MINOR ${GCOMPRIS_MINOR_VERSION})
set(CPACK_PACKAGE_VERSION_PATCH ${GCOMPRIS_PATCH_VERSION})
set(CPACK_PACKAGE_VERSION ${GCOMPRIS_VERSION})
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSES/AGPL-3.0-only.txt")
set(CPACK_RESOURCE_FILE_README "${PROJECT_SOURCE_DIR}/README")

if(WIN32)
  set(CPACK_PACKAGE_INSTALL_DIRECTORY "${GCOMPRIS_TEACHERS_EXECUTABLE_NAME}")
  set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${GCOMPRIS_TEACHERS_EXECUTABLE_NAME}")
  set(CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/installer\\\\gcompris-header.bmp")
  set(CPACK_NSIS_MUI_ICON "${PROJECT_SOURCE_DIR}/installer\\\\GCompris-teachers.ico")
  set(CPACK_NSIS_MUI_UNIICON "${PROJECT_SOURCE_DIR}/installer\\\\GCompris-uninstall.ico")
  set(CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP "${PROJECT_SOURCE_DIR}/installer\\\\welcome-page.bmp")
  set(CPACK_NSIS_MUI_UNWELCOMEFINISHPAGE_BITMAP "${PROJECT_SOURCE_DIR}/installer\\\\welcome-page.bmp")
  set(CPACK_NSIS_MANIFEST_DPI_AWARE ON)
  set(CPACK_NSIS_EXECUTABLES_DIRECTORY "bin")
  set(CPACK_PACKAGE_EXECUTABLES "${GCOMPRIS_TEACHERS_EXECUTABLE_NAME};GCompris")
  set(CPACK_CREATE_DESKTOP_LINKS "${GCOMPRIS_TEACHERS_EXECUTABLE_NAME};GCompris")
  set(CPACK_NSIS_MODIFY_PATH "ON")
  set(CPACK_NSIS_URL_INFO_ABOUT "https:\\\\\\\\gcompris.net")
  set(CPACK_NSIS_DISPLAY_NAME "GCompris Teachers tool")
  set(CPACK_NSIS_WELCOME_TITLE_3LINES "ON")
  set(CPACK_NSIS_MUI_FINISHPAGE_RUN "${GCOMPRIS_TEACHERS_EXECUTABLE_NAME}")
  set(CPACK_PACKAGE_VENDOR "GCompris team")

  set(CPACK_WIX_UPGRADE_GUID "1902A562-DA6F-4E3D-A56F-1B1D4273C724")
  set(CPACK_WIX_PRODUCT_ICON "${PROJECT_SOURCE_DIR}/installer/GCompris-teachers.ico")
  set(CPACK_WIX_UI_BANNER "${PROJECT_SOURCE_DIR}/installer/gcompris-header-wix.bmp")
  set(CPACK_WIX_UI_DIALOG "${PROJECT_SOURCE_DIR}/installer/welcome-page-wix.bmp")
  set(CPACK_WIX_PROPERTY_ARPURLINFOABOUT "https://gcompris.net")
  set(CPACK_WIX_PROPERTY_ARPCONTACT "support@gcompris.net")
  set(CPACK_WIX_PROGRAM_MENU_FOLDER "GCompris Educational Software")

  # Create shortcuts in menu
  list(APPEND CPACK_NSIS_CREATE_ICONS_EXTRA "  CreateShortCut '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\GCompris Teachers.lnk' '$INSTDIR\\\\bin\\\\gcompris-teachers.exe'")
  string(REPLACE ";" "\n" CPACK_NSIS_CREATE_ICONS_EXTRA "${CPACK_NSIS_CREATE_ICONS_EXTRA}")
else()
  set(CPACK_PACKAGE_ICON "${PROJECT_SOURCE_DIR}/images/256-apps-gcompris-teachers.png")
endif()

if(APPLE)
  set(CPACK_GENERATOR "DragNDrop")
elseif(WIN32)
  set(CPACK_GENERATOR "NSIS")
else()
  set(CPACK_GENERATOR "STGZ")
endif()
include(CPack)
