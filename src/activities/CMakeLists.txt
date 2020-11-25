#=============================================================================
# SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
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
    # Set activities as options (enabled by default)
    option("USE_${ACTIVITY}" "Enable ${ACTIVITY} activity" ON)
    if(USE_${ACTIVITY})
      # Add the directory for compilation
      add_subdirectory(${ACTIVITY})
      file(APPEND "activities_out.txt" "${ACTIVITY}\n")
      add_dependencies(all_activities "rcc_${ACTIVITY}")
    endif()
  endif(${match})
endforeach(ACTIVITY ${ACTIVITIES})

GCOMPRIS_ADD_RCC(activities activities_out.txt)
