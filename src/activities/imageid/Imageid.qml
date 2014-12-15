/* GCompris - Imageid.qml
 *
 * Copyright (C) 2014 Holger Kaelberer
 *
 * Authors:
 *   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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

import QtQuick 2.1
import GCompris 1.0
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.1

import "../../core"
import "imageid.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}
    
    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/imageid/resource/imageid-bg.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width

        property Item dialog

        signal start
        signal stop
        
        Connections {
            target: DownloadManager

            onDownloadFinished: Activity.start(items)
            onError: {
                // Fixme display an error message
                Core.destroyDialog(dialog)
            }
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias wordImage: wordImage
            property alias wordListModel: wordListModel
            property alias parser: parser
            property GCAudio audioVoices: activity.audioVoices
        }

        onStart: {
            Activity.init(items)

            if(!DownloadManager.haveLocalResource("data/words/words.rcc")) {
                var buttonHandler = new Array();
                buttonHandler[StandardButton.No] = function() {};
                buttonHandler[StandardButton.Yes] = function() { DownloadManager.updateResource("data/words/words.rcc") };
                dialog = Core.showMessageDialog(parent, qsTr("Download?"),
                                                qsTr("Are you ok to download the images for this activity"),
                                                "",
                                                StandardIcon.Question,
                                                buttonHandler);
            } else {
                // Will register the resource file and call start() on callback
                DownloadManager.updateResource("data/words/words.rcc")
            }
        }

        onStop: { Activity.stop() }
        
        JsonParser {
            id: parser
            
            onError: console.error("Imageid: Error parsing json: " + msg);
        }
        
        Item {
            id: wordListWrapper

            anchors {
                top: parent.top
                bottom: bar.top
                left: parent.left
                right: imageFrame.left
                topMargin: 10
                rightMargin: 10
                bottomMargin: 10
                leftMargin: 30
            }
            //width: parent.width * 0.4
            height: parent.height - bar.height - 2 * anchors.margins
        
            ListView {
                id: wordListView
                
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            
                width: parent.width - anchors.margins * 2
                height: wordListModel.count * buttonHeight + 
                    (wordListModel.count - 1) * spacing
                spacing: 20 * ApplicationInfo.ratio
                orientation: Qt.Vertical
                verticalLayoutDirection: ListView.TopToBottom
                interactive: false
    
                property int buttonHeight: parent.height / 10
        
                model: wordListModel
    
                delegate: AnswerButton {
                    id: wordRectangle

                    width: wordListView.width * 0.8
                    height: wordListView.buttonHeight

                    textLabel: word
                    isCorrectAnswer: word === Activity.getCorrectAnswer()
                    onCorrectlyPressed: bonus.good("smiley");
                }
            }
        }
        
        ListModel {
            id: wordListModel
        }
        
        Image {
            id: imageFrame
            source: "qrc:/gcompris/src/activities/imageid/resource/imageid_frame.svg"
            fillMode: Image.Stretch
            sourceSize.width: parent.width / 1.7
            z: 11
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: parent.width * 0.05
            }

        
            Image {
                id: wordImage
                
                sourceSize.height: parent.height / 1.7
                sourceSize.width: parent.width / 1.7
                
                anchors {
                    centerIn: parent
                    margins: 0.05 + parent.width
                }
            }
            
        }

        DropShadow {
            anchors.fill: imageFrame
            cached: true
            horizontalOffset: 12
            verticalOffset: 12
            radius: 8.0
            samples: 16
            color: "#ff292950"
            source: imageFrame
        }
            
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar

            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
        
        Score {
            id: score

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.top: undefined
        }
        
    }
}
