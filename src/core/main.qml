/* GCompris - main.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import QtQuick.Controls 1.2
import QtQuick.Window 2.1
import QtQuick.Dialogs 1.1

import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

Window {
    id: main
    width: 800
    height: 520
    minimumWidth: 400
    minimumHeight: 400
    title: "GCompris"

    onClosing: Core.quit()

    GCAudio {
        id: audioVoices
        source: "qrc:/gcompris/src/core/resource/intro.ogg"
        muted: !ApplicationSettings.isAudioVoicesEnabled
        autoPlay: false
    }

    GCAudio {
        id: audioEffects
        source: "qrc:/gcompris/src/core/resource/intro.ogg"
        muted: !ApplicationSettings.isAudioEffectsEnabled
        autoPlay: false
    }

    function playIntroVoice(name) {
        name = name.split("/")[0]
        audioVoices.append(ApplicationInfo.getAudioFilePath("voices/$LOCALE/intro/" + name + ".ogg"))
    }

    Component.onCompleted: {
        console.log("enter main.qml (run #" + ApplicationSettings.exeCount + ")")
        if (ApplicationSettings.exeCount == 1) {
            // first run
            var buttonHandler = new Array();
            var dialog;
            buttonHandler[StandardButton.Ok] = function() {};
            dialog = Core.showMessageDialog(main, qsTr("Welcome to GCompris!"),
                    qsTr("You are running GCompris for the first time."),
                    qsTr("You should verify that your application settings especially your language is set correctly, and that all language specific sound files are installed. You can do this in the Preferences Dialog.") +
                    "\n" +
                    qsTr("Your current locale is '%1'").arg(ApplicationInfo.localeShort) +
                    "\n" +
                    qsTr("Have Fun!"),
                    StandardIcon.Information,
                    buttonHandler
            );
        }
    }

    StackView {
        id: pageView
        anchors.fill: parent
        initialItem: "qrc:/gcompris/src/activities/" + ActivityInfoTree.rootMenu.name
        delegate: StackViewDelegate {
            id: root
            function getTransition(properties)
            {
                properties.exitItem.pause()
                if(!properties.exitItem.isDialog) {
                    if(!properties.enterItem.isDialog) {
                        playIntroVoice(properties.enterItem.activityInfo.name)
                        properties.enterItem.audioVoices = audioVoices
                        properties.enterItem.audioEffects = audioEffects
                    }
                    properties.enterItem.start()
                }

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
                properties.enterItem.play()
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
}
