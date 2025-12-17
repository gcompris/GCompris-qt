/* GCompris - main.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Window
import QtQml

import core 1.0
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

    // Useful to uncomment to DEBUG focus issues.
    //onActiveFocusItemChanged: print("activeFocusItem", activeFocusItem)

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
    }

    function playIntroVoice(name) {
        name = name.split("/")[0]
        audioVoices.append(ApplicationInfo.getAudioFilePath("voices-$CA/$LOCALE/intro/" + name + ".$CA"))
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
                    spacing: GCStyle.halfMargins
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

    Timer {
        id: load
        interval: 100
        triggeredOnStart: false
        repeat: false

        onTriggered: {
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

    // Once we have loaded all the activities in c++, we display the three circle in orange
    // for the duration of this timer and then we hide the splash screen
    property bool startLoadingFinished: false
    Timer {
        id: secondTimer
        interval: 500
        onTriggered: {
            load.start();
            if(ActivityInfoTree.startingActivity !== "") {
                // Don't play welcome intro
                welcomePlayed = true;
                startApplicationTimer.start();
            }
            else if (DownloadManager.areVoicesRegistered(ApplicationSettings.locale)) {
                delayedWelcomeTimer.playWelcome();
            }
            else {
                DownloadManager.voicesRegistered.connect(
                        delayedWelcomeTimer.playWelcome);
                delayedWelcomeTimer.start();
            }

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
            startLoadingFinished = true;
        }
    }
    property bool activitiesLoaded: false
    onActivitiesLoadedChanged: {
        splash.colorChangeTimer.stop();
        splash.fullyLoaded = true;
        secondTimer.start();
        pageView.push("qrc:/gcompris/src/activities/" + ActivityInfoTree.rootMenu.name, {
            'audioVoices': audioVoices,
            'loading': loading,
            'backgroundMusic': backgroundMusic
        })
    }

    SplashScreen {
        id: splash
        // We display the splash screen if we are loading GCompris (startLoadingFinished) and
        // when we are starting an activity via --launch
        visible: !ApplicationInfo.isMobile && (
                     !startLoadingFinished || (ActivityInfoTree.startingActivity != "" && (pageView.depth == 1 || loading.active)))
        anchors.fill: parent
    }

    Connections {
        id: connection
        target: clientNetworkMessages

        property string requestDeviceId
        property string serverIp
        property bool requestAlreadyInProgress: false

        function onRequestConnection(requestDeviceId, serverIp) {
            // Only show request connection on menu
            if(pageView.depth !== 1 || requestAlreadyInProgress) {
                return
            }
            if (clientNetworkMessages.connectionStatus() !== NetConst.NOT_CONNECTED) {
                return
            }
            requestAlreadyInProgress = true;
            connection.requestDeviceId = requestDeviceId;
            connection.serverIp = serverIp;
            var dialog = Core.showMessageDialog(pageView.currentItem,
                    qsTr("Do you want to connect to server %1?").arg(connection.requestDeviceId),
                    qsTr("Yes"), function() {
                        ApplicationInfo.setServerConnectionAccepted(true)
                        clientNetworkMessages.connectToServer(connection.serverIp)
                        requestAlreadyInProgress = false
                        pageView.focus = true
                    },
                    qsTr("No"), function() {
                        requestAlreadyInProgress = false
                        pageView.focus = true
                    },
                    null);
        }
        function onLoginListReceived(logins) {
            chooseLogin.model = logins;
            chooseLogin.parent = pageView.currentItem;
            chooseLogin.visible = true;
            chooseLogin.start();
        }
        function onPasswordRejected() {
            Core.showMessageDialog(main,
                    qsTr("Password rejected by server %1").arg(connection.requestDeviceId),
                    qsTr("OK"), null, "", null, null);
        }
    }

    GCDialog {
        id: chooseLogin
        visible: false
        active: visible
        focus: false
        width: visible ? parent.width : 0
        height: visible ? parent.height : 0

        isDestructible: false
        closeDialogOnClick: false

        title: qsTr("Select your username")

        property bool okPressed: false

        button1Text: qsTr("OK")
        button2Text: qsTr("Cancel")
        onButton1Hit: {
            if(chooseLogin.chosenLogin == "") {
                Core.showMessageDialog(
                    chooseLogin,
                    qsTr("Please select your username in the list or cancel."),
                    "", null,
                    "", null);
                chooseLogin.alreadyClicked = false;
            }
            else {
                chooseLogin.okPressed = true;
                chooseLogin.stop();
            }
        }
        onButton2Hit: {
            chooseLogin.stop();
        }

        onDeferredAction: {
            chooseLogin.visible = false;
            chooseLogin.parent = main.contentItem;
            chooseLogin.alreadyClicked = false;
            if(chooseLogin.okPressed) {
                chooseLogin.okPressed = false;
                choosePassword.parent = pageView.currentItem;
                choosePassword.visible = true;
                choosePassword.start();
            }
        }

        property string chosenLogin
        property var model
        content: ListView {
            id: view
            contentHeight: 60 * ApplicationInfo.ratio * model.count
            interactive: true
            clip: true
            model: chooseLogin.model
            delegate: GCDialogCheckBox {
                id: userBox
                width: chooseLogin.width - 20
                text: modelData
                checked: false
                ButtonGroup.group: exclusiveGroup
                Component.onCompleted: {
                    if (exclusiveGroup)
                        exclusiveGroup.addButton(userBox)
                }
                Component.onDestruction: {
                    if (exclusiveGroup)
                        exclusiveGroup.removeButton(userBox)
                }
            }
        }
        ButtonGroup {
            id: exclusiveGroup
            onClicked: {
                if (button) chooseLogin.chosenLogin = button.text;
            }
        }
    }
    GCDialog {
        id: choosePassword
        visible: false
        active: visible
        focus: false
        width: visible ? parent.width : 0
        height: visible ? parent.height : 0
        isDestructible: false
        closeDialogOnClick: false

        title: qsTr("Enter your password")

        button1Text: qsTr("OK")
        button2Text: qsTr("Cancel")
        onButton1Hit: {
            var pictures = []
            for (var i = 0; i < passModel.count; i++)
                pictures.push(passModel.get(i).icon_)
            var chosenPassword = pictures.join("-")
            console.warn("selected user name:", chooseLogin.chosenLogin)
            console.warn("selected password:", chosenPassword)
            clientNetworkMessages.sendLoginMessage(chooseLogin.chosenLogin, chosenPassword)
            choosePassword.stop()
        }
        onButton2Hit: {
            choosePassword.stop();
        }

        onDeferredAction: {
            choosePassword.visible = false;
            choosePassword.parent = main.contentItem;
            choosePassword.alreadyClicked = false;
            // Reinitialise info once we have logged
            passModel.clear();
            chooseLogin.chosenLogin = "";
        }

        ListModel { id: imagesModel }
        ListModel { id: passModel }
        content: Column {
            id: passwordSelector
            spacing: GCStyle.baseMargins
            readonly property int imageSize: Math.min(GCStyle.bigButtonHeight,
                                        width / imagesModel.count - GCStyle.halfMargins,
                                        height * 0.5 - GCStyle.baseMargins)
            ListView {
                id: passwordChoice
                width: parent.width
                height: passwordSelector.imageSize
                contentHeight: height
                spacing: GCStyle.halfMargins
                anchors.horizontalCenter: parent.horizontalCenter
                orientation: ListView.Horizontal

                interactive: true
                clip: true
                model: Core.shuffle(imagesModel)
                delegate: Image {
                    source: "qrc:/gcompris/src/activities/algorithm/resource/" + icon_ + ".svg"
                    sourceSize.width: passwordSelector.imageSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (passModel.count < 4)
                                passModel.append(imagesModel.get(index))
                        }
                    }
                }
            }
            ListView {
                id: passwordView
                width: parent.width
                height: passwordSelector.imageSize
                contentHeight: height
                spacing: GCStyle.halfMargins
                anchors.horizontalCenter: parent.horizontalCenter
                orientation: ListView.Horizontal

                interactive: true
                clip: true
                model: passModel
                delegate: Image {
                    source: "qrc:/gcompris/src/activities/algorithm/resource/" + icon_ + ".svg"
                    sourceSize.width: passwordSelector.imageSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: passModel.remove(index, 1)
                    }
                }
            }
        }
        Component.onCompleted: {
            var passImages = Core.getPasswordImages()
            for (var i = 0; i < passImages.length; i++)     // Move string array to ListModel
                imagesModel.append({ "icon_": passImages[i] })
        }
    }

    StackView {
        id: pageView
        anchors.fill: parent
        visible: !splash.visible
        focus: true

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
