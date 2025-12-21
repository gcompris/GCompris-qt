#=============================================================================
# SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================

function(gcompris_create_translation_files)
  set(options)
  set(oneValueArgs)
  set(multiValueArgs FILENAME LOG)
  cmake_parse_arguments(_QM "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  set(rcc_files "")
  # Get all po files in poqm/
  file(GLOB TRANSLATIONS_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "poqm/*/${_QM_FILENAME}.po")
  foreach(PoSource ${TRANSLATIONS_FILES})
    # Get the locale
    string(REGEX MATCH "poqm/([a-zA-Z@_\-]*)/${_QM_FILENAME}.po" _ ${PoSource})
    set(locale ${CMAKE_MATCH_1})

    # search in src/core/LanguageList the line corresponding to the locale. If exists, then add the custom_command
    if(NOT ${locale} IN_LIST gcomprisLocales)
      if(${_QM_LOG})
        message(STATUS "Locale ${locale} not supported by GCompris")
      endif()
      continue()
    endif()
    if(${_QM_LOG})
      message(STATUS "Locale ${locale} is supported by GCompris")
    endif()

    # Changes the .po extension to .ts
    string(REPLACE ".po" ".ts" TsSource ${PoSource})
    # Append the locale to the translation file
    string(REPLACE "\." "_${locale}\." TsSource ${TsSource})
    # Removes the poqm/${locale} folder prefix
    string(REPLACE "poqm/${locale}/" "" TsSource ${TsSource})
    # qm extension filename
    string(REPLACE ".ts" ".qm" QmOutput ${TsSource})

    set(OutTsFile ${CMAKE_BINARY_DIR}/tmp/${TsSource})

    add_custom_command(
      OUTPUT ${QmOutput}
      COMMAND cmake -E make_directory ${GCOMPRIS_TRANSLATIONS_DIR}
      COMMAND cmake -E make_directory ${CMAKE_BINARY_DIR}/tmp
      # Remove the obsolete translations and set po in the ts output file
      COMMAND msgattrib --no-obsolete  ${CMAKE_CURRENT_SOURCE_DIR}/${PoSource} -o ${OutTsFile}
      # Convert the po into ts
      COMMAND ${QT_MAJOR}::lconvert -if po -of ts -i ${OutTsFile} -o ${OutTsFile}
      # Convert the ts in qm removing non finished translations
      COMMAND ${QT_MAJOR}::lrelease -removeidentical -nounfinished ${OutTsFile} -qm ${GCOMPRIS_TRANSLATIONS_DIR}/${QmOutput}
      )
    list(APPEND QM_FILES ${QmOutput})
  endforeach()

  # Install translations
  add_custom_target(BuildTranslations${_QM_FILENAME} ALL
    DEPENDS ${QM_FILES}
  )
endfunction()
