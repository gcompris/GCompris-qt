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
import QtQuick.Controls 1.1
import "../../core"
import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: menuActivity
    focus: true
    activityInfo: ActivityInfoTree.rootMenu

    onHome: pageView.depth === 1 ? Core.quit(menuActivity) : pageView.pop()

    onDisplayDialog: pageView.push(dialog)

    property string url: "qrc:/gcompris/src/activities/menu/resource/"
    property variant sections: [
        {
            icon: menuActivity.url + "all.svgz",
            tag: "all"
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

        GridView {
            id: section
            model: sections
            width: horizontal ? main.width : sectionCellWidth
            height: horizontal ? sectionCellHeight : main.height - bar.height
            x: 4
            y: 4
            cellWidth: sectionCellWidth
            cellHeight: sectionCellHeight
            interactive: false
            Component {
                id: sectionDelegate
                Item {
                    id: backgroundSection
                    width: sectionCellWidth
                    height: sectionCellHeight

                    Rectangle {
                        anchors.fill: parent
                        color: backgroundSection.GridView.isCurrentItem ?
                                   "#99FFFFFF" : "#00000000"
                    }

                    Image {
                        source: modelData.icon
                        sourceSize.height: sectionIconHeight
                        anchors.margins: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    ParticleSystemStar {
                        id: particles
                        anchors.fill: backgroundSection
                        clip: false
                    }
                    MouseArea {
                        anchors.fill: backgroundSection
                        onClicked: {
                            particles.emitter.burst(10)
                            ActivityInfoTree.filterByTag(modelData.tag)
                            menuActivity.currentTag = modelData.tag
                            section.currentIndex = index
                        }
                    }
                }
            }
            delegate: sectionDelegate
            highlight: Image {
                width: sectionCellWidth
                height: sectionCellHeight
                source: "qrc:/gcompris/src/core/resource/button.svgz"
            }
            highlightMoveDuration: 300
            focus: true
        }

        // Activities
        property int iconWidth: 190 * ApplicationInfo.ratio
        property int iconHeight: 190 * ApplicationInfo.ratio
        property int cellWidth2:
            horizontal ? iconWidth+(main.width%iconWidth)/Math.round(main.width/iconWidth) :
                         iconWidth+((main.width - section.width)%iconWidth)/Math.round((main.width - section.width)/iconWidth)
        property int cellHeight2: iconHeight * 1.5

        GridView {
            anchors {
                top: horizontal ? section.bottom : parent.top
                bottom: parent.bottom
                left: horizontal ? parent.left : section.right
                margins: 4
            }
            width: main.width
            cellWidth: cellWidth2
            cellHeight: cellHeight2
            focus: true
            clip: true
            model: ActivityInfoTree.menuTree
            delegate: Item {
                width: iconWidth+(main.width%iconWidth)/Math.round(main.width/iconWidth)
                height: iconHeight
                Rectangle {
                    id: background
                    width: cellWidth2 - 10
                    height: cellHeight2 - 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: 0.6
                    border.width: 2
                    border.color: "black"
                }
                Image {
                    source: "qrc:/gcompris/src/activities/" + icon;
                    anchors.top: background.top
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
                    GCText {
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        width: background.width
                        fontSizeMode: Text.Fit
                        minimumPointSize: 7
                        font.pointSize: 14
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.WordWrap
                        text: ActivityInfoTree.menuTree[index].title
                    }
                }
                ParticleSystemStar {
                    id: particles
                    anchors.fill: background
                }
                MouseArea {
                    anchors.fill: background
                    onClicked: {
                        particles.emitter.burst(50)
                        ActivityInfoTree.currentActivity = ActivityInfoTree.menuTree[index]
                        activityLoader.source = "qrc:/gcompris/src/activities/" +
                                ActivityInfoTree.menuTree[index].name
                        if (activityLoader.status == Loader.Ready) loadActivity()
                    }
                }
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
        onClose: {
            ActivityInfoTree.filterByTag(menuActivity.currentTag)
            home()
        }
    }
}
