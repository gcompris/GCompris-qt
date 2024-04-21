#=============================================================================
# SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
function(GCOMPRIS_ADD_RESOURCE resource_path)
  if(WITH_RCC)
    GCOMPRIS_ADD_RCC(${ARGV})
  else()
    GCOMPRIS_ADD_PLUGIN(${ARGV})
  endif()
endfunction()

#
# GCOMPRIS_ADD_RCC(resource_path <file list>)
#
function(GCOMPRIS_ADD_RCC resource_path)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs QML_FILES RESOURCES DEPENDENCIES)
  cmake_parse_arguments(_RCC "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  set(rcc_files "")
  list(APPEND rcc_files ${_RCC_QML_FILES} ${_RCC_RESOURCES})

  get_filename_component(activity "${resource_path}" NAME)

  if(WIN32)
    # (cannot create it in the build dir because rcc expect local files)
    # Create this QRC file
    set(CREATED_QRC "${CMAKE_CURRENT_SOURCE_DIR}/${activity}.qrc")
  else()
    set(CREATED_QRC "${CMAKE_CURRENT_BINARY_DIR}/${activity}.qrc")
  endif()

  set(ACTIVITY_PATH "/gcompris/src/${resource_path}")
  file(GLOB QRC_CONTENTS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${rcc_files})
  file(GLOB QRC_CONTENTS_ABS ${CMAKE_CURRENT_SOURCE_DIR} ${rcc_files})

  file(WRITE ${CREATED_QRC} "<RCC>\n\t<qresource prefix=\"${ACTIVITY_PATH}\">")
  foreach(FILE ${QRC_CONTENTS})
      file(APPEND ${CREATED_QRC} "\n\t\t<file>${FILE}</file>")
  endforeach()
  file(APPEND ${CREATED_QRC} "\n\t</qresource>\n</RCC>\n")
  list(APPEND QRC_FILES ${CREATED_QRC})

  set(CREATED_RCC ${GCOMPRIS_RCC_DIR}/${activity}.rcc)

  if(WIN32)
    set(_RCC_COMMAND ${QT_MAJOR}::rcc "--format-version" 2 "-binary" -o ${CREATED_RCC} ${CREATED_QRC})
  else()
    set(_RCC_COMMAND ${QT_MAJOR}::rcc "--format-version" 2 --compress-algo zlib --no-zstd "-binary" -o ${CREATED_RCC} - < ${CREATED_QRC})
  endif()

  add_custom_command(OUTPUT ${CREATED_RCC}
                     COMMAND ${_RCC_COMMAND}
                     DEPENDS ${QRC_CONTENTS} "${out_depends}" VERBATIM
                     WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

  if(CMAKE_HOST_APPLE)
    install(FILES ${CREATED_RCC} DESTINATION ${GCOMPRIS_EXECUTABLE_NAME}.app/Contents/MacOS/rcc)
  elseif(HAIKU)
    install(FILES ${CREATED_RCC} DESTINATION ${_data_dest_dir}/rcc)
  else()
    install(FILES ${CREATED_RCC} DESTINATION share/${GCOMPRIS_EXECUTABLE_NAME}/rcc)
  endif()

  add_custom_target(
    rcc_${activity} ALL
    DEPENDS createShareFolders ${CREATED_RCC} ${CREATED_QRC}
    COMMENT "Generate ${activity} RCC"
    SOURCES ${QRC_CONTENTS}
    VERBATIM
  )

endfunction()

#
# GCOMPRIS_ADD_PLUGIN(resource_path target <file list>)
#
function(GCOMPRIS_ADD_PLUGIN resource_path)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs QML_FILES RESOURCES DEPENDENCIES)
  cmake_parse_arguments(_RCC "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  get_filename_component(activity "${resource_path}" NAME)

  file(GLOB activity_qml_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${_RCC_QML_FILES})
  file(GLOB activity_resources_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${_RCC_RESOURCES})

  add_library(${activity} SHARED)
  qt_add_qml_module(
    ${activity}
    PLUGIN_TARGET ${activity}
    URI ${activity}
    RESOURCE_PREFIX /gcompris/src/activities/
    VERSION 1.0
    QML_FILES
    ${activity_qml_files}
    RESOURCES
    ${activity_resources_files}
    DEPENDENCIES GCompris ${_RCC_DEPENDENCIES}
    IMPORTS GCompris ${_RCC_DEPENDENCIES}
    OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/qml/${activity}
    #ENABLE_TYPE_COMPILER # todo check if better than qmlcache https://doc.qt.io/qt-6/qt-add-qml-module.html#compiling-qml-to-c-with-qml-type-compiler
    )

  target_link_libraries(${GCOMPRIS_EXECUTABLE_NAME} ${activity})

  install(TARGETS ${activity} DESTINATION lib/qml)
endfunction()
