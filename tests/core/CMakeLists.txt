find_package(Qt5 REQUIRED COMPONENTS Test)

include_directories(${CMAKE_SOURCE_DIR})

set(CORE_TEST_LIBRARIES
    gcompris_core
    Qt5::Core
    Qt5::Test
)

add_executable(CoreActivityInfoTest ActivityInfoTest.cpp)
target_link_libraries(CoreActivityInfoTest ${CORE_TEST_LIBRARIES})
add_test(NAME CoreActivityInfoTest COMMAND $<TARGET_FILE:CoreActivityInfoTest>)
