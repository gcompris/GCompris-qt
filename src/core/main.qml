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
            audioVoices.stop();
            audioEffects.stop();
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
            if(ApplicationInfo.startingActivity != "") {
                // Don't play welcome intro
                welcomePlayed = true;
            }
            else if (DownloadManager.areVoicesRegistered()) {
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

        onDone: backgroundMusic.playBackgroundMusic()

        function playBackgroundMusic() {
            rccBackgroundMusic = ApplicationInfo.getBackgroundMusicFromRcc()

            for(var i = 0; i < filteredBackgroundMusic.length; i++) {
                backgroundMusic.append(ApplicationInfo.getAudioFilePath("backgroundMusic/" + filteredBackgroundMusic[i]))
            }
            if(main.isMusicalActivityRunning)
                backgroundMusic.pause()
        }

        Component.onCompleted: {
            if(ApplicationSettings.isBackgroundMusicEnabled && ApplicationInfo.startingActivity == "") {
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
        var wordset = ApplicationSettings.wordset
        if(wordset === '')
            // Maybe the wordset has been bundled or copied manually
            // we have to register it if we find it.
            wordset = 'data2/words/words-webp.rcc'

        // check for words-webp.rcc:
        if (DownloadManager.isDataRegistered("words-webp")) {
            // words-webp.rcc is already registered -> nothing to do
        } else if(DownloadManager.haveLocalResource(wordset)) {
            // words-webp.rcc is there -> register old file first
            // then try to update in the background
            if(DownloadManager.updateResource(wordset)) {
                ApplicationSettings.wordset = wordset
            }
        } else if(ApplicationSettings.useWordset) { // Only if external wordset is enabled
            // words-webp.rcc has not been downloaded yet -> ask for download
            wordSetDownloaded = false;
        }
    }

    function checkBackgroundMusic() {
        var music = DownloadManager.getBackgroundMusicResources()
        if(rccBackgroundMusic === '') {
            rccBackgroundMusic = ApplicationInfo.getBackgroundMusicFromRcc()
        }
        if(music === '') {
            music = DownloadManager.getBackgroundMusicResources()
        }
        // We have local music but it is not yet registered
        else if(!DownloadManager.isDataRegistered("backgroundMusic") && DownloadManager.haveLocalResource(music)) {
            // We have music and automatic download is enabled. Download the music and register it
            if(DownloadManager.updateResource(music) && DownloadManager.downloadIsRunning()) {
                DownloadManager.registerResource(music)
                rccBackgroundMusic = Core.shuffle(ApplicationInfo.getBackgroundMusicFromRcc())
            }
            else {
                rccBackgroundMusic = ApplicationInfo.getBackgroundMusicFromRcc()
            }
        }
        else if(ApplicationSettings.isBackgroundMusicEnabled && !DownloadManager.haveLocalResource(music)) {
            musicDownloaded = false;
        }
    }

    function checkVoices() {
        if(!DownloadManager.haveLocalResource(DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale)))
            voicesDownloaded = false;
        else
            DownloadManager.registerResource(DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale));
    }

    function initialAssetsDownload() {
        checkVoices();
        checkWordset();
        checkBackgroundMusic();
        var voicesLine = voicesDownloaded ? "" : ("<br>") + "-" + qsTr("Voices for your language");
        var wordSetLine = wordSetDownloaded ? "" : ("<br>") + "-" + qsTr("Full word image set");
        var musicLine = musicDownloaded ? "" : ("<br>") + "-" + qsTr("Background music");
        if(!voicesDownloaded || !wordSetDownloaded || ! musicDownloaded) {
            var dialog;
            dialog = Core.showMessageDialog(
                pageView.currentItem,
                qsTr("Do you want to download the following external assets?")
                + ("<br>")
                + voicesLine
                + wordSetLine
                + musicLine,
                qsTr("Yes"),
                function() {
                    if(!voicesDownloaded)
                        DownloadManager.downloadResource(DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale));
                    if(!wordSetDownloaded)
                        DownloadManager.downloadResource('data2/words/words-webp.rcc');
                    if(!musicDownloaded)
                        DownloadManager.downloadResource(DownloadManager.getBackgroundMusicResources());
                    var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
                },
                qsTr("No"), null,
                null
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
                    + ", userDataPath=" + ApplicationSettings.userDataPath
                    + ")");
        if (ApplicationSettings.exeCount === 1 &&
                !ApplicationSettings.isKioskMode &&
                ApplicationInfo.isDownloadAllowed) {
            // first run
            var dialog;
            dialog = Core.showMessageDialog(
                        pageView,
                        qsTr("Welcome to GCompris!") + ("<br>")
                        + qsTr("You are running GCompris for the first time.") + "\n"
                        + qsTr("You should verify that your application settings especially your language is set correctly, and that all language specific sound files are installed. You can do this in the Preferences Dialog.")
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
                            initialAssetsDownload();
                        }
             );
        }
        else {
            // Register voices-resources for current locale, updates/downloads only if
            // not prohibited by the settings
            if(!DownloadManager.areVoicesRegistered()) {
                DownloadManager.updateResource(
                    DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale));
            }

            checkWordset();

            if(ApplicationSettings.useWordset && DownloadManager.updateResource('data2/words/words-webp.rcc')) {
                ApplicationSettings.wordset = 'data2/words/words-webp.rcc'
            }

            checkBackgroundMusic();
            if(changelog.isNewerVersion(ApplicationSettings.lastGCVersionRan, ApplicationInfo.GCVersionCode)) {
                lastGCVersionRanCopy = ApplicationSettings.lastGCVersionRan;
                // display log between ApplicationSettings.lastGCVersionRan and ApplicationInfo.GCVersionCode
                Core.showMessageDialog(
                pageView,
                qsTr("GCompris has been updated! Here are the new changes:<br/>") + changelog.getLogBetween(ApplicationSettings.lastGCVersionRan, ApplicationInfo.GCVersionCode),
                "", null,
                "", null,
                function() { pageView.currentItem.focus = true }
                );
                // Store new version after update
                ApplicationSettings.lastGCVersionRan = ApplicationInfo.GCVersionCode;
            }
        }
        //Store version on first run in any case
        if(ApplicationSettings.lastGCVersionRan === 0)
            ApplicationSettings.lastGCVersionRan = ApplicationInfo.GCVersionCode;
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
            interval: 2000
            repeat: false

            onTriggered: {
                print("Start activity", ActivityInfoTree.startingActivity);
                pageView.currentItem.startActivity(ActivityInfoTree.startingActivity);
                ActivityInfoTree.startingActivity = "";
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
