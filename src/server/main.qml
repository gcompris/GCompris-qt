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
import QtQuick.Controls 1.0
import QtQuick.Window 2.1
import QtQml 2.2

import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

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
 * @sa BarButton, BarEnumContent
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

    onApplicationStateChanged: {
        if (ApplicationInfo.isMobile && applicationState != Qt.ApplicationActive) {
            audioVoices.stop();
            audioEffects.stop();
        }
    }

    onClosing: Core.quit(main)

    StackView {
        id: pageView
        anchors.fill: parent
        initialItem: {
            "item": "qrc:/gcompris/src/server/views/Menu.qml"
        }

        focus: ApplicationInfo.QTVersion >= "5.4.0"

        delegate: StackViewDelegate {
            id: root
            function getTransition(properties)
            {
                if(!properties.exitItem.isDialog &&        // if coming from menu and
                        !properties.enterItem.isDialog)    // going into an activity then
                  ;//playIntroVoice(properties.enterItem.activityInfo.name);    // play intro

                if (!properties.exitItem.isDialog ||       // if coming from menu or
                        properties.enterItem.alwaysStart)  // start signal enforced (for special case like transition from config-dialog to editor)
                    properties.enterItem.start();

                if(properties.name === "pushTransition") {
                    if(properties.enterItem.isDialog) {
                        return pushVTransition
                    } else {
                        return pushHTransition
                    }
                } else {
                    if(properties.exitItem.isDialog) {
                        return popVTransition
                    } else {
                        return popHTransition
                    }

                }
            }

            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
                if(!properties.enterItem.isDialog) {
                    properties.exitItem.stop()
                }
            }

            property Component pushHTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: target.width
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: -target.width
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component popHTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: -target.width
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: target.width
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component pushVTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: -target.height
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: target.height
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component popVTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: target.height
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: -target.height
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }
            property Component replaceTransition: pushHTransition
        }
    }
    /// @endcond
}
