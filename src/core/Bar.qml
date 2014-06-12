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
    width: barRow.width
    height: barRow.height - 30
    z: 1000
    property real barZoom: 1.2 * ApplicationInfo.ratio
    property BarEnumContent content
    property int level: 0
    signal aboutClicked
    signal helpClicked
    signal configClicked
    signal nextLevelClicked
    signal previousLevelClicked
    signal repeatClicked
    signal homeClicked

    function toggle() {
        opacity = (opacity == 0 ? 1.0 : 0)
    }

    function show(newContent) {
        content.value = newContent
    }
    
    Connections {
        target: DownloadManager
        
        onDownloadStarted: downloadImage.visible = true;
        onDownloadFinished: downloadImage.visible = false;  
        onError: downloadImage.visible = false;
    }

    Row {
        id: barRow
        spacing: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        Item { width: 10; height: 1 }
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_exit.svgz";
            contentId: ApplicationInfo.isMobile ? content.disabled : content.exit
            sourceSize.width: 66 * barZoom
            onClicked: Qt.quit();
        }
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_about.svgz";
            contentId: content.about
            sourceSize.width: 66 * barZoom
            onClicked: bar.aboutClicked()
        }
        BarButton {
            source: "qrc:/gcompris/src/core/resource/bar_help.svgz";
            contentId: content.help
            sourceSize.width: 66 * barZoom
            onClicked: bar.helpClicked()
        }
        BarButton {
            id: previousButton
            source: "qrc:/gcompris/src/core/resource/bar_previous.svgz";
            contentId: content.previous
            sourceSize.width: 30 * barZoom
            onClicked: bar.previousLevelClicked()
        }
        Text {
            id: levelTextId
            text: "" + level
            font.family: "Helvetica"
            font.pointSize: 32
            font.weight: Font.DemiBold
            style: Text.Outline
            styleColor: "black"
            color: "white"
            visible: content.previous & content.value
        }
        BarButton {
            id: nextButton
            source: "qrc:/gcompris/src/core/resource/bar_next.svgz";
            contentId: content.next
            sourceSize.width: 30 * barZoom
            onClicked: bar.nextLevelClicked()
        }
        BarButton {
            id: repeatButton
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svgz";
            sourceSize.width: 66 * barZoom
            contentId: content.repeat
            onClicked: bar.repeatClicked()
        }
        BarButton {
            id: configButton
            source: "qrc:/gcompris/src/core/resource/bar_config.svgz";
            contentId: content.config
            sourceSize.width: 66 * barZoom
            onClicked: bar.configClicked()
        }
        BarButton {
            id: homeButton
            source: "qrc:/gcompris/src/core/resource/bar_home.svgz";
            contentId: ApplicationInfo.isMobile ? content.disabled : content.home
            sourceSize.width: 66 * barZoom
            onClicked: bar.homeClicked()
        }
        AnimatedImage {
            id: downloadImage
            source: "qrc:/gcompris/src/core/resource/loader.gif"
            anchors.bottom: parent.bottom
            visible: false
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var downloadDialog = Core.showDownloadDialog(bar, {});
                }
            }
        }
        Item { width: 10; height: 1 }
    }

    Behavior on opacity { PropertyAnimation { duration: 500 } }
}
