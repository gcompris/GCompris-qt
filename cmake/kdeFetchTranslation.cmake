#
# This file is mostly copied from the KDECMakeSettings.cmake:
# https://github.com/KDE/extra-cmake-modules/blob/master/kde-modules/KDECMakeSettings.cmake#L320
# Once the last version of ECM will be available on most distributions, we'll
# need to switch to it (or at least use it if available else switch to existing
# l10n-fetch-po-files.py script to retrieve the po)
#
# License of KDECMakeSettings.cmake
#=============================================================================
# Copyright 2014      Alex Merry <alex.merry@kde.org>
# Copyright 2013      Aleix Pol <aleixpol@kde.org>
# Copyright 2012-2013 Stephen Kelly <steveire@gmail.com>
# Copyright 2007      Matthias Kretz <kretz@kde.org>
# Copyright 2006-2007 Laurent Montel <montel@kde.org>
# Copyright 2006-2013 Alex Neundorf <neundorf@kde.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if(NOT TARGET fetch-translations AND KDE_L10N_AUTO_TRANSLATIONS)
    set(KDE_L10N_BRANCH "trunk" CACHE STRING "Branch from l10n.kde.org to fetch from: trunk | stable | lts | trunk_kde4 | stable_kde4")

    set(_reponame "gcompris")

    set(releaseme_clone_commands
        COMMAND git clone --depth 1 https://anongit.kde.org/releaseme.git
    )
    add_custom_command(
        OUTPUT "${CMAKE_BINARY_DIR}/releaseme"
        ${releaseme_clone_commands}
        COMMENT "Fetching releaseme scripts to download translations..."
    )

    set(_l10n_po_dir "${CMAKE_BINARY_DIR}/po")
    set(_l10n_poqm_dir "${CMAKE_BINARY_DIR}/poqm")

    if(CMAKE_VERSION VERSION_GREATER 3.2)
        set(extra BYPRODUCTS ${_l10n_po_dir} ${_l10n_poqm_dir})
    endif()

    set(fetch_commands
        COMMAND ruby "${CMAKE_BINARY_DIR}/releaseme/fetchpo.rb"
            --origin ${KDE_L10N_BRANCH}
            --project "${_reponame}"
            --output-dir "${_l10n_po_dir}"
            --output-poqm-dir "${_l10n_poqm_dir}"
            "${CMAKE_SOURCE_DIR}"
    )

    add_custom_target(fetch-translations ${_EXTRA_ARGS}
        COMMENT "Downloading translations for ${_reponame} branch ${KDE_L10N_BRANCH}..."
        COMMAND git -C "${CMAKE_BINARY_DIR}/releaseme" pull
        COMMAND cmake -E remove_directory ${_l10n_po_dir}
        COMMAND cmake -E remove_directory ${_l10n_poqm_dir}
        ${fetch_commands}
        ${extra}
        ${move_translations}
        DEPENDS "${CMAKE_BINARY_DIR}/releaseme"
    )

  set(move_translations COMMAND
    bash ${CMAKE_SOURCE_DIR}/tools/move_translations.sh ${_l10n_poqm_dir} ${CMAKE_SOURCE_DIR}/po
    )

    if (NOT EXISTS ${_l10n_po_dir} OR NOT EXISTS ${_l10n_poqm_dir})
        execute_process(${releaseme_clone_commands})
        execute_process(${fetch_commands})
        execute_process(${move_translations})
    endif()
endif()
