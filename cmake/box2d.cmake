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
    find_library(QML_BOX2D_LIBRARY NAMES Box2D libBox2D PATHS ${_box2d_system_dir} NO_DEFAULT_PATH)
    # Look in default path if not found
    if(NOT QML_BOX2D_LIBRARY AND NOT "${CMAKE_FIND_ROOT_PATH}" STREQUAL "")
      # Remove the root path to look for the library
      set(_box2d_without_cmake_find_root_path)
      string(REPLACE "${CMAKE_FIND_ROOT_PATH}" "" _box2d_without_cmake_find_root_path ${_box2d_system_dir})
      find_library(QML_BOX2D_LIBRARY NAMES Box2D libBox2D PATHS ${_box2d_without_cmake_find_root_path})
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

    set(_box2d_source_dir ${CMAKE_CURRENT_SOURCE_DIR}/external/qml-box2d)
    if(WIN32)
      set(_box2d_library_dir "bin/plugins/Box2D/")
      set(_box2d_library_file "qmlbox2d.dll")
    elseif(CMAKE_HOST_APPLE)
      set(_box2d_library_dir "bin/plugins/Box2D/")
      set(_box2d_library_file "libqmlbox2d.dylib")
    elseif(ANDROID)
      set(_box2d_library_dir "bin/plugins/Box2D/")
      set(_box2d_library_file "libqml_Box2D_qmlbox2d_${ANDROID_ABI}.so")
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

    set(BOX2D_MAKE_PROGRAM ${CMAKE_MAKE_PROGRAM})

    if(CMAKE_TOOLCHAIN_FILE)
      set(EXTRA_BOX2D_CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE})
    endif()
    if(ANDROID)
      # I didn't find a better way to copy the libraries to the lib folder only on Android when doing an aab package...
      #set(EXTRA_INSTALL_ANDROID_BOX2D ${CMAKE_COMMAND} -E make_directory ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} && ${CMAKE_COMMAND} -E copy ${_box2d_library_dir}${_box2d_library_file} ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} && )
      set(EXTRA_BOX2D_CMAKE_ARGS ${EXTRA_BOX2D_CMAKE_ARGS} -DANDROID_ABI=${ANDROID_ABI})
      # Strip box2d library for Android
      set(EXTRA_INSTALL_ANDROID_BOX2D ${LLVM_STRIP} --strip-all ${_box2d_library_dir}${_box2d_library_file} && )
    endif()

    ExternalProject_Add(qml_box2d
      DOWNLOAD_COMMAND ""
      CMAKE_ARGS ${EXTRA_BOX2D_CMAKE_ARGS} -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH} -DQt6_DIR=${Qt6_DIR} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DBUILD_EXAMPLES=OFF
      SOURCE_DIR ${_box2d_source_dir}
      BUILD_COMMAND ${BOX2D_MAKE_PROGRAM}
      INSTALL_DIR ${_box2d_install_dir}
      INSTALL_COMMAND ${EXTRA_INSTALL_ANDROID_BOX2D} ${CMAKE_COMMAND} -E copy ${_box2d_library_dir}${_box2d_library_file} ${_box2d_library_dir}/qmldir ${_box2d_install_dir}
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
