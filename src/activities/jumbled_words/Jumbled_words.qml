/* GCompris - jumbled_words.qml
 *
 * Copyright (C) 2016  Komal Parmaar <parmaark@gmail.com>
 *
 * Authors:
 *    Komal Parmaar <parmaark@gmail.com> (Qt Quick)
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
import QtGraphicalEffects 1.0
import GCompris 1.0
import "../../core"
import "jumbled_words.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        focus: true

        property string locale: "system"
        signal start
        signal stop
        signal voiceError

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)

        }

    //QML items needed in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias parser: parser
            property alias bar: bar
            property alias questionItem: questionItem
            property alias bonus: bonus
            property alias edit: edit
            property alias hintimage: hintImage
            property alias score: score
            property alias locale: background.locale
            property alias background: background
            property GCAudio audioEffects: activity.audioEffects
            property GCAudio audioVoices: activity.audioVoices
        }
        onVoiceError: {
            questionItem.visible = true
        }
        onStart: {
            questionItem.visible = true
            activity.audioVoices.error.connect(voiceError)

            edit.forceActiveFocus();
            Activity.start(items);
        }
        onStop: {
            Activity.stop()
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias localeBox: localeBox
                    height: column.height

                    property alias availableLangs: langs.languages
                    LanguageList {
                        id: langs
                    }

                    Column {
                        id: column
                        spacing: 10
                        width: parent.width

                        Flow {
                            spacing: 5
                            width: dialogActivityConfig.width
                            GCComboBox {
                                id: localeBox
                                model: langs.languages
                                background: dialogActivityConfig
                                label: qsTr("Select your locale")
                            }
                        }
                    }
                }
            }

            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["locale"]) {
                    background.locale = dataToSave["locale"];
                }
            }
            onSaveData: {
                var oldLocale = background.locale;
                var newLocale =
                dialogActivityConfig.configItem.availableLangs[dialogActivityConfig.loader.item.localeBox.currentIndex].locale;
                // Remove .UTF-8
                if(newLocale.indexOf('.') != -1) {
                    newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                }
                dataToSave = {"locale": newLocale }

                background.locale = newLocale;

                // Restart the activity with new information
                if(oldLocale !== newLocale) {
                    background.stop();
                    background.start();
                }
            }

            function setDefaultValues() {
                var localeUtf8 = background.locale;
                if(background.locale != "system") {
                    localeUtf8 += ".UTF-8";
                }

                for(var i = 0 ; i < dialogActivityConfig.configItem.availableLangs.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableLangs[i].locale === localeUtf8) {
                        dialogActivityConfig.loader.item.localeBox.currentIndex = i;
                        break;
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Item {
            id: questionItem
            anchors {
                left: parent.left
                top: parent.top
                right:parent.right
                margins: 10
            }
           anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.topMargin: parent.height * 0.25
            z: 10
            width: questionText.width * 2
            height: questionText.height * 1.3
            visible: true

            property alias text: questionText.text

            Rectangle {
                id: questionRect
                anchors.fill: questionText
                border.color: "#FFFFFFFF"
                border.width: 2
                height:questionText.height
                color: "#000065"
                opacity: 0.31
                radius: 10

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: ApplicationInfo.isMobile ? false : true

                    onClicked: {
                        Activity.checkAnswer();
                    }
                }
            }

            GCText {
                id: questionText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 1.0
                z:11
                fontSize: 44
                font.bold: true
                style: Text.Outline
                styleColor: "#2a2a2a"
            }

            DropShadow {
                anchors.fill: questionText
                cached: false
                horizontalOffset: 1
                verticalOffset: 1
                radius: 3
                samples: 16
                color: "#422a2a2a"
                source: questionText
            }


        }

        Image{
            id : hintImage
            anchors {
                    left:parent.left
                    bottom:flick.top
            }
        }



        Rectangle {
            id: flickRect
            anchors.fill: flick
            border.color: "#FFFFFFFF"
            border.width: 2
            height:flick.height
            color: "#000065"
            opacity: 0.31
            radius: 10
        }

        Flickable {
            id: flick
            anchors.leftMargin: 300 * ApplicationInfo.ratio
            anchors.rightMargin: 300 * ApplicationInfo.ratio
            anchors.bottomMargin: 50 * ApplicationInfo.ratio

            anchors {
                left: parent.left
                right: parent.right
                top: questionItem.bottom
                bottom: bar.top
                margins: 10
                centerIn: background.Center
            }
            contentWidth: edit.paintedWidth
            contentHeight: edit.paintedHeight
            clip: true
            flickableDirection: Flickable.VerticalFlick

            function ensureVisible(r)
            {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;

            }

            TextEdit {
                id: edit
                width: flick.width
                height: flick.height
                focus: true
                wrapMode: TextEdit.Wrap
                textFormat: TextEdit.RichText
                onCursorRectangleChanged: {
                    flick.ensureVisible(cursorRectangle)
                }
                font {
                    pointSize: (40 + ApplicationSettings.baseFontSize) * ApplicationInfo.fontRatio
                    capitalization: ApplicationSettings.fontCapitalization
                    weight: Font.Bold
                    family: GCSingletonFontLoader.fontLoader.name
                    letterSpacing: ApplicationSettings.fontLetterSpacing
                    wordSpacing: 10
                }

                cursorDelegate: Rectangle {
                    id: cursor
                    width: 10
                    height: parent.cursorRectangle.height
                    color: 'white'
                    SequentialAnimation on opacity {
                        running: true
                        loops: Animation.Infinite
                        PropertyAnimation {
                            to: 0.2
                            duration: 1000
                        }
                        PropertyAnimation {
                            to: 1
                            duration: 1000
                        }
                    }
                }
            }
        }

        Rectangle {
            id: submit
            anchors.fill: submitText
            border.color: "#FFFFFFFF"
            border.width: 2
            height:submitText.height
            color: "#000065"
            opacity: 0.31
            radius: 10

            MouseArea {
                id: mouseAreaSubmit
                anchors.fill: parent
                hoverEnabled: ApplicationInfo.isMobile ? false : true
                onClicked: {
                    if(Activity.checkAnswer())
                    {
                        Activity.showHint()
                    }
                    edit.text=""
                 }
            }
        }

        GCText {
            id: submitText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors{
                bottom: bar.top
                margins: 10
            }
            opacity: 1.0
            text:qsTr("Submit")
            fontSize: mediumSize
            font.bold: true
            style: Text.Outline
            styleColor: "#2a2a2a"
           color: "white"
        }

        Score {
            id: score
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            anchors.right: undefined
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload | config}
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onHomeClicked: activity.home()
            onReloadClicked: {
               edit.text = Qt.binding(function() { return ""})
               hintImage.source=Qt.binding(function() { return ""});
            }
            onPreviousLevelClicked: {
                edit.text = Qt.binding(function() { return ""})
                Activity.previousLevel()
            }
            onNextLevelClicked: {
                edit.text = Qt.binding(function() { return ""})
                Activity.nextLevel()
            }
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues()
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextSubLevel)
            }
        }

        JsonParser {
            id: parser
            onError: console.error("Click_on_letter: Error parsing JSON: " + msg);
        }
}
}

