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
import QtQuick.Dialogs 1.2
import GCompris 1.0
import QtQuick.Layouts 1.1
import "core.js" as Core

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
                width: dialogConfig.width - 30
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                GCText {
                    id: title
                    text: dialogConfig.title
                    width: dialogConfig.width - 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    font.pointSize: 24
                    font.weight: Font.DemiBold
                }
            }
            Rectangle {
                id: background
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
                    flickableDirection: Flickable.VerticalFlick
                    clip: true
                    contentHeight: contentItem.childrenRect.height

                    Column {
                        spacing: 10
                        width: parent.width
                        // Put configuration here
                        GCDialogCheckBox {
                            id: enableAudioVoicesBox
                            text: qsTr("Enable audio voices")
                            checked: isAudioVoicesEnabled
                            onCheckedChanged: {
                                isAudioVoicesEnabled = checked;
                            }
                        }

                        GCDialogCheckBox {
                            id: enableAudioEffectsBox
                            text: qsTr("Enable audio effects")
                            checked: isAudioEffectsEnabled
                            onCheckedChanged: {
                                isAudioEffectsEnabled = checked;
                            }
                        }

                        GCDialogCheckBox {
                            id: enableFullscreenBox
                            text: qsTr("Fullscreen")
                            checked: isFullscreen
                            onCheckedChanged: {
                                isFullscreen = checked;
                            }
                        }

                        GCDialogCheckBox {
                            id: enableVirtualKeyboardBox
                            text: qsTr("Virtual Keyboard")
                            checked: isVirtualKeyboard
                            onCheckedChanged: {
                                isVirtualKeyboard = checked;
                            }
                        }

                        GCDialogCheckBox {
                            id: enableAutomaticDownloadsBox
                            checked: isAutomaticDownloadsEnabled
                            text: qsTr("Enable automatic downloads/updates of sound files")
                            onCheckedChanged: {
                                isAutomaticDownloadsEnabled = checked;
                            }
                        }

                        Row {
                            spacing: 5
                            ComboBox {
                                id: fontBox
                                style: GCComboBoxStyle {}
                                model: fonts
                                width: 250 * ApplicationInfo.ratio
                            }
                            GCText {
                                text: qsTr("Font selector")
                                font.pointSize: 16
                                wrapMode: Text.WordWrap
                            }
                        }

                        Row {
                            spacing: 5
                            ComboBox {
                                id: languageBox
                                style: GCComboBoxStyle {}
                                model: languages
                                width: 250 * ApplicationInfo.ratio

                                onCurrentIndexChanged: voicesRow.localeChanged();
                            }
                            GCText {
                                text: qsTr("Language selector")
                                font.pointSize: 16
                                wrapMode: Text.WordWrap
                            }
                        }

                        Row {
                            id: voicesRow
                            height: enableAudioVoicesBox.height
                            width: parent.width
                            spacing: 5 * ApplicationInfo.ratio

                            property bool haveLocalResource: false

                            function localeChanged() {
                                var localeShort = languages.get(languageBox.currentIndex).locale.substr(0, 2);
                                var language = languages.get(languageBox.currentIndex).text;
                                voicesText.text = language;
                                voicesRow.haveLocalResource = DownloadManager.haveLocalResource(
                                        DownloadManager.getVoicesResourceForLocale(localeShort));
                            }

                            Connections {
                                target: DownloadManager

                                onDownloadFinished: voicesRow.localeChanged()
                            }

                            Item {
                                id: rowSpacer
                                width: 20 * ApplicationInfo.ratio
                                height: parent.height
                            }

                            GCText {
                                id: voicesText
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Sounds")
                            }

                            Image {
                                id: voicesImage
                                anchors.verticalCenter: parent.verticalCenter
                                sourceSize.height: 30 * ApplicationInfo.ratio
                                source: voicesRow.haveLocalResource ? "qrc:/gcompris/src/core/resource/apply.svgz" :
                                    "qrc:/gcompris/src/core/resource/cancel.svgz"
                            }

                            Button {
                                id: voicesButton
                                height: parent.height
                                anchors.verticalCenter: parent.verticalCenter
                                text: voicesRow.haveLocalResource ? qsTr("Check for updates") :
                                    qsTr("Download")
                                style: GCButtonStyle {}

                                onClicked: {
                                    if (DownloadManager.downloadResource(
                                        DownloadManager.getVoicesResourceForLocale(
                                                languages.get(languageBox.currentIndex).locale.substr(0, 2))))
                                    {
                                        var downloadDialog = Core.showDownloadDialog(dialogConfig, {});
                                    }
                                }
                            }
                        }

                        Row {
                            width: parent.width
                            spacing: 5 * ApplicationInfo.ratio

                            GCText {
                                text: qsTr("Difficulty filter:")
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 16
                                height: 50 * ApplicationInfo.ratio
                            }

                            // Padding
                            Item {
                                height: 1
                                width: 10 * ApplicationInfo.ratio
                            }

                            Image {
                                source: "qrc:/gcompris/src/core/resource/bar_next.svgz"
                                anchors.verticalCenter: parent.verticalCenter
                                sourceSize.height: Math.min(50 * ApplicationInfo.ratio, parent.width / 15)

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        filterRepeater.setMin(filterRepeater.min + 1)
                                    }
                                }
                            }

                            // Padding
                            Item {
                                height: 1
                                width: 5 * ApplicationInfo.ratio
                            }

                            // Level filtering
                            Repeater {
                                id: filterRepeater
                                model: 6

                                property int min: ApplicationSettings.filterLevelMin
                                property int max: ApplicationSettings.filterLevelMax

                                function setMin(value) {
                                    var newMin
                                    if(min < 1)
                                        newMin = 1
                                    else if(min > 6)
                                        newMin = 6
                                    else if(max >= value)
                                        newMin = value

                                    if(newMin)
                                        ApplicationSettings.filterLevelMin = newMin
                                }

                                function setMax(value) {
                                    var newMax
                                    if(max < 1)
                                        newMax = 1
                                    else if(max > 6)
                                        newMax = 6
                                    else if(min <= value)
                                        newMax = value

                                    if(newMax)
                                        ApplicationSettings.filterLevelMax = newMax
                                }

                                Image {
                                    source: "qrc:/gcompris/src/core/resource/difficulty" +
                                            (modelData + 1) + ".svgz";
                                    anchors.verticalCenter: parent.verticalCenter
                                    sourceSize.width: Math.min(50 * ApplicationInfo.ratio, parent.width / 15)
                                    opacity: modelData + 1 >= filterRepeater.min &&
                                             modelData + 1 <= filterRepeater.max
                                             ? 1 : 0.4

                                    property int value: modelData + 1

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if(parent.value < filterRepeater.max) {
                                                if(parent.opacity == 1)
                                                    filterRepeater.setMin(parent.value + 1)
                                                else
                                                    filterRepeater.setMin(parent.value)
                                            } else if(parent.value > filterRepeater.min) {
                                                if(parent.opacity == 1)
                                                    filterRepeater.setMax(parent.value - 1)
                                                else
                                                    filterRepeater.setMax(parent.value)
                                            }
                                        }
                                    }
                                }
                            }

                            // Padding
                            Item {
                                height: 1
                                width: 5 * ApplicationInfo.ratio
                            }

                            Image {
                                source: "qrc:/gcompris/src/core/resource/bar_previous.svgz"
                                sourceSize.height: Math.min(50 * ApplicationInfo.ratio, parent.width / 15)
                                anchors.verticalCenter: parent.verticalCenter

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        filterRepeater.setMax(filterRepeater.max - 1)
                                    }
                                }
                            }


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
        source: "qrc:/gcompris/src/core/resource/apply.svgz";
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

    property bool isAudioVoicesEnabled: ApplicationSettings.isAudioVoicesEnabled
    property bool isAudioEffectsEnabled: ApplicationSettings.isAudioEffectsEnabled
    property bool isFullscreen: ApplicationSettings.isFullscreen
    property bool isVirtualKeyboard: ApplicationSettings.isVirtualKeyboard
    property bool isAutomaticDownloadsEnabled: ApplicationSettings.isAutomaticDownloadsEnabled

    onStart: {
        // Synchronize settings with data
        isAudioVoicesEnabled = ApplicationSettings.isAudioVoicesEnabled
        enableAudioVoicesBox.checked = isAudioVoicesEnabled

        isAudioEffectsEnabled = ApplicationSettings.isAudioEffectsEnabled
        enableAudioEffectsBox.checked = isAudioEffectsEnabled

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

        // Set font
        for(var i = 0 ; i < fonts.count ; i ++) {
            if(fonts.get(i).text == ApplicationSettings.font) {
                fontBox.currentIndex = i;
                break;
            }
        }
    }

    function save() {
        ApplicationSettings.isAudioVoicesEnabled = isAudioVoicesEnabled
        ApplicationSettings.isAudioEffectsEnabled = isAudioEffectsEnabled
        ApplicationSettings.isFullscreen = isFullscreen
        ApplicationSettings.isVirtualKeyboard = isVirtualKeyboard
        ApplicationSettings.isAutomaticDownloadsEnabled = isAutomaticDownloadsEnabled

        ApplicationSettings.isEmbeddedFont = fonts.get(fontBox.currentIndex).isLocalResource;
        ApplicationSettings.font = fonts.get(fontBox.currentIndex).text

        if (ApplicationSettings.locale != languages.get(languageBox.currentIndex).locale) {
            ApplicationSettings.locale = languages.get(languageBox.currentIndex).locale
            if (!DownloadManager.haveLocalResource(
                    DownloadManager.getVoicesResourceForLocale(
                            ApplicationInfo.localeShort)))
            {
                // ask for downloading new voices
                var buttonHandler = new Array();
                var dialog;
                buttonHandler[StandardButton.No] = function() {};
                buttonHandler[StandardButton.Yes] = function() {
                    // yes -> start download
                    if (DownloadManager.downloadResource(
                            DownloadManager.getVoicesResourceForLocale(ApplicationInfo.localeShort)))
                        var downloadDialog = Core.showDownloadDialog(main, {});
                };
                dialog = Core.showMessageDialog(dialogConfig,
                        qsTr("You selected a new locale"),
                        qsTr("Do you want to download the corresponding sound files now?"),
                        "",
                        StandardIcon.Question,
                        buttonHandler
                );
            } else // check for udpates or/and register new voices
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

    ListModel {
        id: fonts
        Component.onCompleted: {
            var systemFonts = Qt.fontFamilies();
            var rccFonts = ApplicationInfo.getFontsFromRcc();

            // Remove explicitely all *symbol* and *ding* fonts
            var excludedFonts = ApplicationInfo.getSystemExcludedFonts();
            excludedFonts.push("ding");
            excludedFonts.push("symbol");

            for(var i = 0 ; i < systemFonts.length ; ++ i) {
                var isExcluded = false;
                // Remove symbol fonts
                for(var j = 0 ; j < excludedFonts.length ; ++ j) {
                    if(systemFonts[i].toLowerCase().indexOf(excludedFonts[j].toLowerCase()) != -1) {
                        isExcluded = true;
                        break;
                    }
                }

                // Remove fonts from rcc (if you have a default font from rcc, Qt will add it to systemFonts)
                for(var j = 0 ; j < rccFonts.length ; ++ j) {
                    if(rccFonts[j].toLowerCase().indexOf(systemFonts[i].toLowerCase()) != -1) {
                        isExcluded = true;
                        break;
                    }
                }

                // Finally, we know if we add this font or not
                if(!isExcluded) {
                    fonts.append({ "text": systemFonts[i], "isLocalResource": false });
                }
            }
            for(var i = 0 ; i < rccFonts.length ; ++ i) {
                // Append fonts from resources
                fonts.append({ "text": rccFonts[i], "isLocalResource": true });
            }
        }
    }

    function hasConfigChanged() {
        return (ApplicationSettings.locale != languages.get(languageBox.currentIndex).locale ||
                (ApplicationSettings.font != fonts.get(fontBox.currentIndex).text) ||
                (ApplicationSettings.isEmbeddedFont != fonts.get(fontBox.currentIndex).isLocalResource) ||
                (ApplicationSettings.isAudioVoicesEnabled != isAudioVoicesEnabled) ||
                (ApplicationSettings.isAudioEffectsEnabled != isAudioEffectsEnabled) ||
                (ApplicationSettings.isFullscreen != isFullscreen) ||
                (ApplicationSettings.isVirtualKeyboard != isVirtualKeyboard) ||
                (ApplicationSettings.isAutomaticDownloadsEnabled != isAutomaticDownloadsEnabled)
                );
    }
}
