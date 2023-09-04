#=============================================================================
# SPDX-FileCopyrightText: 2016 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
#
# GCOMPRIS_ADD_RCC(resource_path <file list>)
#
function(GCOMPRIS_ADD_RCC resource_path)

  set(options)
  set(oneValueArgs)
  set(multiValueArgs)
  cmake_parse_arguments(_RCC "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  set(rcc_files ${_RCC_UNPARSED_ARGUMENTS})

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
    set(_RCC_COMMAND Qt5::rcc "--format-version" 2 "--binary" -o ${CREATED_RCC} ${CREATED_QRC})
  else()
    set(_RCC_COMMAND Qt5::rcc "--format-version" 2 "--binary" -o ${CREATED_RCC} - < ${CREATED_QRC})
  endif()

  add_custom_command(OUTPUT ${CREATED_RCC}
                     COMMAND ${_RCC_COMMAND}
                     DEPENDS ${QRC_CONTENTS} "${out_depends}" VERBATIM
                     WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

  if(CMAKE_HOST_APPLE)
    install(FILES ${CREATED_RCC} DESTINATION ${GCOMPRIS_EXECUTABLE_NAME}.app/Contents/MacOS/rcc)
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
