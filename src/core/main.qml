/* GCompris - main.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Window 2.1
import QtQml 2.2

import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

/**
 * GCompris' main QML file defining the top level window.
 * @ingroup infrastructure
 *
 * Handles application start (Component.onCompleted) and shutdown (onClosing)
 * on the QML layer.
 *
 * Contains the central GCAudio objects audio effects and audio voices.
 *
 * Contains the top level StackView presenting and animating GCompris'
 * full screen views.
 *
 * @sa BarButton, BarEnumContent
 * @inherit QtQuick.Window
 */
Window {
    id: main
    // Start in window mode at full screen size
    width: ApplicationSettings.previousWidth
    height: ApplicationSettings.previousHeight
    minimumWidth: 400 * ApplicationInfo.ratio
    minimumHeight: 400 * ApplicationInfo.ratio
    title: "GCompris"

    /// @cond INTERNAL_DOCS

    property var applicationState: Qt.application.state

    onApplicationStateChanged: {
        if (ApplicationInfo.isMobile && applicationState != Qt.ApplicationActive) {
            audioVoices.stop();
            audioEffects.stop();
        }
    }

    onClosing: Core.quit(main)

    GCAudio {
        id: audioVoices
        muted: !ApplicationSettings.isAudioVoicesEnabled

        Timer {
            id: delayedWelcomeTimer
            interval: 10000 /* Make sure, that playing welcome.ogg if delayed
                             * because of not yet registered voices, will only
                             * happen max 10sec after startup */
            repeat: false

            onTriggered: {
                DownloadManager.voicesRegistered.disconnect(playWelcome);
            }

            function playWelcome() {
                audioVoices.append(ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/misc/welcome.$CA"));
            }
        }

        Component.onCompleted: {
            if(ApplicationSettings.isAudioEffectsEnabled)
                audioVoices.append(ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/core/resource/intro.$CA"))

            if (DownloadManager.areVoicesRegistered())
                delayedWelcomeTimer.playWelcome();
            else {
                DownloadManager.voicesRegistered.connect(
                        delayedWelcomeTimer.playWelcome);
                delayedWelcomeTimer.start();
            }
        }
    }

    GCSfx {
        id: audioEffects
        muted: !ApplicationSettings.isAudioEffectsEnabled
    }

    function playIntroVoice(name) {
        name = name.split("/")[0]
        audioVoices.play(ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/intro/" + name + ".$CA"))
    }

    function checkWordset() {
        var wordset = ApplicationSettings.wordset
        if(wordset == '')
            // Maybe the wordset has been bundled or copied manually
            // we have to register it if we find it.
            wordset = 'data2/words/words.rcc'

        // check for words.rcc:
        if (DownloadManager.isDataRegistered("words")) {
            // words.rcc is already registered -> nothing to do
        } else if(DownloadManager.haveLocalResource(wordset)) {
            // words.rcc is there -> register old file first
            // then try to update in the background
            if(DownloadManager.updateResource(wordset)) {
                ApplicationSettings.wordset = wordset
            }
        } else if(ApplicationSettings.wordset) { // Only if wordset specified
            // words.rcc has not been downloaded yet -> ask for download
            Core.showMessageDialog(
                        main,
                        qsTr("The images for several activities are not yet installed. " +
                        "Do you want to download them now?"),
                        qsTr("Yes"),
                        function() {
                            if (DownloadManager.downloadResource(wordset))
                                var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
                        },
                        qsTr("No"), null,
                        function() { pageView.currentItem.focus = true }
            );
        }
    }
    ChangeLog {
       id: changelog
    }

    Component.onCompleted: {
        console.log("enter main.qml (run #" + ApplicationSettings.exeCount
                    + ", ratio=" + ApplicationInfo.ratio
                    + ", fontRatio=" + ApplicationInfo.fontRatio
                    + ", dpi=" + Math.round(Screen.pixelDensity*25.4)
                    + ", sharedWritablePath=" + ApplicationInfo.getSharedWritablePath()
                    + ")");
        if (ApplicationSettings.exeCount === 1 &&
                !ApplicationSettings.isKioskMode &&
                ApplicationInfo.isDownloadAllowed) {
            // first run
            var dialog;
            dialog = Core.showMessageDialog(
                        main,
                        qsTr("Welcome to GCompris!") + '\n'
                        + qsTr("You are running GCompris for the first time.") + '\n'
                        + qsTr("You should verify that your application settings especially your language is set correctly, and that all language specific sound files are installed. You can do this in the Preferences Dialog.")
                        + "\n"
                        + qsTr("Have Fun!")
                        + "\n"
                        + qsTr("Your current language is %1 (%2).")
                          .arg(Qt.locale(ApplicationInfo.getVoicesLocale(ApplicationSettings.locale)).nativeLanguageName)
                          .arg(ApplicationInfo.getVoicesLocale(ApplicationSettings.locale))
                        + "\n"
                        + qsTr("Do you want to download the corresponding sound files now?"),
                        qsTr("Yes"),
                        function() {
                            if (DownloadManager.downloadResource(
                                        DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale)))
                                var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
                        },
                        qsTr("No"), null,
                        function() {
                            pageView.currentItem.focus = true
                            checkWordset()
                        }
             );
        }
        else {
            // Register voices-resources for current locale, updates/downloads only if
            // not prohibited by the settings
            if (!DownloadManager.areVoicesRegistered()) {
                DownloadManager.updateResource(
                    DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale));
            }

            checkWordset()

            if(changelog.isNewerVersion(ApplicationSettings.lastGCVersionRan, ApplicationInfo.GCVersionCode)) {
                // display log between ApplicationSettings.lastGCVersionRan and ApplicationInfo.GCVersionCode
                var dialog;
                dialog = Core.showMessageDialog(
                main,
                qsTr("GCompris has been updated! Here are the new changes:<br/>") + changelog.getLogBetween(ApplicationSettings.lastGCVersionRan, ApplicationInfo.GCVersionCode),
                "", null,
                "", null,
                function() { pageView.currentItem.focus = true }
                );
                // Store new version
                ApplicationSettings.lastGCVersionRan = ApplicationInfo.GCVersionCode;
            }
        }
    }

    Loading {
        id: loading
    }

    StackView {
        id: pageView
        anchors.fill: parent
        initialItem: {
            "item": "qrc:/gcompris/src/activities/" + ActivityInfoTree.rootMenu.name,
            "properties": {
                'audioVoices': audioVoices,
                'audioEffects': audioEffects,
                'loading': loading
            }
        }

        focus: true

        delegate: StackViewDelegate {
            id: root
            function getTransition(properties)
            {
                audioVoices.clearQueue()
                audioVoices.stop()

                if(!properties.exitItem.isDialog &&        // if coming from menu and
                        !properties.enterItem.isDialog)    // going into an activity then
                    playIntroVoice(properties.enterItem.activityInfo.name);    // play intro

                if (!properties.exitItem.isDialog ||       // if coming from menu or
                        properties.enterItem.alwaysStart)  // start signal enforced (for special case like transition from config-dialog to editor)
                    properties.enterItem.start();

                if(properties.name === "pushTransition") {
                    if(properties.enterItem.isDialog) {
                        return pushVTransition
                    } else {
                        return pushHTransition
                    }
                } else {
                    if(properties.exitItem.isDialog) {
                        return popVTransition
                    } else {
                        return popHTransition
                    }

                }
            }

            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
                if(!properties.enterItem.isDialog) {
                    properties.exitItem.stop()
                }
            }

            property Component pushHTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: target.width
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: -target.width
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component popHTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: -target.width
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: target.width
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component pushVTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: -target.height
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: target.height
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component popVTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "y"
                    from: target.height
                    to: 0
                    duration: 500
                    easing.type: Easing.OutSine
                }
                PropertyAnimation {
                    target: exitItem
                    property: "y"
                    from: 0
                    to: -target.height
                    duration: 500
                    easing.type: Easing.OutSine
                }
            }

            property Component replaceTransition: pushHTransition
        }
    }

    /// @endcond
}
