# These tools are run (for now) only if BUILD_TESTING is ON
# Another useful tool could be clazy compiler too

# Run cppcheck on the code
find_program(CPPCHECK_EXE NAMES cppcheck)
if(CPPCHECK_EXE)
    set(CMAKE_CXX_CPPCHECK ${CPPCHECK_EXE})
    list(
        APPEND CMAKE_CXX_CPPCHECK 
            "--enable=all"
            "--inconclusive"
            "--force" 
            "--inline-suppr"
    )
endif()

# Run clang-tidy
find_program(CLANG_TIDY_EXE NAMES clang-tidy)
if(CLANG_TIDY_EXE)
    set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_EXE})
    list(
        APPEND CMAKE_CXX_CLANG_TIDY
            "-checks=*,-fuchsia*,-google*,-hicpp*,-llvm*,-cppcoreguidelines-owning-memory,-modernize-use-auto,-readability-braces-around-statements,-cppcoreguidelines-pro-type-static-cast-downcast,-cppcoreguidelines-pro-type-vararg,-cppcoreguidelines-pro-bounds-array-to-pointer-decay,-cppcoreguidelines-pro-bounds-pointer-arithmetic,-readability-static-accessed-through-instance"
        )
endif()
