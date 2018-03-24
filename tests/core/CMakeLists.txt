find_package(Qt5 REQUIRED COMPONENTS Test)

include_directories(${CMAKE_SOURCE_DIR} "${CMAKE_BINARY_DIR}/src/core/")

set(CORE_TEST_LIBRARIES
    gcompris_core
    Qt5::Core
    Qt5::Test
)

ecm_add_test(ActivityInfoTest.cpp TEST_NAME CoreActivityInfoTest LINK_LIBRARIES ${CORE_TEST_LIBRARIES})
ecm_add_test(ApplicationSettingsTest.cpp TEST_NAME CoreApplicationSettingsTest LINK_LIBRARIES ${CORE_TEST_LIBRARIES})
