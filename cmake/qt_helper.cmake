#=============================================================================
# SPDX-FileCopyrightText: 2014 Thibaut ROMAIN <thibrom@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
function(getQtPluginPaths _plugin_target _absolute_path _subdir _file)
  getQtPluginsPath(_qt_plugins_path)
  get_target_property(_plugin_path ${_plugin_target} LOCATION)
  if(NOT _plugin_path)
    message(FATAL_ERROR "Could not find ${_plugin_target} plugin path")
  endif()
  get_filename_component(_plugin_file ${_plugin_path} NAME)
  get_filename_component(_plugin_dir ${_plugin_path} PATH)
  file(RELATIVE_PATH _plugin_subdir ${_qt_plugins_path} ${_plugin_dir})
  set(${_absolute_path} ${_plugin_path} PARENT_SCOPE)
  set(${_subdir} ${_plugin_subdir} PARENT_SCOPE)
  set(${_file} ${_plugin_file} PARENT_SCOPE)
endfunction()

# Determine Qt5's plugin-path deriving from lib-dir and trying different
# locations corresponding to different directory layouts, e.g.:
#
# Debian:
#   /usr/lib/i386-linux-gnu/libQt5Qml.so.5.4.1
#   /usr/lib/i386-linux-gnu/qt5/plugins/
# Opensuse:
#   /usr/lib64/libQt5Multimedia.so.5
#   /usr/lib64/qt5/plugins/
# Qt installer:
#   /opt/Qt5.5.1/5.5/gcc/lib/libQt5Qml.so.5.5.1
#   /opt/Qt5.5.1/5.5/gcc/plugins/
#
# The qml/-dir is always a sibling of the plugins/ dir.
function(getQtPluginsPath _path)
  get_target_property(_lib_file Qt5::Qml LOCATION)
  get_filename_component(_lib_dir ${_lib_file} PATH)
  # try $_lib_dir/qt5/plugins (Debian/Opensuse)
  set(_plugin_root ${_lib_dir}/qt5/plugins)
  if(NOT IS_DIRECTORY ${_plugin_root})
    # try $_lib_dir/../plugins (Qt installer)
    get_filename_component(_lib_dir_base ${_lib_dir} PATH)
    if(APPLE)
      set(_plugin_root ${_lib_dir_base}/../plugins)
    else()
      set(_plugin_root ${_lib_dir_base}/plugins)
    endif()
  endif()
  set(${_path} ${_plugin_root} PARENT_SCOPE)
endfunction()

function(getQtQmlPath _path)
  getQtPluginsPath(_qt_plugins_path)
  get_filename_component(_root ${_qt_plugins_path} PATH)
  set(${_path} ${_root}/qml PARENT_SCOPE)
endfunction()

function(installQtPlugin _plugin _dest_dir _lib)
  getQtPluginPaths(${_plugin} _absolute_path _plugin_subdir _plugin_file)
  #needed to build with msys2
  if(MINGW)
    string(REGEX REPLACE "share/qt5/" "" _plugin_subdir ${_plugin_subdir})
  endif()
  install(FILES ${_absolute_path} DESTINATION ${_dest_dir}/${_plugin_subdir})
  set(_lib "\${CMAKE_INSTALL_PREFIX}/${_dest_dir}/${_plugin_subdir}/${_plugin_file}" PARENT_SCOPE)
endfunction()

function(installQtPlugin2 _plugin _dest_dir _lib)
  get_filename_component(_plugin_file ${_plugin} NAME)
  set(_ext ${CMAKE_SHARED_LIBRARY_SUFFIX})
  get_filename_component(_plugin_subdir ${_plugin} PATH)
  get_filename_component(_plugin_subdir_root ${_plugin_subdir} PATH)
  getQtPluginsPath(_qt_plugin_path)
  install(DIRECTORY ${_qt_plugin_path}/${_plugin_subdir} DESTINATION ${_dest_dir}/${_plugin_subdir_root})
  if(CMAKE_HOST_WIN32)
    set(_dbg_suffix "d")
  else()
    set(_dbg_suffix "_debug")
  endif()
  set(_install_path \${CMAKE_INSTALL_PREFIX}/${_dest_dir}/${_plugin_subdir})
  if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    install(CODE "file(REMOVE \"${_install_path}/${_plugin_file}${_ext}\")")
    set(_plugin_file ${_plugin_file}${_dbg_suffix}${_ext})
  else()
    install(CODE "file(REMOVE \"${_install_path}/${_plugin_file}${_dbg_suffix}${_ext}\")")
    set(_plugin_file ${_plugin_file}${_ext})
  endif()
  set(_lib "${_install_path}/${_plugin_file}" PARENT_SCOPE)
endfunction()

function(installQmlPlugin _plugin _dest_dir _lib)
  get_filename_component(_plugin_file ${_plugin} NAME)
  set(_ext ${CMAKE_SHARED_LIBRARY_SUFFIX})
  get_filename_component(_qml_subdir ${_plugin} PATH)
  get_filename_component(_qml_subdir_root ${_qml_subdir} PATH)
  getQtQmlPath(_qt_qml_path)
  install(DIRECTORY ${_qt_qml_path}/${_qml_subdir} DESTINATION ${_dest_dir}/${_qml_subdir_root})
  if(CMAKE_HOST_WIN32)
    set(_dbg_suffix "d")
  else()
    set(_dbg_suffix "_debug")
  endif()
  set(_install_path \${CMAKE_INSTALL_PREFIX}/${_dest_dir}/${_qml_subdir})
  if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    install(CODE "file(REMOVE \"${_install_path}/${_plugin_file}${_ext}\")")
    set(_plugin_file ${_plugin_file}${_dbg_suffix}${_ext})
  else()
    install(CODE "file(REMOVE \"${_install_path}/${_plugin_file}${_dbg_suffix}${_ext}\")")
    set(_plugin_file ${_plugin_file}${_ext})
  endif()
  set(_lib "${_install_path}/${_plugin_file}" PARENT_SCOPE)
endfunction()
