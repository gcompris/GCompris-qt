/* GCompris - Menu.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import "../../core"
import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: menuActivity
    focus: true
    activityInfo: ActivityInfoTree.rootMenu

    onHome: {
        if(pageView.depth === 1) {
            Core.quit(main);
        }
        else {
            pageView.pop();
            // Restore focus that has been taken by the loaded activity
            if(pageView.currentItem == menuActivity)
                focus = true;
        }
    }

    onDisplayDialog: pageView.push(dialog)

    property string url: "qrc:/gcompris/src/activities/menu/resource/"
    property variant sections: [
        {
            icon: menuActivity.url + "all.svgz",
            tag: "favorite"
        },
        {
            icon: menuActivity.url + "computer.svgz",
            tag: "computer"
        },
        {
            icon: menuActivity.url + "discovery.svgz",
            tag: "discovery"
        },
        {
            icon: menuActivity.url + "experience.svgz",
            tag: "experiment"
        },
        {
            icon: menuActivity.url + "fun.svgz",
            tag: "fun"
        },
        {
            icon: menuActivity.url + "math.svgz",
            tag: "math"
        },
        {
            icon: menuActivity.url + "puzzle.svgz",
            tag: "puzzle"
        },
        {
            icon: menuActivity.url + "reading.svgz",
            tag: "reading"
        },
        {
            icon: menuActivity.url + "strategy.svgz",
            tag: "strategy"
        },
    ]
    property string currentTag: sections[0].tag

    pageComponent: Image {
        id: background
        source: menuActivity.url + "background.svgz"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop

        function loadActivity() {
            activityLoader.item.menu = menuActivity
            activityLoader.item.activityInfo = ActivityInfoTree.currentActivity
            pageView.push(activityLoader.item)
        }

        Loader {
            id: activityLoader
            asynchronous: true
            onStatusChanged: if (status == Loader.Ready) loadActivity()
        }

        // Filters
        property bool horizontal: main.width > main.height
        property int sectionIconWidth:
            horizontal ?
                Math.min(100 * ApplicationInfo.ratio, main.width / (sections.length + 1)) :
                Math.min(100 * ApplicationInfo.ratio, (main.height - bar.height) / (sections.length + 1))
        property int sectionIconHeight: sectionIconWidth
        property int sectionCellWidth: sectionIconWidth * 1.1
        property int sectionCellHeight: sectionIconHeight * 1.1

        property var currentActiveGrid: activitiesGrid
        property bool keyboardMode: false
        Keys.onPressed: {
            if (event.modifiers === Qt.ControlModifier &&
                    event.key === Qt.Key_S) {
                // Ctrl+S toggle show / hide section
                ApplicationSettings.sectionVisible = !ApplicationSettings.sectionVisible
            } else if(event.key === Qt.Key_Space) {
                currentActiveGrid.currentItem.selectCurrentItem()
            }
        }
        Keys.onReleased: {
            keyboardMode = true
            event.accepted = false
        }
        Keys.onTabPressed: currentActiveGrid = ((currentActiveGrid == activitiesGrid) ?
                                                    section : activitiesGrid);
        Keys.onEnterPressed: currentActiveGrid.currentItem.selectCurrentItem();
        Keys.onReturnPressed: currentActiveGrid.currentItem.selectCurrentItem();
        Keys.onRightPressed: currentActiveGrid.moveCurrentIndexRight();
        Keys.onLeftPressed: currentActiveGrid.moveCurrentIndexLeft();
        Keys.onDownPressed: currentActiveGrid.moveCurrentIndexDown();
        Keys.onUpPressed: currentActiveGrid.moveCurrentIndexUp();

        GridView {
            id: section
            model: sections
            width: horizontal ? main.width : sectionCellWidth
            height: horizontal ? sectionCellHeight : main.height - bar.height
            x: ApplicationSettings.sectionVisible ? section.initialX : -sectionCellWidth
            y: ApplicationSettings.sectionVisible ? section.initialY : -sectionCellHeight
            cellWidth: sectionCellWidth
            cellHeight: sectionCellHeight
            interactive: false
            keyNavigationWraps: true

            property int initialX: 4
            property int initialY: 4

            Component {
                id: sectionDelegate
                Item {
                    id: backgroundSection
                    width: sectionCellWidth
                    height: sectionCellHeight

                    Image {
                        source: modelData.icon
                        sourceSize.height: sectionIconHeight
                        anchors.margins: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    ParticleSystemStarLoader {
                        id: particles
                        anchors.fill: backgroundSection
                        clip: false
                    }
                    MouseArea {
                        anchors.fill: backgroundSection
                        onClicked: {
                            selectCurrentItem()
                        }
                    }

                    function selectCurrentItem() {
                        particles.burst(10)
                        ActivityInfoTree.filterByTag(modelData.tag)
                        ActivityInfoTree.filterLockedActivities()
                        menuActivity.currentTag = modelData.tag
                        section.currentIndex = index
                    }
                }
            }
            delegate: sectionDelegate
            highlight: Item {
                width: sectionCellWidth
                height: sectionCellHeight

                Rectangle {
                    anchors.fill: parent
                    color:  "#99FFFFFF"
                }
                Image {
                    source: "qrc:/gcompris/src/core/resource/button.svgz"
                    anchors.fill: parent
                }
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        // Activities
        property int iconWidth: 190 * ApplicationInfo.ratio
        property int iconHeight: 190 * ApplicationInfo.ratio
        property int activityCellWidth:
            horizontal ? background.width / Math.floor(background.width / iconWidth) :
                         (background.width - section.width) / Math.floor((background.width - section.width) / iconWidth)
        property int activityCellHeight: iconHeight * 1.5

        Loader {
            id: warningOverlay
            anchors {
                top: horizontal ? section.bottom : parent.top
                bottom: parent.bottom
                left: horizontal ? parent.left : section.right
                right: parent.right
                margins: 4
            }
            active: (ActivityInfoTree.menuTree.length === 0) && (currentTag === "favorite")
            sourceComponent: Item {
                anchors.fill: parent
                GCText {
                    id: instructionTxt
                    fontSize: smallSize
                    y: height * 0.2
                    x: (parent.width - width) / 2
                    z: 2
                    width: parent.width * 0.6
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    font.weight: Font.DemiBold
                    color: 'white'
                    text: qsTr("Put your favorite activities here by selecting the " +
                               "star on each activity top right.")
                }
                Rectangle {
                    anchors.fill: instructionTxt
                    anchors.margins: -6
                    z: 1
                    opacity: 0.5
                    radius: 10
                    border.width: 2
                    border.color: "black"
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#000" }
                        GradientStop { position: 0.9; color: "#666" }
                        GradientStop { position: 1.0; color: "#AAA" }
                    }
                }
            }
        }

        GridView {
            id: activitiesGrid
            anchors {
                top: horizontal ? section.bottom : parent.top
                bottom: parent.bottom
                left: horizontal ? parent.left : section.right
                margins: 4
            }
            width: background.width
            cellWidth: activityCellWidth
            cellHeight: activityCellHeight
            clip: true
            model: ActivityInfoTree.menuTree
            keyNavigationWraps: true
            property int spacing: 10

            delegate: Item {
                id: delegateItem
                width: activityCellWidth - activitiesGrid.spacing
                height: activityCellHeight - activitiesGrid.spacing
                Rectangle {
                    id: activityBackground
                    width: activityCellWidth - activitiesGrid.spacing
                    height: activityCellHeight - activitiesGrid.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    opacity: 0.5
                }
                Image {
                    source: "qrc:/gcompris/src/activities/" + icon;
                    anchors.top: activityBackground.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceSize.height: iconHeight
                    anchors.margins: 5
                    Image {
                        source: "qrc:/gcompris/src/core/resource/difficulty" +
                                ActivityInfoTree.menuTree[index].difficulty + ".svgz";
                        anchors.top: parent.top
                        sourceSize.width: iconWidth * 0.15
                        x: 5
                    }
                    Image {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            rightMargin: 4
                        }
                        source: demo || !ApplicationSettings.isDemoMode
                                ? "" :
                                  menuActivity.url + "lock.svg"
                        sourceSize.width: 30 * ApplicationInfo.ratio
                    }
                    GCText {
                        id: title
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: activityBackground.width
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        fontSize: regularSize
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.WordWrap
                        text: ActivityInfoTree.menuTree[index].title
                    }
                    // If we have enough room at the bottom display the description
                    GCText {
                        id: description
                        visible: delegateItem.height - (title.y + title.height) > description.height ? 1 : 0
                        anchors.top: title.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: activityBackground.width
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        fontSize: regularSize
                        elide: Text.ElideRight
                        maximumLineCount: 3
                        wrapMode: Text.WordWrap
                        text: ActivityInfoTree.menuTree[index].description
                    }
                }
                ParticleSystemStarLoader {
                    id: particles
                    anchors.fill: activityBackground
                }
                MouseArea {
                    anchors.fill: activityBackground
                    onClicked: selectCurrentItem()
                }
                Image {
                    source: menuActivity.url + (favorite ? "all.svgz" : "all_disabled.svg");
                    anchors {
                        top: parent.top
                        right: parent.right
                        rightMargin: 4 * ApplicationInfo.ratio
                    }
                    sourceSize.width: iconWidth * 0.25
                    visible: ApplicationSettings.sectionVisible
                    MouseArea {
                        anchors.fill: parent
                        onClicked: favorite = !favorite
                    }
                }

                function selectCurrentItem() {
                    if(pageView.busy)
                        return
                    particles.burst(50)
                    ActivityInfoTree.currentActivity = ActivityInfoTree.menuTree[index]
                    activityLoader.setSource("qrc:/gcompris/src/activities/" + ActivityInfoTree.menuTree[index].name,
                                             {
                                                 'audioVoices': audioVoices,
                                                 'audioEffects': audioEffects
                                             })
                    if (activityLoader.status == Loader.Ready) loadActivity()
                }
            }
            highlight: Rectangle {
                width: activityCellWidth - activitiesGrid.spacing
                height: activityCellHeight - activitiesGrid.spacing
                color:  "#AAFFFFFF"
                border.width: 3
                border.color: "black"
                visible: background.keyboardMode
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | exit | config | about }
            onAboutClicked: {
                displayDialog(dialogAbout)
            }

            onHelpClicked: {
                displayDialog(dialogHelp)
            }

            onConfigClicked: {
                displayDialog(dialogConfig)
            }
        }
    }

    DialogAbout {
        id: dialogAbout
        onClose: home()
    }
    DialogHelp {
        id: dialogHelp
        onClose: home()
        activityInfo: ActivityInfoTree.rootMenu
    }

    DialogConfig {
        id: dialogConfig
        main: menuActivity.main
        onClose: {
            ActivityInfoTree.filterByTag(menuActivity.currentTag)
            ActivityInfoTree.filterLockedActivities()
            home()
        }
    }
}
