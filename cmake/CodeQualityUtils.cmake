#=============================================================================
# SPDX-FileCopyrightText: 2018 Johnny Jazeix <jazeix@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause
#=============================================================================
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
            "-checks=*,-fuchsia*,-google*,-hicpp*,-llvm*,-cppcoreguidelines-*,-modernize-use-auto,-modernize-use-trailing-return-type,-readability-*,-altera-*,-misc-const-correctness,-bugprone-easily-swappable-parameters,-modernize-return-braced-init-list,-misc-include-cleaner"
        )
endif()
