/* GCompris - Bar.qml
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
import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: bar
    x: 0
    anchors.bottom: parent.bottom
    width: openBar.width
    height: openBar.height
    z: 1000
    property real barZoom: 1.2 * ApplicationInfo.ratio
    property BarEnumContent content

    // This is just a list of all our possible buttons.
    // bid = Button ID. And references the Component object of the button
    // This way we can have any visual object in the bar.
    property variant buttonList: [
        {
            'bid': exit,
            'contentId': content.exit,
            'allowed': true
        },
        {
            'bid': about,
            'contentId': content.about,
            'allowed': true
        },
        {
            'bid': help,
            'contentId': content.help,
            'allowed': true
        },
        {
            'bid': home,
            'contentId': content.home,
            'allowed': true
        },
        {
            'bid': previous,
            'contentId': content.level,
            'allowed': true
        },
        {
            'bid': levelText,
            'contentId': content.level,
            'allowed': true
        },
        {
            'bid': next,
            'contentId': content.level,
            'allowed': true
        },
        {
            'bid': repeat,
            'contentId': content.repeat,
            'allowed': true
        },
        {
            'bid': reload,
            'contentId': content.reload,
            'allowed': true
        },
        {
            'bid': config,
            'contentId': content.config,
            'allowed': !ApplicationSettings.isKioskMode
        },
        {
            'bid': downloadImage,
            'contentId': content.download,
            'allowed': true
        }
    ]

    property var buttonModel
    property int level: 0

    signal aboutClicked
    signal helpClicked
    signal configClicked
    signal nextLevelClicked
    signal previousLevelClicked
    signal repeatClicked
    signal reloadClicked
    signal homeClicked

    function show(newContent) {
        content.value = newContent
    }

    Connections {
        target: DownloadManager
        
        onDownloadStarted: content.value |= content.download
        onDownloadFinished: content.value &= ~content.download
        onError: content.value &= ~content.download
    }

    Image {
        id: openBar
        source: "qrc:/gcompris/src/core/resource/bar_open.svg";
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        sourceSize.width: 66 * barZoom
        MouseArea {
            anchors.fill: parent

            onClicked: {
                ApplicationSettings.isBarHidden = !ApplicationSettings.isBarHidden;
            }
        }
    }

    function updateContent() {
        var newButtonModel = new Array()
        for(var def in buttonList) {
            if((content.value & buttonList[def].contentId) &&
               buttonList[def].allowed) {
                newButtonModel.push(buttonList[def])
            }
        }
        buttonModel = newButtonModel
    }

    Connections {
        target: content
        onValueChanged: updateContent()
    }

    onContentChanged: {
        updateContent()
    }

    Row {
        id: barRow
        spacing: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: openBar.right
        anchors.leftMargin: 10 * ApplicationInfo.ratio
        Repeater {
            model: buttonModel
            Loader {
                sourceComponent: modelData.bid
            }
        }

        state: ApplicationSettings.isBarHidden ? "hidden" : "shown"

        states: [
            State {
                name: "shown"

                AnchorChanges {
                    target: barRow
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "hidden"

                AnchorChanges {
                    target: barRow
                    anchors.bottom: undefined
                    anchors.top: parent.bottom
                }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 800; easing.type: Easing.OutBounce }
        }
        populate: Transition {
            NumberAnimation {
                properties: "x,y"; from: 200;
                duration: 1500; easing.type: Easing.OutBounce
            }
        }
        add: Transition {
            NumberAnimation {
                properties: "x,y"; from: 200;
                duration: 1500; easing.type: Easing.OutBounce
            }
        }
        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 1500; easing.type: Easing.OutBounce
            }
        }
    }

    // All the possible bar buttons are defined here
    // ---------------------------------------------
    Component {
        id: exit
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_exit.svg";
            sourceSize.width: 66 * barZoom
            onClicked: Core.quit(bar.parent.parent);
        }
    }
    Component {
        id: about
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_about.svg";
            sourceSize.width: 66 * barZoom
            onClicked: bar.aboutClicked()
        }
    }
    Component {
        id: help
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_help.svg";
            sourceSize.width: 66 * barZoom
            onClicked: bar.helpClicked()
        }
    }
    Component {
        id: previous
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg";
            sourceSize.width: 30 * barZoom
            onClicked: bar.previousLevelClicked()
        }
    }
    Component {
        id: levelText
        GCText {
            id: levelTextId
            text: "" + level
            fontSize: hugeSize
            font.weight: Font.DemiBold
            style: Text.Outline
            styleColor: "black"
            color: "white"
            visible: content.level & content.value
        }
    }
    Component {
        id: next
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_next.svg";
            sourceSize.width: 30 * barZoom
            onClicked: bar.nextLevelClicked()
        }
    }
    Component {
        id: repeat
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            sourceSize.width: 66 * barZoom
            onClicked: bar.repeatClicked()
        }
    }
    Component {
        id: reload
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_reload.svg";
            sourceSize.width: 66 * barZoom
            onClicked: bar.reloadClicked()
        }
    }
    Component {
        id: config
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_config.svg";
            sourceSize.width: 66 * barZoom
            onClicked: bar.configClicked()
        }
    }
    Component {
        id: home
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_home.svg";
            sourceSize.width: 66 * barZoom
            onClicked: bar.homeClicked()
        }
    }
    Component {
        id: downloadImage
        AnimatedImage {
            source: "qrc:/gcompris/src/core/resource/loader.gif"
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var downloadDialog = Core.showDownloadDialog(bar.parent, {});
                }
            }
        }
    }
}
