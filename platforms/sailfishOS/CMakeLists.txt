
# Fill spec file with all the translation and rcc files
foreach(QM_FILE ${QM_FILES})
  list(APPEND TRANSLATION_OUTPUT_FILES \"/usr/${_data_dest_dir}/translations/${QM_FILE}\")
endforeach()

set(TRANSLATION_GENERATED_FILES "")
if(TRANSLATION_OUTPUT_FILES)
  string(REPLACE "\"\"" "\"\n\"" TRANSLATION_GENERATED_FILES ${TRANSLATION_OUTPUT_FILES})
endif()

# is there a better way to get all the activity rcc files?
get_cmake_property(_variableNames VARIABLES)
foreach(_variableName ${_variableNames})
  string(FIND ${_variableName} "USE_" isActivity)
  # return the index if found, -1 else. We look for string that starts with USE_ so 0.
  if(NOT ${isActivity})
    string(SUBSTRING ${_variableName} 4 -1 filename)
    list(APPEND RCC_OUTPUT_FILES \"/usr/${_data_dest_dir}/rcc/${filename}.rcc\")
  endif()
endforeach()
list(APPEND RCC_OUTPUT_FILES \"/usr/${_data_dest_dir}/rcc/menu.rcc\")
list(APPEND RCC_OUTPUT_FILES \"/usr/${_data_dest_dir}/rcc/core.rcc\")  
list(APPEND RCC_OUTPUT_FILES \"/usr/${_data_dest_dir}/rcc/activities.rcc\")
string(REPLACE "\"\"" "\"\n\"" RCC_GENERATED_FILES ${RCC_OUTPUT_FILES})

configure_file(${PROJECT_SOURCE_DIR}/platforms/sailfishOS/harbour-gcompris-qt.spec.cmake ${CMAKE_BINARY_DIR}/harbour-gcompris-qt.spec @ONLY)
