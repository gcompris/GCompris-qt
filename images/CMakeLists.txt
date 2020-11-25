#=============================================================================
# SPDX-FileCopyrightText: 2016 Aleix Pol Gonzalez <aleixpol@kde.org>
#
# SPDX-License-Identifier: BSD-2-Clause
#=============================================================================
include(ECMInstallIcons)

ecm_install_icons(ICONS
    256-apps-gcompris-qt.png
    sc-apps-gcompris-qt.svg
    DESTINATION ${KDE_INSTALL_ICONDIR}
    THEME hicolor
)
