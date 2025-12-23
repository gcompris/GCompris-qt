#=============================================================================
# SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================

function(gcompris_create_translation_files)
  set(options)
  set(oneValueArgs)
  set(multiValueArgs FILENAME)
  cmake_parse_arguments(_QM "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  set(rcc_files "")

  # Get all supported locales by GCompris from LanguageList.qml file, excluded the commented ones
  set(locale_filename "${CMAKE_SOURCE_DIR}/src/core/LanguageList.qml")
  if(${_QM_FILENAME} STREQUAL "gcompris_teachers_qt")
    set(locale_filename "${CMAKE_SOURCE_DIR}/src/server/components/ServerLanguageList.qml")
  endif()

  file(STRINGS "${locale_filename}" handledGComprisLocaleList ENCODING UTF-8 REGEX "[^//]{.*UTF-8")
  foreach(localeLine ${handledGComprisLocaleList})
    # We match the pattern locale.UTF-8
    string(REGEX MATCH ".*\"([a-zA-Z_@]*)\.UTF-8.*" _ ${localeLine})
    set(localeFull ${CMAKE_MATCH_1})
    list(APPEND gcomprisLocales ${localeFull})
    # Add simplified locale
    string(REGEX MATCH "([a-zA-Z@]*)_.*" _ ${localeFull})
    set(localeShort ${CMAKE_MATCH_1})
    list(APPEND gcomprisLocales ${localeShort})
  endforeach()
  # Remove all duplicated shortened locales
  list(REMOVE_DUPLICATES gcomprisLocales)

  # Get all po files in poqm/
  file(GLOB TRANSLATIONS_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "poqm/*/${_QM_FILENAME}.po")
  foreach(PoSource ${TRANSLATIONS_FILES})
    # Get the locale
    string(REGEX MATCH "poqm/([a-zA-Z@_\-]*)/${_QM_FILENAME}.po" _ ${PoSource})
    set(locale ${CMAKE_MATCH_1})

    # search in the languages list the line corresponding to the locale. If exists, then add the custom_command
    if(NOT ${locale} IN_LIST gcomprisLocales)
      list(APPEND unsupported_languages ${locale})
      continue()
    endif()
    list(APPEND supported_languages ${locale})

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

  list(JOIN supported_languages ", " supported_str)
  list(JOIN unsupported_languages ", " unsupported_str)
  message(STATUS "Supported locales for ${_QM_FILENAME}: ${supported_str}")
  message(STATUS "Unsupported locales for ${_QM_FILENAME}: ${unsupported_str} (we have a po file but not enough translated)")
endfunction()
