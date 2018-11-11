# These tools are run (for now) only if BUILD_TESTING is ON
# Another useful tool could be clazy compiler too

# Run cppcheck on the code
find_program(CMAKE_CXX_CPPCHECK NAMES cppcheck)
if (CMAKE_CXX_CPPCHECK)
    list(
        APPEND CMAKE_CXX_CPPCHECK 
            "--enable=all"
            "--inconclusive"
            "--force" 
            "--inline-suppr"
    )
endif()

# Run clang-tidy
find_program(CMAKE_CXX_CLANG_TIDY NAMES clang-tidy)
if (CMAKE_CXX_CLANG_TIDY)
    list(
        APPEND CMAKE_CXX_CLANG_TIDY
            "-checks=*,-fuchsia*,-google*,-hicpp*,-llvm*,-cppcoreguidelines-owning-memory,-modernize-use-auto,-readability-braces-around-statements,-cppcoreguidelines-pro-type-static-cast-downcast,-cppcoreguidelines-pro-type-vararg"
        )
endif()
