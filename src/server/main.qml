/* GCompris - main.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
