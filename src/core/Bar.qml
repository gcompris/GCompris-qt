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
            'contentId': content.exit
        },
        {
            'bid': about,
            'contentId': content.about
        },
        {
            'bid': help,
            'contentId': content.help
        },
        {
            'bid': home,
            'contentId': content.home
        },
        {
            'bid': previous,
            'contentId': content.level
        },
        {
            'bid': levelText,
            'contentId': content.level
        },
        {
            'bid': next,
            'contentId': content.level
        },
        {
            'bid': repeat,
            'contentId': content.repeat
        },
        {
            'bid': reload,
            'contentId': content.reload
        },
        {
            'bid': config,
            'contentId': content.config
        },
        {
            'bid': downloadImage,
            'contentId': content.download
        }
    ]

    property var buttonModel
    property int level: 0
    property bool hidden: false

    signal aboutClicked
    signal helpClicked
    signal configClicked
    signal nextLevelClicked
    signal previousLevelClicked
    signal repeatClicked
    signal reloadClicked
    signal homeClicked

    function toggle() {
        opacity = (opacity == 0 ? 1.0 : 0)
    }

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
                if(!bar.hidden) {
                    barRow.state = "hidden"
                } else {
                    barRow.state = "shown"
                }
                bar.hidden = !bar.hidden
            }
        }
    }

    function updateContent() {
        var newButtonModel = new Array()
        for(var def in buttonList) {
            if(content.value & buttonList[def].contentId) {
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
            source: "qrc:/gcompris/src/core/resource/bar_exit.svgz";
            sourceSize.width: 66 * barZoom
            onClicked: Core.quit();
        }
    }
    Component {
        id: about
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_about.svgz";
            sourceSize.width: 66 * barZoom
            onClicked: bar.aboutClicked()
        }
    }
    Component {
        id: help
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_help.svgz";
            sourceSize.width: 66 * barZoom
            onClicked: bar.helpClicked()
        }
    }
    Component {
        id: previous
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_previous.svgz";
            sourceSize.width: 30 * barZoom
            onClicked: bar.previousLevelClicked()
        }
    }
    Component {
        id: levelText
        GCText {
            id: levelTextId
            text: "" + level
            font.pointSize: 32
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
            source: "qrc:/gcompris/src/core/resource/bar_next.svgz";
            sourceSize.width: 30 * barZoom
            onClicked: bar.nextLevelClicked()
        }
    }
    Component {
        id: repeat
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svgz";
            sourceSize.width: 66 * barZoom
            onClicked: bar.repeatClicked()
        }
    }
    Component {
        id: reload
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_reload.svgz";
            sourceSize.width: 66 * barZoom
            onClicked: bar.reloadClicked()
        }
    }
    Component {
        id: config
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_config.svgz";
            sourceSize.width: 66 * barZoom
            onClicked: bar.configClicked()
        }
    }
    Component {
        id: home
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_home.svgz";
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
                    var downloadDialog = Core.showDownloadDialog(bar, {});
                }
            }
        }
    }
}
