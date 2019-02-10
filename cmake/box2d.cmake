
set(QML_BOX2D_MODULE "auto" CACHE STRING "Policy for qml-box2d module [auto|submodule|system|disabled]")

if (NOT ${QML_BOX2D_MODULE} STREQUAL "disabled")
  include(qt_helper)

  getQtQmlPath(_qt_qml_system_path)
  set (_box2d_system_dir "${_qt_qml_system_path}/Box2D.2.0")

  if (${QML_BOX2D_MODULE} STREQUAL "submodule")
    message(STATUS "Building qml-box2d module from submodule")
    set(_need_box2d_submodule "TRUE")
  else()
    # try to find module in system scope
    find_library(QML_BOX2D_LIBRARY NAMES Box2D libBox2D PATHS ${_box2d_system_dir} NO_DEFAULT_PATH)
    if (QML_BOX2D_LIBRARY)
      message(STATUS "Using system qml-box2d plugin at ${QML_BOX2D_LIBRARY}")
      # for packaging builds, copy the module manually to the correct location
      if(SAILFISHOS)
        file(COPY ${_box2d_system_dir}/qmldir ${QML_BOX2D_LIBRARY} DESTINATION share/harbour-gcompris-qt/lib/qml/Box2D.2.0)
      elseif(ANDROID)
        file(COPY ${_box2d_system_dir}/qmldir ${QML_BOX2D_LIBRARY} DESTINATION lib/qml/Box2D.2.0)
      endif()
      # FIXME: add others as needed
    else()
      if (${QML_BOX2D_MODULE} STREQUAL "auto")
        message(STATUS "Did not find the qml-box2d module in system scope, falling back to submodule build ...")
        set (_need_box2d_submodule "TRUE")
      else()
        message(FATAL_ERROR "Did not find the qml-box2d module in system scope and submodule build was not requested. Can't continue!")
      endif()
    endif()
  endif()

  if (_need_box2d_submodule)
    # build qml-box2d ourselves from submodule
    include(ExternalProject)
    get_property(_qmake_program TARGET ${Qt5Core_QMAKE_EXECUTABLE} PROPERTY IMPORT_LOCATION)
    set (_box2d_source_dir ${CMAKE_CURRENT_SOURCE_DIR}/external/qml-box2d)
    if(WIN32)
      set (_box2d_library_dir "release/")
      set (_box2d_library_file "Box2D.dll")
    elseif(CMAKE_HOST_APPLE)
      set (_box2d_library_dir "")
      set (_box2d_library_file "libBox2D.dylib")
    else()
      set (_box2d_library_dir "")
      set (_box2d_library_file "libBox2D.so")
    endif()
    set (_box2d_install_dir ${CMAKE_CURRENT_BINARY_DIR}/lib/qml/Box2D.2.0)
    # make sure submodule is up2date
    find_package(Git)
    if(GIT_FOUND)
      execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    endif()

    # for visual studio, we need to create a vcxproj
    if(WIN32 AND NOT MINGW)
      set(_qmake_options -spec win32-msvc -tp vc)
    else()
      set(_qmake_options "")
    endif()
    ExternalProject_Add(qml_box2d
      DOWNLOAD_COMMAND ""
      SOURCE_DIR ${_box2d_source_dir}
      CONFIGURE_COMMAND ${_qmake_program} ${_qmake_options} ${_box2d_source_dir}/box2d.pro
      BUILD_COMMAND ${CMAKE_MAKE_PROGRAM}
      INSTALL_DIR ${_box2d_install_dir}
      INSTALL_COMMAND cp ${_box2d_library_dir}${_box2d_library_file} ${_box2d_source_dir}/qmldir ${_box2d_install_dir}
      )

    add_library(qml-box2d SHARED IMPORTED)
    set_target_properties(qml-box2d PROPERTIES IMPORTED_LOCATION ${_box2d_install_dir}/${_box2d_library_file})

    if(SAILFISHOS)
      install(DIRECTORY ${_box2d_install_dir} DESTINATION share/harbour-gcompris-qt/lib/qml)
    elseif(APPLE)
      install(DIRECTORY ${_box2d_install_dir} DESTINATION gcompris-qt.app/Contents/lib/qml)
    else()
      install(DIRECTORY ${_box2d_install_dir} DESTINATION lib/qml)
    endif()
  endif()
endif()
