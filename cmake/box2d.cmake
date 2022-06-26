#=============================================================================
# SPDX-FileCopyrightText: 2018 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================

set(QML_BOX2D_MODULE "auto" CACHE STRING "Policy for qml-box2d module [auto|submodule|system|disabled]")

if(NOT ${QML_BOX2D_MODULE} STREQUAL "disabled")
  include(qt_helper)

  getQtQmlPath(_qt_qml_system_path)
  set(_box2d_system_dir "${_qt_qml_system_path}/Box2D.2.0")

  if(${QML_BOX2D_MODULE} STREQUAL "submodule")
    message(STATUS "Building qml-box2d module from submodule")
    set(_need_box2d_submodule "TRUE")
  else()
    # try to find module in system scope
    find_library(QML_BOX2D_LIBRARY NAMES Box2D libBox2D qmlbox2d PATHS ${_box2d_system_dir} NO_DEFAULT_PATH)
    # Look in default path if not found
    if(NOT QML_BOX2D_LIBRARY AND NOT "${CMAKE_FIND_ROOT_PATH}" STREQUAL "")
      # Remove the root path to look for the library
      set(_box2d_without_cmake_find_root_path)
      string(REPLACE "${CMAKE_FIND_ROOT_PATH}" "" _box2d_without_cmake_find_root_path ${_box2d_system_dir})
      find_library(QML_BOX2D_LIBRARY NAMES Box2D libBox2D qmlbox2d PATHS ${_box2d_without_cmake_find_root_path})
    endif()

    if(QML_BOX2D_LIBRARY)
      message(STATUS "Using system qml-box2d plugin at ${QML_BOX2D_LIBRARY}")
      # for packaging builds, copy the module manually to the correct location
      if(ANDROID)
        file(COPY ${_box2d_system_dir}/qmldir ${QML_BOX2D_LIBRARY} DESTINATION lib/qml/Box2D.2.0)
      endif()
      # FIXME: add others as needed
    else()
      if(${QML_BOX2D_MODULE} STREQUAL "auto")
        message(STATUS "Did not find the qml-box2d module in system scope, falling back to submodule build ...")
        set(_need_box2d_submodule "TRUE")
      else()
        message(FATAL_ERROR "Did not find the qml-box2d module in system scope and submodule build was not requested. Can't continue!")
      endif()
    endif()
  endif()

  if(_need_box2d_submodule)
    # build qml-box2d ourselves from submodule
    include(ExternalProject)
    get_property(_qmake_program TARGET Qt5::qmake PROPERTY IMPORT_LOCATION)

    set(_box2d_source_dir ${CMAKE_CURRENT_SOURCE_DIR}/external/qml-box2d)
    if(WIN32)
      set(_box2d_library_dir "bin/plugins/Box2D/")
      set(_box2d_library_file "qmlbox2d.dll")
    elseif(CMAKE_HOST_APPLE)
      set(_box2d_library_dir "bin/plugins/Box2D/")
      set(_box2d_library_file "libqmlbox2d.dylib")
    elseif(ANDROID AND Qt5Widgets_VERSION VERSION_GREATER_EQUAL "5.14.0")
      set(_box2d_library_dir "bin/plugins/Box2D/")
      set(_box2d_library_file "libqmlbox2d_${ANDROID_ABI}.so")
    else()
      set(_box2d_library_dir "bin/plugins/Box2D/")
      set(_box2d_library_file "libqmlbox2d.so")
    endif()
    set(_box2d_install_dir ${CMAKE_CURRENT_BINARY_DIR}/lib/qml/Box2D.2.0)
    # make sure submodule is up2date
    find_package(Git)
    if(GIT_FOUND)
      execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    endif()

    if(ANDROID)
      list(APPEND EXTRA_CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH} -DANDROID_ABI=${ANDROID_ABI} -DANDROID_PLATFORM=${ANDROID_PLATFORM} -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DQML_BOX2D_MODULE=${QML_BOX2D_MODULE} -DQt5_DIR=${Qt5_DIR})
      if(Qt5Widgets_VERSION VERSION_GREATER_EQUAL "5.14.0")
        list(APPEND EXTRA_CMAKE_ARGS -DCMAKE_SHARED_LIBRARY_SUFFIX_CXX=_${ANDROID_ABI}.so -DCMAKE_SHARED_MODULE_SUFFIX_CXX=_${ANDROID_ABI}.so -DCMAKE_SHARED_LIBRARY_SUFFIX_C=_${ANDROID_ABI}.so -DCMAKE_SHARED_MODULE_SUFFIX_C=_${ANDROID_ABI}.so)
        # I didn't find a better way to copy the libraries to the lib folder only on Android when doing an aab package...
        set(EXTRA_INSTALL_ANDROID_BOX2D ${CMAKE_COMMAND} -E make_directory ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} && ${CMAKE_COMMAND} -E copy ${_box2d_library_dir}${_box2d_library_file} ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} && )
      endif()
    endif()

    ExternalProject_Add(qml_box2d
      DOWNLOAD_COMMAND ""
      SOURCE_DIR ${_box2d_source_dir}
      BUILD_ALWAYS YES
      CMAKE_ARGS -DUSE_QT6=OFF -DBUILD_EXAMPLES=OFF -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} ${EXTRA_CMAKE_ARGS}
      INSTALL_DIR ${_box2d_install_dir}
      INSTALL_COMMAND ${EXTRA_INSTALL_ANDROID_BOX2D} ${CMAKE_COMMAND} -E copy ${_box2d_library_dir}${_box2d_library_file} ${_box2d_source_dir}/qmldir ${_box2d_install_dir}
      )

    add_library(qml-box2d SHARED IMPORTED)
    set_target_properties(qml-box2d PROPERTIES IMPORTED_LOCATION ${_box2d_install_dir}/${_box2d_library_file})

    if(APPLE)
      install(DIRECTORY ${_box2d_install_dir} DESTINATION gcompris-qt.app/Contents/lib/qml)
    else()
      install(DIRECTORY ${_box2d_install_dir} DESTINATION lib/qml)
    endif()
  endif()
endif()
