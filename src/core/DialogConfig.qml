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
import GCompris 1.0
import QtQuick.Layouts 1.1
import "core.js" as Core

Rectangle {
    id: dialogConfig
    color: "#696da3"
    border.color: "black"
    border.width: 1
    z: 1000
    property QtObject main
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
    // Put here the locales for which we have a good enough translation
    property var languages: [
            { "text": qsTr("Your system default"), "locale": "system" },
            { "text": "UK English", "locale": "en_GB.UTF-8" },
            { "text": "American English", "locale": "en_US.UTF-8" },
            { "text": "български", "locale": "bg_BG.UTF-8" },
            { "text": "Brezhoneg", "locale": "br_FR.UTF-8" },
            { "text": "Català", "locale": "ca_ES.UTF-8" },
            { "text": "Česká", "locale": "cs_CZ.UTF-8" },
            { "text": "Dansk", "locale": "da_DK.UTF-8" },
            { "text": "Deutsch", "locale": "de_DE.UTF-8" },
            { "text": "Ελληνικά", "locale": "el_GR.UTF-8" },
            { "text": "Español", "locale": "es_ES.UTF-8" },
            { "text": "Suomi", "locale": "fi_FI.UTF-8" },
            { "text": "Français", "locale": "fr_FR.UTF-8" },
            { "text": "Gàidhlig", "locale": "gd_GB.UTF-8" },
            { "text": "Galego", "locale": "gl_ES.UTF-8" },
            { "text": "Magyar", "locale": "hu_HU.UTF-8" },
            { "text": "Italiano", "locale": "it_IT.UTF-8" },
            { "text": "Lietuvių", "locale": "lt_LT.UTF-8" },
            { "text": "Latviešu", "locale": "lv_LV.UTF-8" },
            { "text": "Nederlands", "locale": "nl_NL.UTF-8" },
            { "text": "Norsk (nynorsk)", "locale": "nn_NO.UTF-8" },
            { "text": "Polski", "locale": "pl_PL.UTF-8" },
            { "text": "Português", "locale": "pt_PT.UTF-8" },
            { "text": "Português do Brasil", "locale": "pt_BR.UTF-8" },
            { "text": "Русский", "locale": "ru_RU.UTF-8" },
            { "text": "Slovenský", "locale": "sk_SK.UTF-8" },
            { "text": "Slovenski", "locale": "sl_SI.UTF-8" },
            { "text": "црногорски jeзик", "locale": "sr_ME.UTF-8" },
            { "text": "Svenska", "locale": "sv_FI.UTF-8" },
            { "text": "தமிழ்", "locale": "ta_IN.UTF-8" },
            { "text": "ไทย", "locale": "th_TH.UTF-8" },
            { "text": "український", "locale": "uk_UA.UTF-8" },
            { "text": "中文（简体）", "locale": "zh_CN.UTF-8" },
            { "text": "繁體中文", "locale": "zh_TW.UTF-8" }
        ]

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
                    fontSize: largeSize
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
                    // On mobile we miss some room at the bottom, arbitrary add some
                    contentHeight: contentItem.childrenRect.height + 40 * ApplicationInfo.ratio

                    Column {
                        spacing: 10
                        width: parent.width
                        // Put configuration here
                        Row {
                            id: demoModeBox
                            width: parent.width
                            spacing: 10

                            property bool checked: !ApplicationSettings.isDemoMode

                            Image {
                                    sourceSize.height: 50 * ApplicationInfo.ratio
                                    source:
                                        demoModeBox.checked ? "qrc:/gcompris/src/core/resource/apply.svgz" :
                                                              "qrc:/gcompris/src/core/resource/cancel.svgz"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if(ApplicationSettings.isDemoMode)
                                                ApplicationSettings.isDemoMode = false
                                        }
                                    }
                            }

                            Button {
                                width: parent.parent.width - 50 * ApplicationInfo.ratio - 10 * 2
                                height: parent.height
                                enabled: ApplicationSettings.isDemoMode
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: demoModeBox.checked ? qsTr("You have the full version") :
                                                            qsTr("Buy the full version").toUpperCase()
                                style: ButtonStyle {
                                    background: Rectangle {
                                        implicitWidth: 100
                                        implicitHeight: 25
                                        border.width: control.activeFocus ? 4 : 2
                                        border.color: "black"
                                        radius: 10
                                        gradient: Gradient {
                                            GradientStop { position: 0 ; color: control.pressed ? "#87ff5c" :
                                                                                                  ApplicationSettings.isDemoMode ? "#ffe85c" : "#EEEEEE"}
                                            GradientStop { position: 1 ; color: control.pressed ? "#44ff00" :
                                                                                                  ApplicationSettings.isDemoMode ? "#f8d600" : "#AAAAAA"}
                                        }
                                    }
                                    label: GCText {
                                        text: control.text
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        wrapMode: Text.WordWrap
                                    }
                                }

                                onClicked: {
                                    if(ApplicationSettings.isDemoMode)
                                        ApplicationSettings.isDemoMode = false
                                }
                            }
                        }

                        GCDialogCheckBox {
                            id: displayLockedActivitiesBox
                            text: qsTr("Show locked activities")
                            visible: ApplicationSettings.isDemoMode
                            checked: showLockedActivities
                            onCheckedChanged: {
                                showLockedActivities = checked;
                            }
                        }

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

                        GCDialogCheckBox {
                            id: sectionVisibleBox
                            checked: sectionVisible
                            text: qsTr("The activity section menu is visible")
                            onCheckedChanged: {
                                sectionVisible = checked;
                            }
                        }

                        Flow {
                            spacing: 5
                            width: parent.width
                            ComboBox {
                                id: fontBox
                                style: GCComboBoxStyle {}
                                model: fonts
                                width: 250 * ApplicationInfo.ratio
                            }
                            GCText {
                                text: qsTr("Font selector")
                                fontSize: mediumSize
                                wrapMode: Text.WordWrap
                            }
                        }
                        Flow {
                            spacing: 5
                            width: parent.width
                            Slider {
                                id: baseFontSizeSlider
                                width: 250 * ApplicationInfo.ratio
                                style: GCSliderStyle {}
                                maximumValue: ApplicationSettings.baseFontSizeMax
                                minimumValue: ApplicationSettings.baseFontSizeMin
                                stepSize: 1.0
                                tickmarksEnabled: true
                                updateValueWhileDragging: true
                                value: baseFontSize
                                onValueChanged: ApplicationSettings.baseFontSize = value;
                            }
                            GCText {
                                id: baseFontSizeText
                                text: qsTr("Font size")
                                fontSize: mediumSize
                                wrapMode: Text.WordWrap
                            }
                            Button {
                                height: 30 * ApplicationInfo.ratio
                                text: qsTr("Default");
                                style: GCButtonStyle {}
                                onClicked: baseFontSizeSlider.value = 0.0
                            }
                        }
                        Flow {
                            spacing: 5
                            width: parent.width
                            ComboBox {
                                id: languageBox
                                style: GCComboBoxStyle {}
                                model: dialogConfig.languages
                                width: 300 * ApplicationInfo.ratio

                                onCurrentIndexChanged: voicesRow.localeChanged();
                            }
                            GCText {
                                text: qsTr("Language selector")
                                fontSize: mediumSize
                                wrapMode: Text.WordWrap
                            }
                        }

                        Flow {
                            id: voicesRow
                            width: parent.width
                            spacing: 5 * ApplicationInfo.ratio

                            property bool haveLocalResource: false

                            function localeChanged() {
                                var language = dialogConfig.languages[languageBox.currentIndex].text;
                                voicesText.text = language;
                                voicesRow.haveLocalResource = DownloadManager.haveLocalResource(
                                        DownloadManager.getVoicesResourceForLocale(
                                                dialogConfig.languages[languageBox.currentIndex].locale));
                            }

                            Connections {
                                target: DownloadManager

                                onDownloadFinished: voicesRow.localeChanged()
                            }

                            GCText {
                                id: voicesText
                                text: qsTr("Sounds")
                            }

                            Image {
                                id: voicesImage
                                sourceSize.height: 30 * ApplicationInfo.ratio
                                source: voicesRow.haveLocalResource ? "qrc:/gcompris/src/core/resource/apply.svgz" :
                                    "qrc:/gcompris/src/core/resource/cancel.svgz"
                            }

                            Button {
                                id: voicesButton
                                height: 30 * ApplicationInfo.ratio
                                text: voicesRow.haveLocalResource ? qsTr("Check for updates") :
                                    qsTr("Download")
                                style: GCButtonStyle {}

                                onClicked: {
                                    if (DownloadManager.downloadResource(
                                        DownloadManager.getVoicesResourceForLocale(dialogConfig.languages[languageBox.currentIndex].locale)))
                                    {
                                        var downloadDialog = Core.showDownloadDialog(dialogConfig, {});
                                    }
                                }
                            }
                        }

                        Flow {
                            width: parent.width
                            spacing: 5 * ApplicationInfo.ratio

                            GCText {
                                text: qsTr("Difficulty filter:")
                                fontSize: mediumSize
                                height: 50 * ApplicationInfo.ratio
                            }

                            // Padding
                            Item {
                                height: 1
                                width: 10 * ApplicationInfo.ratio
                            }

                            Image {
                                source: "qrc:/gcompris/src/core/resource/bar_next.svgz"
                                sourceSize.height: Math.min(50 * ApplicationInfo.ratio, parent.width / 8)

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
                                    sourceSize.width: Math.min(50 * ApplicationInfo.ratio, parent.width / 8)
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
                                sourceSize.height: Math.min(50 * ApplicationInfo.ratio, parent.width / 8)

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
    GCButtonCancel {
        onClose: {
            if(hasConfigChanged())
                save();
            parent.close()
        }
    }

    property bool showLockedActivities: ApplicationSettings.showLockedActivities
    property bool isAudioVoicesEnabled: ApplicationSettings.isAudioVoicesEnabled
    property bool isAudioEffectsEnabled: ApplicationSettings.isAudioEffectsEnabled
    property bool isFullscreen: ApplicationSettings.isFullscreen
    property bool isVirtualKeyboard: ApplicationSettings.isVirtualKeyboard
    property bool isAutomaticDownloadsEnabled: ApplicationSettings.isAutomaticDownloadsEnabled
    property bool sectionVisible: ApplicationSettings.sectionVisible
    property int baseFontSize  // don't bind to ApplicationSettings.baseFontSize
                               // or we get a binding loop warning

    onStart: {
        // Synchronize settings with data
        showLockedActivities = ApplicationSettings.showLockedActivities
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

        sectionVisible = ApplicationSettings.sectionVisible
        sectionVisibleBox.checked = sectionVisible

        baseFontSize = ApplicationSettings.baseFontSize;

        // Set locale
        for(var i = 0 ; i < dialogConfig.languages.length ; i ++) {
            if(dialogConfig.languages[i].locale === ApplicationSettings.locale) {
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
        ApplicationSettings.showLockedActivities = showLockedActivities
        ApplicationSettings.isAudioVoicesEnabled = isAudioVoicesEnabled
        ApplicationSettings.isAudioEffectsEnabled = isAudioEffectsEnabled
        ApplicationSettings.isFullscreen = isFullscreen
        ApplicationSettings.isVirtualKeyboard = isVirtualKeyboard
        ApplicationSettings.isAutomaticDownloadsEnabled = isAutomaticDownloadsEnabled
        ApplicationSettings.sectionVisible = sectionVisible

        ApplicationSettings.isEmbeddedFont = fonts.get(fontBox.currentIndex).isLocalResource;
        ApplicationSettings.font = fonts.get(fontBox.currentIndex).text

        ApplicationSettings.saveBaseFontSize();

        if (ApplicationSettings.locale != dialogConfig.languages[languageBox.currentIndex].locale) {
            ApplicationSettings.locale = dialogConfig.languages[languageBox.currentIndex].locale
            if (!DownloadManager.haveLocalResource(
                    DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale)))
            {
                // ask for downloading new voices
                Core.showMessageDialog(main,
                        qsTr("You selected a new locale") + '\n'
                        + qsTr("Do you want to download the corresponding sound files now?"),
                        "YES", function() {
                            // yes -> start download
                            if (DownloadManager.downloadResource(
                                        DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale)))
                                var downloadDialog = Core.showDownloadDialog(main, {});
                        },
                        "NO", null,
                        null
                );
            } else // check for udpates or/and register new voices
                DownloadManager.updateResource(
                        DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale))
        }
    }

    function reset()
    {
        ApplicationSettings.baseFontSize = baseFontSize;
    }

    ListModel {
        id: fonts
        Component.onCompleted: {
            var systemFonts = Qt.fontFamilies();
            var rccFonts = ApplicationInfo.getFontsFromRcc();

            // Remove explicitly all *symbol* and *ding* fonts
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
        return (ApplicationSettings.locale !== dialogConfig.languages[languageBox.currentIndex].locale ||
                (ApplicationSettings.sectionVisible != sectionVisible) ||
                (ApplicationSettings.font != fonts.get(fontBox.currentIndex).text) ||
                (ApplicationSettings.isEmbeddedFont != fonts.get(fontBox.currentIndex).isLocalResource) ||
                (ApplicationSettings.isAudioVoicesEnabled != isAudioVoicesEnabled) ||
                (ApplicationSettings.isAudioEffectsEnabled != isAudioEffectsEnabled) ||
                (ApplicationSettings.isFullscreen != isFullscreen) ||
                (ApplicationSettings.isVirtualKeyboard != isVirtualKeyboard) ||
                (ApplicationSettings.isAutomaticDownloadsEnabled != isAutomaticDownloadsEnabled) ||
                (ApplicationSettings.baseFontSize != baseFontSize) ||
                (ApplicationSettings.showLockedActivities != showLockedActivities)
                );
    }
}
