
add_subdirectory(menu)

# Read the activities.txt file
file(READ activities.txt ACTIVITIES)
# Split the output on a list containing each line
string(REGEX REPLACE ";" "\\\\;" ACTIVITIES "${ACTIVITIES}")
string(REGEX REPLACE "\n" ";" ACTIVITIES "${ACTIVITIES}")
file(REMOVE "activities_out.txt")

add_custom_target(all_activities)

foreach(ACTIVITY ${ACTIVITIES})
  # For each line found, we remove comments
  string(FIND "${ACTIVITY}" "#" match)
  if(${match})
    file(STRINGS "${ACTIVITY}/ActivityInfo.qml" demoline REGEX "demo:[ ]+")
    string(REGEX REPLACE ".*demo:.*(true|false).*" "\\1" demo "${demoline}" )
    set(DEFAULT_MODE ON)
    if((${WITH_DEMO_ONLY}) AND (${demo} STREQUAL "false"))
      set(DEFAULT_MODE OFF)
    endif()
    # Set activities as options (enabled by default)
    option("USE_${ACTIVITY}" "Enable ${ACTIVITY} activity" ${DEFAULT_MODE})
    if(USE_${ACTIVITY})
      # Add the directory for compilation
      add_subdirectory(${ACTIVITY})
      file(APPEND "activities_out.txt" "${ACTIVITY}\n")
      add_dependencies(all_activities "rcc_${ACTIVITY}")
    endif()
  endif(${match})
endforeach(ACTIVITY ${ACTIVITIES})

GCOMPRIS_ADD_RCC(activities activities_out.txt)
