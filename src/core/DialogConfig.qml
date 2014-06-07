/* GCompris - DialogConfig.qml
 *
 * Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>
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
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1
import GCompris 1.0

Rectangle {
    id: dialogConfig
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000
    property bool isDialog: true
    property string title
    property string content
    signal close
    signal start
    signal pause
    signal play
    signal stop

    visible: false
    title: qsTr("Configuration")
    property QtObject activityInfo: ActivityInfoTree.currentActivity

    Row {
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }

            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: parent.width
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                Text {
                    id: title
                    text: dialogConfig.title
                    width: dialogConfig.width - 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Helvetica"
                    color: "black"
                    font.pointSize: 24
                    font.weight: Font.DemiBold
                }
            }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogConfig.width - 30
                height: dialogConfig.height - 100
                border.color: "black"
                border.width: 2
                anchors.margins: 100

                Flickable {
                    id: flick
                    anchors.margins: 8
                    anchors.fill: parent
                    // contentWidth: textContent.contentWidth
                    // contentHeight: textContent.contentHeight
                    flickableDirection: Flickable.VerticalFlick
                    clip: true

                    Column {
                        spacing: 10
                        // Put configuration here
                        CheckBox {
                            id: enableAudioBox
                            text: qsTr("Enable audio")
                            checked: isAudioEnabled
                            style: CheckBoxStyle {
                                indicator: Image {
                                    sourceSize.height: 50 * ApplicationInfo.ratio
                                    source:
                                        control.checked ? "qrc:/gcompris/src/core/resource/apply.svgz" :
                                                          "qrc:/gcompris/src/core/resource/cancel.svgz"
                                }
                            }
                            onCheckedChanged: {
                                isAudioEnabled = checked;
                            }
                        }

                        CheckBox {
                            id: enableFullscreenBox
                            text: qsTr("Fullscreen")
                            checked: isFullscreen
                            style: CheckBoxStyle {
                                indicator: Image {
                                    sourceSize.height: 50 * ApplicationInfo.ratio
                                    source:
                                        control.checked ? "qrc:/gcompris/src/core/resource/apply.svgz" :
                                                          "qrc:/gcompris/src/core/resource/cancel.svgz"
                                }
                            }
                            onCheckedChanged: {
                                isFullscreen = checked;
                            }
                        }

                        CheckBox {
                            id: enableVirtualKeyboardBox
                            text: qsTr("Virtual Keyboard")
                            checked: isVirtualKeyboard
                            style: CheckBoxStyle {
                                indicator: Image {
                                    sourceSize.height: 50 * ApplicationInfo.ratio
                                    source:
                                        control.checked ? "qrc:/gcompris/src/core/resource/apply.svgz" :
                                                          "qrc:/gcompris/src/core/resource/cancel.svgz"
                                }
                            }
                            onCheckedChanged: {
                                isVirtualKeyboard = checked;
                            }
                        }
                        
                        CheckBox {
                            id: enableAutomaticDownloadsBox
                            text: qsTr("Enable automatic downloads/updates of sound files")
                            checked: isAutomaticDownloadsEnabled
                            style: CheckBoxStyle {
                                indicator: Image {
                                    sourceSize.height: 50 * ApplicationInfo.ratio
                                    source:
                                        control.checked ? "qrc:/gcompris/src/core/resource/apply.svgz" :
                                                          "qrc:/gcompris/src/core/resource/cancel.svgz"
                                }
                            }
                            onCheckedChanged: {
                                isAutomaticDownloadsEnabled = checked;
                            }
                        }

                        ComboBox {
                            id: languageBox
                            style: GCComboBoxStyle {}
                            model: languages
                            width: 200 * ApplicationInfo.ratio
                        }
                    }
                }
            }
            Item { width: 1; height: 10 }
        }
    }

    // The cancel button
    Image {
        id: cancel
        source: "qrc:/gcompris/src/core/resource/cancel.svgz";
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        anchors.top: parent.top
        smooth: true
        sourceSize.width: 60 * ApplicationInfo.ratio
        anchors.margins: 10
        SequentialAnimation {
            id: anim
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                target: cancel
                property: "rotation"
                from: -10; to: 10
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: cancel
                property: "rotation"
                from: 10; to: -10
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(hasConfigChanged())
                    save()
                close()
            }
        }
    }
 
    //function onDownloadProgress(bytesReceived, bytesTotal) {
    //    console.log("progress: " + bytesReceived + "/" + bytesTotal);
    //}
    
    function onDownloadFinished() {
        DownloadManager.downloadFinished.disconnect(onDownloadFinished)
        DownloadManager.error.disconnect(onDownloadError)
    }
    
    function onDownloadError(error) {
        errorDialog.text = error;
        errorDialog.open();
        onDownloadFinished();
    }

    MessageDialog {
        id: errorDialog
        
        title: qsTr("Download Error")
        icon: StandardIcon.Warning
        standardButtons: StandardButton.Ignore
        visible: false
    }
      
    MessageDialog {
        id: messageDialog
        
        title: qsTr("You selected a new locale")
        text: qsTr("Do you want to download the corresponding sound files?")
        icon: StandardIcon.Question
        standardButtons: StandardButton.Yes | StandardButton.No
        
        visible: false
        
        property bool initialized: false  // workaround onYes handler triggered twice in Qt 5.3 (bug #35933)
        
        onYes: {
            if (!messageDialog.initialized)
                return;
            messageDialog.initialized = false;
            console.log("yes");
            if (DownloadManager.downloadResource(DownloadManager.getVoicesResourceForLocale(ApplicationInfo.localeShort))
) {
                //DownloadManager.downloadProgress.connect(onDownloadProgress);
                // note: for visualizing download progress probably need an
                // own custom element. Android does not seem to allow changing
                // contents of a message dialog dynamically 
                DownloadManager.downloadFinished.connect(onDownloadFinished);
                DownloadManager.error.connect(onDownloadError);
            }
            messageDialog.close()
        }
    }

    property bool isAudioEnabled: ApplicationSettings.isAudioEnabled
    property bool isFullscreen: ApplicationSettings.isFullscreen
    property bool isVirtualKeyboard: ApplicationSettings.isVirtualKeyboard
    property bool isAutomaticDownloadsEnabled: ApplicationSettings.isAutomaticDownloadsEnabled

    onStart: {
        // Synchronize settings with data
        isAudioEnabled = ApplicationSettings.isAudioEnabled
        enableAudioBox.checked = isAudioEnabled

        isFullscreen = ApplicationSettings.isFullscreen
        enableFullscreenBox.checked = isFullscreen

        isVirtualKeyboard = ApplicationSettings.isVirtualKeyboard
        enableVirtualKeyboardBox.checked = isVirtualKeyboard

        isAutomaticDownloadsEnabled = ApplicationSettings.isAutomaticDownloadsEnabled
        enableAutomaticDownloadsBox.checked = isAutomaticDownloadsEnabled

        // Set locale
        for(var i = 0 ; i < languages.count ; i ++) {
            if(languages.get(i).locale == ApplicationSettings.locale) {
                languageBox.currentIndex = i;
                break;
            }
        }
    }

    function save() {
        ApplicationSettings.isAudioEnabled = isAudioEnabled
        ApplicationSettings.isFullscreen = isFullscreen
        ApplicationSettings.isVirtualKeyboard = isVirtualKeyboard
        ApplicationSettings.isAutomaticDownloadsEnabled = isAutomaticDownloadsEnabled
        if (ApplicationSettings.locale != languages.get(languageBox.currentIndex).locale) {
            ApplicationSettings.locale = languages.get(languageBox.currentIndex).locale
            if (!DownloadManager.haveLocalResource(DownloadManager.getVoicesResourceForLocale(ApplicationInfo.localeShort))) {
                messageDialog.initialized = true
                messageDialog.open()
            } else
                DownloadManager.updateResource(DownloadManager.getVoicesResourceForLocale(ApplicationInfo.localeShort))
        }
    }

    ListModel {
        id: languages

        // This is done this way for having the translations
        Component.onCompleted: {
            languages.append( { "text": qsTr("English (Great Britain)"), "locale": "en_GB.UTF-8" })
            languages.append( { "text": qsTr("English (United States)"), "locale": "en_US.UTF-8" } )
            languages.append( { "text": qsTr("Bulgarian"), "locale": "bg_BG.UTF-8" } )
            languages.append( { "text": qsTr("Breton"), "locale": "br_FR.UTF-8" } )
            languages.append( { "text": qsTr("Czech Republic"), "locale": "cs_CZ.UTF-8" } )
            languages.append( { "text": qsTr("Danish"), "locale": "da_DK.UTF-8" } )
            languages.append( { "text": qsTr("German"), "locale": "de_DE.UTF-8" } )
            languages.append( { "text": qsTr("Greek"), "locale": "el_GR.UTF-8" } )
            languages.append( { "text": qsTr("Spanish"), "locale": "es_ES.UTF-8" } )
            languages.append( { "text": qsTr("French"), "locale": "fr_FR.UTF-8" } )
            languages.append( { "text": qsTr("Scottish Gaelic"), "locale": "gd_GB.UTF-8" } )
            languages.append( { "text": qsTr("Galician"), "locale": "gl_ES.UTF-8" } )
            languages.append( { "text": qsTr("Hungarian"), "locale": "hu_HU.UTF-8" } )
            languages.append( { "text": qsTr("Lithuanian"), "locale": "lt_LT.UTF-8" } )
            languages.append( { "text": qsTr("Latvian"), "locale": "lv_LV.UTF-8" } )
            languages.append( { "text": qsTr("Dutch"), "locale": "nl_NL.UTF-8" } )
            languages.append( { "text": qsTr("Norwegian Nynorsk"), "locale": "nn_NO.UTF-8" } )
            languages.append( { "text": qsTr("Polish"), "locale": "pl_PL.UTF-8" } )
            languages.append( { "text": qsTr("Russian"), "locale": "ru_RU.UTF-8" } )
            languages.append( { "text": qsTr("Portuguese (Brazil)"), "locale": "pt_BR.UTF-8" } )
            languages.append( { "text": qsTr("Slovak"), "locale": "sk_SK.UTF-8" } )
            languages.append( { "text": qsTr("Slovenian"), "locale": "sl_SI.UTF-8" } )
            languages.append( { "text": qsTr("Montenegrin"), "locale": "sr_ME.UTF-8" } )
            languages.append( { "text": qsTr("Swedish"), "locale": "sv_FI.UTF-8" } )
            languages.append( { "text": qsTr("Tamil"), "locale": "ta_IN.UTF-8" } )
            languages.append( { "text": qsTr("Thai"), "locale": "th_TH.UTF-8" } )
            languages.append( { "text": qsTr("Chinese (Traditional)"), "locale": "zh_TW.UTF-8" } )
        }
    }

    function hasConfigChanged() {
        return (ApplicationSettings.locale != languages.get(languageBox.currentIndex).locale ||
                (ApplicationSettings.isAudioEnabled != isAudioEnabled) ||
                (ApplicationSettings.isFullscreen != isFullscreen) ||
                (ApplicationSettings.isVirtualKeyboard != isVirtualKeyboard) ||
                (ApplicationSettings.isAutomaticDownloadsEnabled != isAutomaticDownloadsEnabled)
                );
    }
}
