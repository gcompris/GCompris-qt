
add_subdirectory(menu)

# Read the activities.txt file
file(READ activities.txt ACTIVITIES)
# Split the output on a list containing each line
string(REGEX REPLACE ";" "\\\\;" ACTIVITIES "${ACTIVITIES}")
string(REGEX REPLACE "\n" ";" ACTIVITIES "${ACTIVITIES}")

foreach(ACTIVITY ${ACTIVITIES})
  # For each line found, we remove comments
  string(FIND "${ACTIVITY}" "#" match)
  if(${match})
    # Set activities as options (enabled by default)
    option("USE_${ACTIVITY}" "Enable ${ACTIVITY} activity" ON)
    if("USE_${ACTIVITY}")
      # Add the directory for compilation
      add_subdirectory(${ACTIVITY})
    endif("USE_${ACTIVITY}")
  endif(${match})
endforeach(ACTIVITY ${ACTIVITIES})

GCOMPRIS_ADD_RCC(activities activities.txt)
