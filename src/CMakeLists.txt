#=============================================================================
# SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
add_subdirectory(activities)
add_subdirectory(core)

if(BUILD_SERVER)
  add_subdirectory(server)
endif(BUILD_SERVER)
