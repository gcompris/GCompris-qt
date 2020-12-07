#=============================================================================
# SPDX-FileCopyrightText: 2020 Lionel Duboeuf <lduboeuf@ouvaton.org>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
message("Building for Ubuntu Touch")
add_definitions(-DUBUNTUTOUCH)

# Get Architecture triplet
if(DEFINED ENV{ARCH})
    set(CLICK_ARCH "$ENV{ARCH}")
else()
    execute_process(
        COMMAND dpkg-architecture -qDEB_HOST_ARCH
        OUTPUT_VARIABLE CLICK_ARCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

configure_file(manifest.json.in ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION /)
install(FILES gcompris.apparmor DESTINATION /)
install(FILES gcompris.png DESTINATION /)
install(FILES gcompris.desktop DESTINATION /)
