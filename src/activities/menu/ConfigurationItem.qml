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
import QtMultimedia 5.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: dialogConfig

    property var languages: allLangs.languages
    property int contentWidth: Math.floor(dialogConfig.width * 0.9)
    height: contentColumn.height

    LanguageList {
        id: allLangs
        inMenu: true
    }

    Column {
        id: contentColumn
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 120 }
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

        GCText {
            id: audioEffectsVolumeText
            text: qsTr("Audio effects volume")
            width: dialogConfig.contentWidth
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }

        GCSlider {
            id: audioEffectsVolumeSlider
            width: 250 * ApplicationInfo.ratio
            maximumValue: 10
            minimumValue: 0
            value: audioEffectsVolume * 10
            onValueChanged: ApplicationSettings.audioEffectsVolume = value / 10;
            scrollEnabled: false
        }

	    GCDialogCheckBox {
           id: enableBackgroundMusicBox
            text: qsTr("Enable background music")
            checked: isBackgroundMusicEnabled
            onCheckedChanged: {
                isBackgroundMusicEnabled = checked;
            }
        }

        Flow {
            spacing: 5 * ApplicationInfo.ratio
            width: dialogConfig.contentWidth
            GCText {
                text: qsTr("Background Music")
                fontSize: mediumSize
            }
            Image {
                source: "qrc:/gcompris/src/core/resource/bar_next.svg"
                height: parent.height
                sourceSize.width: height

                MouseArea {
                    anchors.fill: parent
                    enabled: (backgroundMusic.playbackState == Audio.PlayingState && !backgroundMusic.muted)
                    onClicked: backgroundMusic.nextAudio()
                }
            }
        }

        Button {
            id: backgroundMusicName
            height: 30 * ApplicationInfo.ratio
            width: background.width * 0.8
            text: {
                if(backgroundMusic.playbackState != Audio.PlayingState)
                    return qsTr("Not playing")
                else if (backgroundMusic.metaDataMusic[0] != undefined)
                    return (qsTr("Title: %1  Artist: %2").arg(backgroundMusic.metaDataMusic[0]).arg(backgroundMusic.metaDataMusic[1]))
                else if (String(backgroundMusic.source).slice(0, 37) === "qrc:/gcompris/src/core/resource/intro")
                    return qsTr("Introduction music")
                return ""
            }
            style: GCButtonStyle {}
            onClicked: {
                dialogConfig.visible = false
                backgroundMusicList.visible = true
            }
        }

        GCText {
            id: backgroundMusicVolumeText
            text: qsTr("Background music volume")
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }

        GCSlider {
            id: backgroundMusicVolumeSlider
            width: 250 * ApplicationInfo.ratio
            maximumValue: 10
            minimumValue: 0
            value: backgroundMusicVolume * 10
            onValueChanged: ApplicationSettings.backgroundMusicVolume = value / 10;
            scrollEnabled: false
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

        GCComboBox {
            id: fontBox
            model: fonts
            background: dialogActivityConfig
            label: qsTr("Font selector")
        }

        GCText {
            id: baseFontSizeText
            text: qsTr("Font size")
            width: dialogConfig.contentWidth
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }

        Flow {
            spacing: 5
            width: dialogConfig.contentWidth
            GCSlider {
                id: baseFontSizeSlider
                width: 250 * ApplicationInfo.ratio
                maximumValue: ApplicationSettings.baseFontSizeMax
                minimumValue: ApplicationSettings.baseFontSizeMin
                value: baseFontSize
                onValueChanged: ApplicationSettings.baseFontSize = value;
                scrollEnabled: false
            }
            Button {
                height: 30 * ApplicationInfo.ratio
                text: qsTr("Default");
                style: GCButtonStyle {}
                onClicked: baseFontSizeSlider.value = 0.0
            }
        }

        GCComboBox {
            id: fontCapitalizationBox
            model: fontCapitalizationModel
            background: dialogActivityConfig
            label: qsTr("Font Capitalization")
        }

        GCText {
            id: fontLetterSpacingText
            text: qsTr("Font letter spacing")
            fontSize: mediumSize
            width: dialogConfig.contentWidth
            wrapMode: Text.WordWrap
        }

        Flow {
            spacing: 5
            width: dialogConfig.contentWidth
            GCSlider {
                id: fontLetterSpacingSlider
                width: 250 * ApplicationInfo.ratio
                maximumValue: ApplicationSettings.fontLetterSpacingMax
                minimumValue: ApplicationSettings.fontLetterSpacingMin
                value: fontLetterSpacing
                onValueChanged: ApplicationSettings.fontLetterSpacing = value;
                scrollEnabled: false
            }
            Button {
                height: 30 * ApplicationInfo.ratio
                text: qsTr("Default");
                style: GCButtonStyle {}
                onClicked: fontLetterSpacingSlider.value = ApplicationSettings.fontLetterSpacingMin
            }
        }

        GCComboBox {
            id: languageBox
            model: dialogConfig.languages
            background: dialogActivityConfig
            onCurrentIndexChanged: voicesRow.localeChanged();
            label: qsTr("Language selector")
        }

        Flow {
            id: voicesRow
            width: dialogConfig.contentWidth
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

        GCText {
            text: qsTr("Difficulty filter:")
            fontSize: mediumSize
            width: dialogConfig.contentWidth
            height: 50 * ApplicationInfo.ratio
        }

        Flow {
            id: difficultyFlow
            width: dialogConfig.contentWidth
            spacing: 5 * ApplicationInfo.ratio
            property int starsSize: Math.floor(dialogConfig.contentWidth * 0.11)

            Image {
                source: "qrc:/gcompris/src/core/resource/bar_next.svg"
                sourceSize.height: difficultyFlow.starsSize
                sourceSize.width: difficultyFlow.starsSize

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        filterRepeater.setMin(filterRepeater.minFilter + 1)
                    }
                }
            }

            // Level filtering
            Repeater {
                id: filterRepeater
                model: 6

                property int minFilter: ApplicationSettings.filterLevelMin
                property int maxFilter: ApplicationSettings.filterLevelMax

                function setMin(value) {
                    var newMin
                    if(minFilter < 1) {
                        newMin = 1
                    }
                    else if(minFilter > 6) {
                        newMin = 6
                    }
                    else if(maxFilter >= value) {
                        newMin = value
                    }

                    if(newMin) {
                        minFilter = newMin
                    }
                }

                function setMax(value) {
                    var newMax
                    if(maxFilter < 1) {
                        newMax = 1
                    }
                    else if(maxFilter > 6) {
                        newMax = 6
                    }
                    else if(minFilter <= value) {
                        newMax = value
                    }

                    if(newMax) {
                        maxFilter = newMax
                    }
                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/difficulty" +
                    (modelData + 1) + ".svg";
                    sourceSize.width: difficultyFlow.starsSize
                    opacity: modelData + 1 >= filterRepeater.minFilter &&
                    modelData + 1 <= filterRepeater.maxFilter
                    ? 1 : 0.4

                    property int value: modelData + 1

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(parent.value < filterRepeater.maxFilter) {
                                if(parent.opacity == 1) {
                                    filterRepeater.setMin(parent.value + 1)
                                }
                                else {
                                    filterRepeater.setMin(parent.value)
                                }
                            } else if(parent.value > filterRepeater.minFilter) {
                                if(parent.opacity == 1) {
                                    filterRepeater.setMax(parent.value - 1)
                                }
                                else {
                                    filterRepeater.setMax(parent.value)
                                }
                            }
                        }
                    }
                }
            }

            Image {
                source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
                sourceSize.height: difficultyFlow.starsSize
                sourceSize.width: difficultyFlow.starsSize

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        filterRepeater.setMax(filterRepeater.maxFilter - 1)
                    }
                }
            }
        }
    }

    property bool isAudioVoicesEnabled: ApplicationSettings.isAudioVoicesEnabled
    property bool isAudioEffectsEnabled: ApplicationSettings.isAudioEffectsEnabled
    property bool isBackgroundMusicEnabled: ApplicationSettings.isBackgroundMusicEnabled
    property bool isFullscreen: ApplicationSettings.isFullscreen
    property bool isVirtualKeyboard: ApplicationSettings.isVirtualKeyboard
    property bool isAutomaticDownloadsEnabled: ApplicationSettings.isAutomaticDownloadsEnabled
    property bool sectionVisible: ApplicationSettings.sectionVisible
    property string wordset: ApplicationSettings.wordset
    property var filteredBackgroundMusic: ApplicationSettings.filteredBackgroundMusic
    property var allBackgroundMusic: ApplicationInfo.getBackgroundMusicFromRcc()
    property int baseFontSize  // don't bind to ApplicationSettings.baseFontSize
    property real fontLetterSpacing // don't bind to ApplicationSettings.fontLetterSpacing
    // or we get a binding loop warning
    property real backgroundMusicVolume
    property real audioEffectsVolume

    function extractMusicNameFromPath(musicPath) {
        var musicDirectoryPath = ApplicationInfo.getAudioFilePath("backgroundMusic/")
        var musicName = String(musicPath)
        musicName = musicName.slice(musicDirectoryPath.length, musicName.length)
        return musicName.slice(0, musicName.lastIndexOf('.'))
    }

    function loadFromConfig() {
        // Synchronize settings with data
        isAudioVoicesEnabled = ApplicationSettings.isAudioVoicesEnabled
        enableAudioVoicesBox.checked = isAudioVoicesEnabled

        isAudioEffectsEnabled = ApplicationSettings.isAudioEffectsEnabled
        enableAudioEffectsBox.checked = isAudioEffectsEnabled

        isBackgroundMusicEnabled = ApplicationSettings.isBackgroundMusicEnabled
        enableBackgroundMusicBox.checked = isBackgroundMusicEnabled

        isFullscreen = ApplicationSettings.isFullscreen
        enableFullscreenBox.checked = isFullscreen

        isVirtualKeyboard = ApplicationSettings.isVirtualKeyboard
        enableVirtualKeyboardBox.checked = isVirtualKeyboard

        isAutomaticDownloadsEnabled = ApplicationSettings.isAutomaticDownloadsEnabled
        enableAutomaticDownloadsBox.checked = isAutomaticDownloadsEnabled

        filterRepeater.minFilter = ApplicationSettings.filterLevelMin
        filterRepeater.maxFilter = ApplicationSettings.filterLevelMax

        sectionVisible = ApplicationSettings.sectionVisible
        sectionVisibleBox.checked = sectionVisible

        wordset = ApplicationSettings.wordset
        wordsetBox.checked = DownloadManager.isDataRegistered("words") || ApplicationSettings.wordset == 'data2/words/words.rcc'
        wordsetBox.enabled = !DownloadManager.isDataRegistered("words")

        baseFontSize = ApplicationSettings.baseFontSize
        fontLetterSpacing = ApplicationSettings.fontLetterSpacing
        backgroundMusicVolume = ApplicationSettings.backgroundMusicVolume
        audioEffectsVolume = ApplicationSettings.audioEffectsVolume
        filteredBackgroundMusic = ApplicationSettings.filteredBackgroundMusic
        allBackgroundMusic = ApplicationInfo.getBackgroundMusicFromRcc()
        if(filteredBackgroundMusic.length === 0)
            filteredBackgroundMusic = allBackgroundMusic
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
        ApplicationSettings.isAudioVoicesEnabled = isAudioVoicesEnabled
        ApplicationSettings.isAudioEffectsEnabled = isAudioEffectsEnabled
        ApplicationSettings.isBackgroundMusicEnabled = isBackgroundMusicEnabled
        ApplicationSettings.filteredBackgroundMusic = filteredBackgroundMusic
        ApplicationSettings.isFullscreen = isFullscreen
        ApplicationSettings.isVirtualKeyboard = isVirtualKeyboard
        ApplicationSettings.isAutomaticDownloadsEnabled = isAutomaticDownloadsEnabled
        ApplicationSettings.sectionVisible = sectionVisible
        ApplicationSettings.wordset = wordset
        ApplicationSettings.isEmbeddedFont = fonts.get(fontBox.currentIndex).isLocalResource;
        ApplicationSettings.font = fonts.get(fontBox.currentIndex).text
        ApplicationSettings.fontCapitalization = fontCapitalizationModel[fontCapitalizationBox.currentIndex].value

        if(ApplicationSettings.filterLevelMin != filterRepeater.minFilter ||
           ApplicationSettings.filterLevelMax != filterRepeater.maxFilter) {
               ApplicationSettings.filterLevelMin = filterRepeater.minFilter
               ApplicationSettings.filterLevelMax = filterRepeater.maxFilter
               ActivityInfoTree.minMaxFiltersChanged(filterRepeater.minFilter, filterRepeater.maxFilter)
        }

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

        // download backgroundMusic.rcc if needed
        if(DownloadManager.isDataRegistered("backgroundMusic")) {
        // we either have it, we try to update in the background
        // or we are downloading it
            if(DownloadManager.haveLocalResource(DownloadManager.getBackgroundMusicResources()))
                DownloadManager.updateResource(DownloadManager.getBackgroundMusicResources())
            }
        else {
        // download automatically if automatic download else ask for download
            if(isAutomaticDownloadsEnabled) {
                var prevAutomaticDownload = ApplicationSettings.isAutomaticDownloadsEnabled
                ApplicationSettings.isAutomaticDownloadsEnabled = true;
                DownloadManager.updateResource(DownloadManager.getBackgroundMusicResources());
                ApplicationSettings.isAutomaticDownloadsEnabled = prevAutomaticDownload
            }
            else if(ApplicationSettings.isBackgroundMusicEnabled) {
                Core.showMessageDialog(main,
                qsTr("The background music is not yet installed. ")
                + qsTr("Do you want to download it now?"),
                qsTr("Yes"),
                function() {
                    if (DownloadManager.downloadResource(DownloadManager.getBackgroundMusicResources()))
                        var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
                },
                qsTr("No"),null
                );
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

    function isFilteredBackgroundMusicChanged() {
        initialFilteredMusic = ApplicationSettings.filteredBackgroundMusic
        if(initialFilteredMusic.length != filteredBackgroundMusic.length)
            return true
        for(var i = 0; i < initialFilteredMusic.length; i++)
            if(filteredBackgroundMusic.indexOf(initialFilteredMusic[i]) == -1)
                return true

        return false
    }

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
        (ApplicationSettings.isBackgroundMusicEnabled != isBackgroundMusicEnabled) ||
        (ApplicationSettings.isFullscreen != isFullscreen) ||
        (ApplicationSettings.isVirtualKeyboard != isVirtualKeyboard) ||
        (ApplicationSettings.isAutomaticDownloadsEnabled != isAutomaticDownloadsEnabled) ||
        (ApplicationSettings.baseFontSize != baseFontSize) ||
        isFilteredBackgroundMusicChanged()
        );
    }
}
