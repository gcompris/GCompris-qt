/* GCompris - ConfigurationItem.qml
 *
 * Copyright (C) 2014-2016 Johnny Jazeix <jazeix@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: dialogConfig

    property var languages: allLangs.languages
    height: column.height

    LanguageList {
        id: allLangs
    }

    Column {
        id: column
        spacing: 10
        width: parent.width

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 120 }
        }

        // Put configuration here
        Row {
            id: demoModeBox
            width: parent.width
            spacing: 10

            property bool checked: !ApplicationSettings.isDemoMode

            Image {
                sourceSize.height: 50 * ApplicationInfo.ratio
                source:
                demoModeBox.checked ? "qrc:/gcompris/src/core/resource/apply.svg" :
                "qrc:/gcompris/src/core/resource/cancel.svg"
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
                    if(ApplicationSettings.activationMode == 1) {
                        if(ApplicationSettings.isDemoMode)
                            ApplicationSettings.isDemoMode = false
                    } else if(ApplicationSettings.activationMode == 2) {
                        activationCodeEntry.visible = !activationCodeEntry.visible
                    }
                }
            }
        }

        Column {
            id: activationCodeEntry
            width: parent.width
            spacing: 10
            visible: false
            opacity: 0

            Behavior on opacity { NumberAnimation { duration: 200 } }

            onVisibleChanged: {
                if(visible) {
                    activationInput.forceActiveFocus()
                    activationInput.cursorPosition = 0
                    opacity = 1
                } else {
                    activationInput.focus = false
                    opacity = 0
                }
            }

            GCText {
                id: activationInstruction
                fontSize: regularSize
                color: "black"
                style: Text.Outline
                styleColor: "white"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: TextEdit.WordWrap
                text: qsTr("On <a href='https://gcompris.net'>https://gcompris.net</a> " +
                           "you will find the instructions to obtain an activation code.")
                Component.onCompleted: ApplicationInfo.isDownloadAllowed ?
                                           linkActivated.connect(Qt.openUrlExternally) : null
            }

            TextInput {
                id: activationInput
                width: parent.width
                focus: true
                font.weight: Font.DemiBold
                font.pointSize: ApplicationSettings.baseFontSize
                                + 14 * ApplicationInfo.fontRatio
                color: 'black'
                horizontalAlignment: Text.AlignHCenter
                inputMask: '>HHHH-HHHH-HHHH;#'
                text: ApplicationSettings.codeKey
                onTextChanged: {
                    var code = text.replace(/-/g,'')
                    var codeValidity = ApplicationSettings.checkActivationCode(code);
                    switch (codeValidity) {
                    case 0:
                        activationMsg.text = qsTr('Enter your activation code');
                        break;
                    case 1:
                        activationMsg.text = qsTr('Sorry, your code is too old for this version of GCompris');
                        break;
                    case 2:
                        activationMsg.text = qsTr('Your code is valid, thanks a lot for your support');
                        activationCodeEntry.visible = false
                        ApplicationSettings.codeKey = code
                        break;
                    }
                }
            }

            GCText {
                id: activationMsg
                width: parent.width
                color: "black"
                fontSize: regularSize
                horizontalAlignment: TextInput.AlignHCenter
                wrapMode: TextEdit.WordWrap
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
            visible: !ApplicationInfo.isMobile
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
            visible: ApplicationInfo.isDownloadAllowed
            onCheckedChanged: {
                isAutomaticDownloadsEnabled = checked;
            }
        }

        /* Technically wordset config is a string that holds the wordset name or '' for the
        * internal wordset. But as we support only internal and words its best to show the
        * user a boolean choice.
        */
        GCDialogCheckBox {
            id: wordsetBox
            checked: DownloadManager.isDataRegistered("words")
            text: enabled ? qsTr("Use full word image set") : qsTr("Download full word image set")
            visible: ApplicationInfo.isDownloadAllowed
            enabled: !DownloadManager.isDataRegistered("words")
            onCheckedChanged: {
                wordset = checked ? 'data2/words/words.rcc' : '';
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
            GCComboBox {
                id: fontBox
                model: fonts
                background: dialogActivityConfig
                label: qsTr("Font selector")
            }
        }
        Flow {
            spacing: 5
            width: parent.width
            GCSlider {
                id: baseFontSizeSlider
                width: 250 * ApplicationInfo.ratio
                maximumValue: ApplicationSettings.baseFontSizeMax
                minimumValue: ApplicationSettings.baseFontSizeMin
                value: baseFontSize
                onValueChanged: ApplicationSettings.baseFontSize = value;
                scrollEnabled: false
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
            GCComboBox {
                id: fontCapitalizationBox
                model: fontCapitalizationModel
                background: dialogActivityConfig
                label: qsTr("Font Capitalization")
            }
        }
        Flow {
            spacing: 5
            width: parent.width
            GCSlider {
                id: fontLetterSpacingSlider
                width: 250 * ApplicationInfo.ratio
                maximumValue: ApplicationSettings.fontLetterSpacingMax
                minimumValue: ApplicationSettings.fontLetterSpacingMin
                value: fontLetterSpacing
                onValueChanged: ApplicationSettings.fontLetterSpacing = value;
                scrollEnabled: false
            }
            GCText {
                id: fontLetterSpacingText
                text: qsTr("Font letter spacing")
                fontSize: mediumSize
                wrapMode: Text.WordWrap
            }
            Button {
                height: 30 * ApplicationInfo.ratio
                text: qsTr("Default");
                style: GCButtonStyle {}
                onClicked: fontLetterSpacingSlider.value = ApplicationSettings.fontLetterSpacingMin
            }
        }
        Flow {
            spacing: 5
            width: parent.width
            GCComboBox {
                id: languageBox
                model: dialogConfig.languages
                background: dialogActivityConfig
                onCurrentIndexChanged: voicesRow.localeChanged();
                label: qsTr("Language selector")
            }
        }

        Flow {
            id: voicesRow
            width: parent.width
            spacing: 5 * ApplicationInfo.ratio

            property bool haveLocalResource: false

            function localeChanged() {
                var language = dialogConfig.languages[languageBox.currentIndex].text;
                voicesRow.haveLocalResource = DownloadManager.isDataRegistered(
                            "voices-" + ApplicationInfo.CompressedAudio + "/" +
                            ApplicationInfo.getVoicesLocale(dialogConfig.languages[languageBox.currentIndex].locale)
                            )
            }

            Connections {
                target: DownloadManager

                onDownloadFinished: voicesRow.localeChanged()
            }

            GCText {
                id: voicesText
                text: qsTr("Localized voices")
                fontSize: mediumSize
                wrapMode: Text.WordWrap
            }

            Image {
                id: voicesImage
                sourceSize.height: 30 * ApplicationInfo.ratio
                source: voicesRow.haveLocalResource ? "qrc:/gcompris/src/core/resource/apply.svg" :
                "qrc:/gcompris/src/core/resource/cancel.svg"
            }

            Button {
                id: voicesButton
                height: 30 * ApplicationInfo.ratio
                visible: ApplicationInfo.isDownloadAllowed
                text: voicesRow.haveLocalResource ? qsTr("Check for updates") :
                qsTr("Download")
                style: GCButtonStyle {}

                onClicked: {
                    if (DownloadManager.downloadResource(
                    DownloadManager.getVoicesResourceForLocale(dialogConfig.languages[languageBox.currentIndex].locale)))
                    {
                        var downloadDialog = Core.showDownloadDialog(dialogConfig.parent.rootItem, {});
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
                source: "qrc:/gcompris/src/core/resource/bar_next.svg"
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
                    (modelData + 1) + ".svg";
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
                source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
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

    property bool showLockedActivities: ApplicationSettings.showLockedActivities
    property bool isAudioVoicesEnabled: ApplicationSettings.isAudioVoicesEnabled
    property bool isAudioEffectsEnabled: ApplicationSettings.isAudioEffectsEnabled
    property bool isFullscreen: ApplicationSettings.isFullscreen
    property bool isVirtualKeyboard: ApplicationSettings.isVirtualKeyboard
    property bool isAutomaticDownloadsEnabled: ApplicationSettings.isAutomaticDownloadsEnabled
    property bool sectionVisible: ApplicationSettings.sectionVisible
    property string wordset: ApplicationSettings.wordset
    property int baseFontSize  // don't bind to ApplicationSettings.baseFontSize
    property real fontLetterSpacing // don't bind to ApplicationSettings.fontLetterSpacing
    // or we get a binding loop warning

    function loadFromConfig() {
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

        wordset = ApplicationSettings.wordset
        wordsetBox.checked = DownloadManager.isDataRegistered("words") || ApplicationSettings.wordset == 'data2/words/words.rcc'
        wordsetBox.enabled = !DownloadManager.isDataRegistered("words")

        baseFontSize = ApplicationSettings.baseFontSize;
        fontLetterSpacing = ApplicationSettings.fontLetterSpacing;
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

        // Set font capitalization
        for(var i = 0 ; i < fontCapitalizationModel.length ; i ++) {
            if(fontCapitalizationModel[i].value == ApplicationSettings.fontCapitalization) {
                fontCapitalizationBox.currentIndex = i;
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
        ApplicationSettings.wordset = wordset

        ApplicationSettings.isEmbeddedFont = fonts.get(fontBox.currentIndex).isLocalResource;
        ApplicationSettings.font = fonts.get(fontBox.currentIndex).text
        ApplicationSettings.fontCapitalization = fontCapitalizationModel[fontCapitalizationBox.currentIndex].value

        ApplicationSettings.saveBaseFontSize();
        ApplicationSettings.notifyFontLetterSpacingChanged();

        if (ApplicationSettings.locale != dialogConfig.languages[languageBox.currentIndex].locale) {
            ApplicationSettings.locale = dialogConfig.languages[languageBox.currentIndex].locale
            if(ApplicationInfo.isDownloadAllowed && !DownloadManager.isDataRegistered(
                        "voices-" + ApplicationInfo.CompressedAudio + "/" +
                        ApplicationInfo.getVoicesLocale(dialogConfig.languages[languageBox.currentIndex].locale)
                        ))
            {
                // ask for downloading new voices
                Core.showMessageDialog(main,
                qsTr("You selected a new locale. You need to restart GCompris to play in your new locale.<br/>Do you want to download the corresponding sound files now?"),
                qsTr("Yes"), function() {
                    // yes -> start download
                    if (DownloadManager.downloadResource(
                    DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale)))
                    var downloadDialog = Core.showDownloadDialog(main, {});
                },
                qsTr("No"), null,
                null
                );
            } else {
                // check for updates or/and register new voices
                DownloadManager.updateResource(
                            DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale))
            }
        }
        // download words.rcc if needed
        if(ApplicationSettings.wordset != "") {
            // we want to use the external dataset, it is either in
            // words/words.rcc or full-${CA}.rcc
            if(DownloadManager.isDataRegistered("words")) {
                // we either have it, we try to update in the background
                // or we are downloading it
                if(DownloadManager.haveLocalResource(wordset))
                    DownloadManager.updateResource(wordset)
            }
            else {
                // download automatically if automatic download else ask for download
                if(isAutomaticDownloadsEnabled) {
                    var prevAutomaticDownload = ApplicationSettings.isAutomaticDownloadsEnabled
                    ApplicationSettings.isAutomaticDownloadsEnabled = true;
                    DownloadManager.updateResource(wordset);
                    ApplicationSettings.isAutomaticDownloadsEnabled = prevAutomaticDownload
                }
                else {
                    Core.showMessageDialog(main,
                    qsTr("The images for several activities are not yet installed. ")
                    + qsTr("Do you want to download them now?"),
                    qsTr("Yes"),
                    function() {
                        if (DownloadManager.downloadResource(wordset))
                        var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
                    },
                    qsTr("No"), function() { ApplicationSettings.wordset = '' },
                    null
                    );
                }
            }
        }
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

            // first display fonts from rcc
            for(var i = 0 ; i < rccFonts.length ; ++ i) {
                // Append fonts from resources
                fonts.append({ "text": rccFonts[i], "isLocalResource": true });
            }

            for(var i = 0 ; i < systemFonts.length ; ++ i) {
                var isExcluded = false;
                var systemFont = systemFonts[i].toLowerCase();
                // Remove symbol fonts
                for(var j = 0 ; j < excludedFonts.length ; ++ j) {
                    if(systemFont.indexOf(excludedFonts[j].toLowerCase()) != -1) {
                        isExcluded = true;
                        break;
                    }
                }

                // Remove fonts from rcc (if you have a default font from rcc, Qt will add it to systemFonts)
                for(var j = 0 ; j < rccFonts.length ; ++ j) {
                    if(rccFonts[j].toLowerCase().indexOf(systemFont) != -1) {
                        isExcluded = true;
                        break;
                    }
                }

                // Finally, we know if we add this font or not
                if(!isExcluded) {
                    fonts.append({ "text": systemFonts[i], "isLocalResource": false });
                }
            }
        }
    }

    property var fontCapitalizationModel: [
        { text: qsTr("Mixed case (default)"), value: Font.MixedCase },
        { text: qsTr("All uppercase"), value: Font.AllUppercase },
        { text: qsTr("All lowercase"), value: Font.AllLowercase }
    ]

    function hasConfigChanged() {
        return (ApplicationSettings.locale !== dialogConfig.languages[languageBox.currentIndex].locale ||
        (ApplicationSettings.sectionVisible != sectionVisible) ||
        (ApplicationSettings.wordset != wordset) ||
        (ApplicationSettings.font != fonts.get(fontBox.currentIndex).text) ||
        (ApplicationSettings.isEmbeddedFont != fonts.get(fontBox.currentIndex).isLocalResource) ||
        (ApplicationSettings.isEmbeddedFont != fonts.get(fontBox.currentIndex).isLocalResource) ||
        (ApplicationSettings.fontCapitalization != fontCapitalizationModel[(fontcapitalizationBox.currentIndex)].value) ||
        (ApplicationSettings.fontLetterSpacing != fontLetterSpacing) ||
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

    
