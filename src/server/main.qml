/* GCompris - main.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Window 2.1
import QtQml 2.2
//import QtQuick.Controls 1.0
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2

import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core
import "../core"
import "components"

/**
 * GCompris' main QML file defining the top level window.
 * @ingroup infrastructure
 *
 * Handles application start (Component.onCompleted) and shutdown (onClosing)
 * on the QML layer.
 *
 * Contains the central GCAudio objects audio effects and audio voices.
 *
 * Contains the top level StackView presenting and animating GCompris'
 * full screen views.
 *
 * @inherit QtQuick.Window
 */
Window {
    id: main
    // Start in window mode at full screen size
    width: ApplicationSettings.previousWidth
    height: ApplicationSettings.previousHeight
    minimumWidth: 400 * ApplicationInfo.ratio
    minimumHeight: 400 * ApplicationInfo.ratio
    title: qsTr("GCompris server")

    /// @cond INTERNAL_DOCS

    property var applicationState: Qt.application.state

    Component.onCompleted: {
        contentFrame.replace("views/DashboardView.qml");
    }

    onClosing: Core.quit(main)

    Connections {
        target: masterController.ui_navigationController
        onGoManagePupilsView: contentFrame.replace("views/ManagePupilsView.qml")
        onGoCreateClientView: contentFrame.replace("views/CreateClientView.qml")
        onGoDashboardView: contentFrame.replace("views/DashboardView.qml")
        onGoEditClientView: contentFrame.replace("views/EditClientView.qml", {selectedClient: client})
        onGoFindClientView: contentFrame.replace("views/FindClientView.qml")
        onGoManageWorkPlanView: contentFrame.replace("views/ManageWorkPlanView.qml")
    }

    NavigationBar {
        id: navigationBar
    }

    StackView {
        id: contentFrame
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: navigationBar.left
            left: parent.left
        }
        initialItem: "qrc:/gcompris/src/server/views/SplashView.qml"
        clip: true
    }
    /// @endcond
}
