#=============================================================================
# SPDX-FileCopyrightText: 2018 Himanshu Vishwakarma <himvish997@gmail.com>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
find_package(Qt5 REQUIRED COMPONENTS Test)

include_directories(${CMAKE_SOURCE_DIR} "${CMAKE_BINARY_DIR}/src/core/")

set(CORE_TEST_LIBRARIES
    gcompris_core
    Qt5::Core
    Qt5::Test
)

ecm_add_tests(ActivityInfoTest.cpp
              ApplicationSettingsTest.cpp
              DatasetTest.cpp
              DirectoryTest.cpp
              FileTest.cpp
              ApplicationInfoTest.cpp
              DownloadManagerTest.cpp
              # add new test file here
              NAME_PREFIX Core
              LINK_LIBRARIES ${CORE_TEST_LIBRARIES})
