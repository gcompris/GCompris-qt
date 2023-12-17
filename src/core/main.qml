/* GCompris - main.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQml 2.12

import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

/**
 * GCompris' main QML file defining the top level window.
 * @ingroup infrastructure
 *
 * Handles application start (Component.onCompleted) and shutdown (onClosing)
 * on the QML layer.
 *
 * Contains the global shortcuts:
 *
 * * @c Ctrl+q: Exit the application.
 * * @c Ctrl+b: Toggle the bar.
 * * @c Ctrl+f: Toggle fullscreen.
 * * @c Ctrl+m: Toggle audio effects.
 * * @c Ctrl+p: Take a screenshot.
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
    property var rccBackgroundMusic: ApplicationInfo.getBackgroundMusicFromRcc()
    property var filteredBackgroundMusic: ApplicationSettings.filteredBackgroundMusic
    property alias backgroundMusic: backgroundMusic
    property bool voicesDownloaded: true
    property bool wordSetDownloaded: true
    property bool musicDownloaded: true
    property bool welcomePlayed: false
    property int lastGCVersionRanCopy: ApplicationInfo.GCVersionCode

    Shortcut {
        sequence: "Ctrl+q"
        onActivated: Core.quit(pageView);
    }
    Shortcut {
        sequence: "Ctrl+b"
        onActivated: ApplicationSettings.isBarHidden = !ApplicationSettings.isBarHidden;
    }
    Shortcut {
        sequence: "Ctrl+f"
        onActivated: ApplicationSettings.isFullscreen = !ApplicationSettings.isFullscreen;
    }
    Shortcut {
        sequence: "Ctrl+m"
        onActivated: {
            // We mute / unmute both channels in sync
            ApplicationSettings.isAudioVoicesEnabled = !ApplicationSettings.isAudioVoicesEnabled;
            ApplicationSettings.isAudioEffectsEnabled = ApplicationSettings.isAudioVoicesEnabled;
            ApplicationSettings.isBackgroundMusicEnabled = ApplicationSettings.isAudioVoicesEnabled;
        }
    }
    Shortcut {
        sequence: "Ctrl+p"
        onActivated: {
            if(pageView.get(pageView.depth-1).activityInfo) {
                ApplicationInfo.screenshot("/tmp/" + pageView.get(pageView.depth-1).activityInfo.name.split('/')[0] + ".png");
            } else {
                ApplicationInfo.screenshot("/tmp/gcompris.png");
            }
        }
    }

    /**
     * type: bool
     * It tells whether a musical activity is running.
     *
     * It changes to true if the started activity is a musical activity and back to false when the activity is closed, allowing to play background music.
     */
    property bool isMusicalActivityRunning: false

    /**
     * When a musical activity is started, the backgroundMusic pauses.
     *
     * When returning back from the musical activity to menu, backgroundMusic resumes.
     */
    onIsMusicalActivityRunningChanged: {
        if(isMusicalActivityRunning) {
            backgroundMusic.pause()
        }
        else {
            backgroundMusic.resume()
        }
    }

    onApplicationStateChanged: {
        if (ApplicationInfo.isMobile && applicationState !== Qt.ApplicationActive) {
            backgroundMusic.pause();
            audioVoices.stop();
            audioEffects.stop();
        }
        else if (ApplicationInfo.isMobile && !isMusicalActivityRunning) {
            backgroundMusic.resume();
        }
    }

    onClosing: Core.quit(pageView)

    GCAudio {
        id: audioVoices
        muted: !ApplicationSettings.isAudioVoicesEnabled && !main.isMusicalActivityRunning

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
                if(!welcomePlayed) {
                    audioVoices.append(ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/misc/welcome.$CA"));
                    welcomePlayed = true;
                }
            }
        }

        Component.onCompleted: {
            if(ActivityInfoTree.startingActivity != "") {
                // Don't play welcome intro
                welcomePlayed = true;
            }
            else if (DownloadManager.areVoicesRegistered(ApplicationSettings.locale)) {
                delayedWelcomeTimer.playWelcome();
            }
            else {
                DownloadManager.voicesRegistered.connect(
                        delayedWelcomeTimer.playWelcome);
                delayedWelcomeTimer.start();
            }
        }
    }

    GCSfx {
        id: audioEffects
        muted: !ApplicationSettings.isAudioEffectsEnabled && !main.isMusicalActivityRunning
        volume: ApplicationSettings.audioEffectsVolume
    }

    GCAudio {
        id: backgroundMusic
        isBackgroundMusic: true
        muted: !ApplicationSettings.isBackgroundMusicEnabled
        volume: ApplicationSettings.backgroundMusicVolume

        onMutedChanged: {
            if(!hasAudio && !files.length) {
                backgroundMusic.playBackgroundMusic()
            }
        }

        onDone: {
            backgroundMusic.source = "" // Avoid play again intro music if backgroundMusic not installed
            backgroundMusic.playBackgroundMusic()
        }

        function playBackgroundMusic() {
            rccBackgroundMusic = ApplicationInfo.getBackgroundMusicFromRcc()
            filteredBackgroundMusic = ApplicationSettings.filteredBackgroundMusic;
            if(filteredBackgroundMusic.length === 0) {
                filteredBackgroundMusic = rccBackgroundMusic
            }

            for(var i = 0; i < filteredBackgroundMusic.length; i++) {
                backgroundMusic.append(ApplicationInfo.getAudioFilePath("backgroundMusic/" + filteredBackgroundMusic[i]))
            }
            if(main.isMusicalActivityRunning)
                backgroundMusic.pause()
        }

        Component.onCompleted: {
            if(ApplicationSettings.isBackgroundMusicEnabled && ActivityInfoTree.startingActivity == "") {
                backgroundMusic.append(ApplicationInfo.getAudioFilePath("qrc:/gcompris/src/core/resource/intro.$CA"))
            }
            if(ApplicationSettings.isBackgroundMusicEnabled
               && DownloadManager.haveLocalResource(DownloadManager.getBackgroundMusicResources())) {
                   backgroundMusic.playBackgroundMusic()
            }
            else {
                DownloadManager.backgroundMusicRegistered.connect(backgroundMusic.playBackgroundMusic)
            }
        }
    }

    function playIntroVoice(name) {
        name = name.split("/")[0]
        audioVoices.play(ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/intro/" + name + ".$CA"))
    }

    function checkWordset() {
        var wordset = DownloadManager.getResourcePath(GCompris.WORDSET, {})

        // check for words-webp.rcc:
        if(wordset != "" && DownloadManager.haveLocalResource(wordset)) {
            // words-webp.rcc is there -> register old file first
            // then try to update in the background
            DownloadManager.updateResource(GCompris.WORDSET, {});
        } else {
            // words-webp.rcc has not been downloaded yet -> ask for download
            wordSetDownloaded = false;
        }
    }

    function checkBackgroundMusic() {
        var music = DownloadManager.getBackgroundMusicResources()
        if(rccBackgroundMusic === '') {
            rccBackgroundMusic = ApplicationInfo.getBackgroundMusicFromRcc()
        }
        if(music === '' || !DownloadManager.haveLocalResource(music)) {
            musicDownloaded = false;
        }
        // We have local music but it is not yet registered
        else if(music !== "") {
            // We have music and automatic download is enabled. Download the music and register it
            DownloadManager.updateResource(GCompris.BACKGROUND_MUSIC, {})
        }
        else if(ApplicationSettings.isBackgroundMusicEnabled && !DownloadManager.haveLocalResource(music)) {
            musicDownloaded = false;
        }
    }

    function checkVoices() {
        var voicesRcc = DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale)
        if(voicesRcc == "" || !DownloadManager.haveLocalResource(voicesRcc))
            voicesDownloaded = false;
        else {
            if(voicesRcc !== "") {
                DownloadManager.updateResource(GCompris.VOICES, {"locale": ApplicationInfo.getVoicesLocale(ApplicationSettings.locale)});
            }
        }
    }

    function initialAssetsDownload() {
        var dialogText;
        dialogText = qsTr("Do you want to automatically download or update the following external assets when starting GCompris?")
        + ("<br>")
        + ("<br>") + "-" + qsTr("Voices for your language")
        + ("<br>") + "-" + qsTr("Full word image set")
        + ("<br>") + "-" + qsTr("Background music");

        var dialog;
        dialog = Core.showMessageDialog(
            pageView.currentItem,
            dialogText,
            qsTr("Yes"),
            function() {
                DownloadManager.downloadResource(GCompris.VOICES, {"locale": ApplicationInfo.getVoicesLocale(ApplicationSettings.locale)});
                DownloadManager.downloadResource(GCompris.WORDSET);
                DownloadManager.downloadResource(GCompris.BACKGROUND_MUSIC);
                var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
            },
            qsTr("No"), 
            function() {
                ApplicationSettings.isAutomaticDownloadsEnabled = false;
            },
            null
        );
    }

    ChangeLog {
       id: changelog
    }

    Component.onCompleted: {
        console.log("enter main.qml (run #" + ApplicationSettings.exeCount
                    + ", ratio=" + ApplicationInfo.ratio
                    + ", fontRatio=" + ApplicationInfo.fontRatio
                    + ", dpi=" + Math.round(Screen.pixelDensity*25.4)
                    + ", userDataPath=" + ApplicationSettings.userDataPath
                    + ")");
        DownloadManager.initializeAssets();

        // Register local full rcc if it exists. We don't try to check if there is one more up to date on the server, we register the one we have
        var fullRccPath = DownloadManager.getResourcePath(GCompris.FULL, {});
        if(fullRccPath != "") {
            DownloadManager.registerResource(fullRccPath);
        }

// use  + ("<br><br>") to start new paragraphs
            var RA2LEDialog;
            RA2LEDialog = Core.showMessageDialog(
                        pageView,
                        qsTr("This is the RA2LE(Read along to learn english) fork of  GCompris") + ("<br>")
                        + qsTr("This was built on 17th December 2023.") + "\n"
                        + qsTr("I hope people will find it useful.\n\n\n\n")
                        + "\n"
                        + qsTr("The fork isn't endorsed by the GCompris development team")
                        + ("<br><br>")
                        + qsTr("Source code for this project can be found at: https://github.com/ReadAlongToLearnEnglish/GCompris-qt")
                        + ("<br><br>")
                        + qsTr("The project was initially forked on 17th December 2023.\n")
                        + qsTr("In this current release, my additions are a tiny faction of the total source code and I'm thankful to be able to stand on the shoulders of giants.\n\n\n\n")
                        + ("<br><br>")
                        + qsTr("This work is released under the same licences as the upstream project available at: https://github.com/gcompris/GCompris-qt"),
                        "", null,
                        "", null,
                        function() {
                        }
             );
        


        if (ApplicationSettings.exeCount === 1 &&
                !ApplicationSettings.isKioskMode) {
            checkVoices();
            checkWordset();
            checkBackgroundMusic();
            // first run
            var dialog;
            dialog = Core.showMessageDialog(
                        pageView,
                        qsTr("Welcome to GCompris!") + ("<br>") 
                        + qsTr("You are running GCompris for the first time.") + "\n"
                        + qsTr("You should verify that your application settings especially your language is set correctly. You can do this in the Configuration dialog.")
                        + "\n"
                        + qsTr("Have Fun!")
                        + ("<br><br>")
                        + qsTr("Your current language is %1 (%2).")
                          .arg(Qt.locale(ApplicationInfo.getVoicesLocale(ApplicationSettings.locale)).nativeLanguageName)
                          .arg(ApplicationInfo.getVoicesLocale(ApplicationSettings.locale)),
                        "", null,
                        "", null,
                        function() {
                            pageView.currentItem.focus = true;
                            if(ApplicationInfo.isDownloadAllowed) {
                                initialAssetsDownload();
                            }
                        }
             );
        }
        else {
            // Register voices-resources for current locale, updates/downloads only if
            // not prohibited by the settings
            DownloadManager.updateResource(GCompris.VOICES, {"locale": ApplicationInfo.getVoicesLocale(ApplicationSettings.locale)});

            checkWordset();
            DownloadManager.updateResource(GCompris.WORDSET, {});

            checkBackgroundMusic();
            DownloadManager.updateResource(GCompris.BACKGROUND_MUSIC, {});

            if(changelog.isNewerVersion(ApplicationSettings.lastGCVersionRan, ApplicationInfo.GCVersionCode)) {
                lastGCVersionRanCopy = ApplicationSettings.lastGCVersionRan;

                const newDatasets = changelog.getNewDatasetsBetween(ApplicationSettings.lastGCVersionRan, ApplicationInfo.GCVersionCode);

                // display log between ApplicationSettings.lastGCVersionRan and ApplicationInfo.GCVersionCode
                Core.showMessageDialog(
                pageView,
                qsTr("GCompris has been updated! Here are the new changes:<br/>") + changelog.getLogBetween(ApplicationSettings.lastGCVersionRan, ApplicationInfo.GCVersionCode),
                "", null,
                "", null,
                function() {
                    if(newDatasets.length != 0) {
                        showNewDatasetsDialog(newDatasets);
                    }
                    else {
                        pageView.currentItem.focus = true;
                    }
                }
                );

                // Store new version after update
                ApplicationSettings.lastGCVersionRan = ApplicationInfo.GCVersionCode;
            }
        }
        //Store version on first run in any case
        if(ApplicationSettings.lastGCVersionRan === 0)
            ApplicationSettings.lastGCVersionRan = ApplicationInfo.GCVersionCode;
    }

    Loader {
        id: newDatasetsDialog
        property var newDatasetsModel
        sourceComponent: GCDialog {
            parent: pageView
            isDestructible: false
            message: qsTr("Some activities have new dataset available. Do you want to reset their dataset selection?")
            button1Text: qsTr("Apply")
            button2Text: qsTr("Cancel")
            onButton1Hit: {
                newDatasetsModel.forEach(function(activity) {
                    if(activity.overrideExistingLevels) {
                        ActivityInfoTree.resetLevels(activity.activityName);
                    }
                })
            }
            content: Component {
                Column {
                    id: activitiesWithNewDatasetsColumn
                    spacing: 5 * ApplicationInfo.ratio
                    width: parent.width

                    Repeater {
                        id: newDatasetsRepeater
                        model: newDatasetsDialog.newDatasetsModel

                        delegate: GCDialogCheckBox {
                            id: activityCheckbox
                            width: parent.width
                            labelTextFontSize: 12
                            indicatorImageHeight: 40 * ApplicationInfo.ratio
                            text: modelData.activityTitle
                            checked: modelData.overrideExistingLevels
                            onClicked: {
                                var dataset = newDatasetsModel.find(function(v) {
                                    return v.activity == modelData.activity;
                                })
                                dataset.overrideExistingLevels = checked;
                            }
                        }
                    }
                }
            }

            onClose: {
                newDatasetsDialog.active = false;
                pageView.currentItem.focus = true;
            }
        }
        anchors.fill: pageView
        active: false
        onStatusChanged: if (status == Loader.Ready) item.start()
    }

    function showNewDatasetsDialog(newDatasets) {
        newDatasetsDialog.newDatasetsModel = newDatasets;
        newDatasetsDialog.active = true;
    }

    Loading {
        id: loading
    }

    StackView {
        id: pageView
        anchors.fill: parent
        focus: true
        Component.onCompleted: {
            push("qrc:/gcompris/src/activities/" + ActivityInfoTree.rootMenu.name, {
                'audioVoices': audioVoices,
                'audioEffects': audioEffects,
                'loading': loading,
                'backgroundMusic': backgroundMusic
            })

            if(ActivityInfoTree.startingActivity != "") {
                startApplicationTimer.start();
            }
        }

        Timer {
            id: startApplicationTimer
            interval: 1000
            repeat: false

            onTriggered: {
                print("Start activity", ActivityInfoTree.startingActivity, "at level", ActivityInfoTree.startingLevel);
                pageView.currentItem.startActivity(ActivityInfoTree.startingActivity, ActivityInfoTree.startingLevel);
            }
        }


        property var enterItem
        property var exitItem

        popEnter: (exitItem && exitItem.isDialog) ? popVTransition : popHTransition
        popExit: (exitItem && exitItem.isDialog) ? popVTransitionExit : popHTransitionExit
        pushEnter: (enterItem && enterItem.isDialog) ? pushVTransition : pushHTransition
        pushExit: (enterItem && enterItem.isDialog) ? pushVTransitionExit : pushHTransitionExit

        property Transition pushHTransition: Transition {
            PropertyAnimation {
                property: "x"
                from: pageView.width
                to: 0
                duration: 500
                easing.type: Easing.OutSine
            }
        }

        property Transition pushHTransitionExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: -pageView.width
                duration: 500
                easing.type: Easing.OutSine
            }
        }
        property Transition popHTransition: Transition {
            PropertyAnimation {
                property: "x"
                from: -pageView.width
                to: 0
                duration: 500
                easing.type: Easing.OutSine
            }
        }
        property Transition popHTransitionExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: pageView.width
                duration: 500
                easing.type: Easing.OutSine
            }
        }

        property Transition pushVTransition: Transition {
            PropertyAnimation {
                property: "y"
                from: -pageView.height
                to: 0
                duration: 500
                easing.type: Easing.OutSine
            }
        }
        property Transition pushVTransitionExit: Transition {
            PropertyAnimation {
                property: "y"
                from: 0
                to: pageView.height
                duration: 500
                easing.type: Easing.OutSine
            }
        }
        property Transition popVTransition: Transition {
            PropertyAnimation {
                property: "y"
                from: pageView.height
                to: 0
                duration: 500
                easing.type: Easing.OutSine
            }
        }
        property Transition popVTransitionExit: Transition {
            PropertyAnimation {
                property: "y"
                from: 0
                to: -pageView.height
                duration: 500
                easing.type: Easing.OutSine
            }
        }

        function pushElement(element) {
            audioVoices.clearQueue()
            audioVoices.stop()
            enterItem = element
            exitItem = currentItem
            push(element)

            // if coming from menu and going into an activity then
            if(!exitItem.isDialog && !enterItem.isDialog) {
                playIntroVoice(enterItem.activityInfo.name);
            }
            
            if(enterItem.isMusicalActivity) {
                main.isMusicalActivityRunning = true
            }

            exitItem.opacity = 1
            if(!enterItem.isDialog) {
                exitItem.stop()
            }
            // Don't restart an activity if you click on help
            if (!exitItem.isDialog ||    // if coming from menu or
                enterItem.alwaysStart) { // start signal enforced (for special case like transition from config-dialog to editor)
                    enterItem.start();
            }
        }

        function popElement(element) {
            enterItem = pageView.get(pageView.depth-2)
            exitItem = currentItem

            if(exitItem.isMusicalActivity) {
                main.isMusicalActivityRunning = false
            }

            if(!enterItem.isDialog) {
                currentItem.stop()
            }
            pop()
            // Don't restart an activity if you click on help
            if (!exitItem.isDialog ||    // if coming from menu or
                enterItem.alwaysStart) { // start signal enforced (for special case like transition from config-dialog to editor)
                    enterItem.start();
            }
        }
    }
    /// @endcond
}
