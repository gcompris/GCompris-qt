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

function(getQtPluginsPath _path)
  get_target_property(_plugin_path Qt5::QMinimalIntegrationPlugin LOCATION)
  string(REGEX REPLACE "(.*/plugins)/.*" "\\1" _plugin_root ${_plugin_path})
  set(${_path} ${_plugin_root} PARENT_SCOPE)
endfunction()

function(getQtQmlPath _path)
  getQtPluginsPath(_qt_plugins_path)
  get_filename_component(_root ${_qt_plugins_path} PATH)
  set(${_path} ${_root}/qml PARENT_SCOPE)
endfunction()

function(installQtPlugin _plugin _dest_dir _lib)
  getQtPluginPaths(${_plugin} _absolute_path _plugin_subdir _plugin_file)
  install(FILES ${_absolute_path} DESTINATION ${_dest_dir}/${_plugin_subdir})
  set(_lib "\${CMAKE_INSTALL_PREFIX}/${_dest_dir}/${_plugin_subdir}/${_plugin_file}" PARENT_SCOPE)
endfunction()

function(installQmlPlugin _plugin _dest_dir _lib )
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
