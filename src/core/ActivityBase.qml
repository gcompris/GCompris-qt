/* GCompris - ActivityBase.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0
import "qrc:/gcompris/src/core/core.js" as Core

/**
 * The base QML component for activities in GCompris.
 * @ingroup components
 *
 * Each activity should be derived from this component. It is responsible for
 *
 * * Activity common key handling,
 * * unified audio handling,
 * * screen switching dynamics (from/to Menu/DialogHelp/etc.)
 *
 * The following common keys are handled so far:
 *
 * * @c Ctrl+w: Exit the current activity and return to the menu,
 *              or close the application if on the menu page.
 * * @c Back:   Same as above.
 * * @c Escape: Same as above.
 *
 * Cf. Template.qml for a sample skeleton activity.
 *
 * Cf.
 * [the wiki](https://invent.kde.org/education/gcompris/-/wikis/Developers-corner/Development-process#adding-a-new-activity)
 * for further information about creating a new activity.
 *
 * @inherit QtQuick.Item
 */
Item {
    id: page

    /**
     * type:Item
     * Parent object.
     */
    property Item main: parent

    /**
     * type:Component
     * The top-level component containing the visible viewport of an activity.
     *
     * Put all you want to present the user into this container. Mostly
     * implemented using a Rectangle or Image component, itself
     * containing further graphical elements. You are pretty free of doing
     * whatever you want inside this component.
     *
     * Also common elements as Bar, Score, DialogHelp, etc. should be placed
     * inside this element.
     */
    property Component pageComponent

    /**
     * type:QtObject
     * Reference to the menu activity.
     *
     * Populated automatically during activity-loading.
     */
    property QtObject menu

    /**
     * type:QtObject
     * Reference to the ActivityInfo object of the activity.
     *
     * Populated automatically during activity-loading.
     */
    property QtObject activityInfo

    /**
     * type:GCAudio
     * The global audio item for voices.
     *
     * Because of problems synchronizing multiple Audio objects between
     * global/menu/main and individual activities, activities should refrain
     * from implementing additional Audio elements.
     *
     * Instead append to this global object to play your voices after the
     * intro music.
     * @sa GCAudio audioVoices
     */
    property GCAudio audioVoices

    /**
     * type:GCAudio
     * The global audio item for background music.
     *
     * @sa GCAudio backgroundMusic
     */
    property GCAudio backgroundMusic

    /**
     * type:string
     * The resource folder for the current activity. The resources
     * of each activity needs to be stored with the same pattern.
     * "qrc:/gcompris/src/activities/" + activity name + "/resource/"
     *
     */
    property string resourceUrl: (activityInfo && activityInfo.name) ? "qrc:/gcompris/src/activities/" + activityInfo.name.split('/')[0] + "/resource/": ""

    /**
     * type: bool
     * It tells whether the activity is a musical activity or not(if the activity contains it's own audio effects).
     *
     * If the activity is a musical activity, on starting it the background music pauses and when the activity is quit, background music resumes.
     *
     * Set it as true if the activity is musical.
     */
    property bool isMusicalActivity: false

    /**
     * type:int
     * The current level for this activity.
     */
    property int currentLevel: 0

    property var datasets: []
    property var levelFolder

    /**
     * type:Loading
     * The global loading object.
     *
     * Start it to signal heavy computation in case of GUI freezes.
     * @sa Loading
     */
    property Loading loading

    /**
     * type: bool
     * Check if the activity is the menu or not.
     * Set by default to false for all activities,
     * and only set to true inside Menu.qml
     */
    property bool isMenu: false

    /**
     * Emitted when the user wants to return to the Home/Menu screen.
     */
    signal home

    /**
     * Emitted when the user wants to return several views back in the
     * page stack.
     */
    signal back(Item to)

    /**
     * Emitted every time the activity has been started.
     *
     * Initialize your activity upon this signal.
     */
    signal start

    /**
     * Emitted when the activity is about to stop
     *
     * Shutdown whatever you need to upon this signal.
     */
    signal stop

    /**
     * Connected to stop signal
     * Used to stop all the voices and sounds from the activity
     */
    signal stopSounds

    /**
     * Emitted when dialog @p dialog should be shown
     *
     * Emit this signal when you want to show another dialog, e.g. on
     * Bar.onHelpClicked
     *
     * @param dialog Dialog to show.
     */
    signal displayDialog(Item dialog)

    /**
     * Emitted when multiple @p dialogs should be pushed on the page-stack
     *
     * Emit this signal when you want to stack >1 views. The last one will be
     * shown the intermediated ones will be kept on the page stack for later
     * pop() calls.
     *
     * @param dialogs Array of dialogs to push;
     */
    signal displayDialogs(var dialogs)

    //Initially hide it to avoid components appearing on the menu while the activity is loading.
    visible: false

    Component.onCompleted: {
        page.stop.connect(stopSounds);
    }
    onStopSounds: {
        if(!isMenu) {
            audioVoices.clearQueue();
            audioVoices.stop();
        }
    }

    onBack: (to) => menu ? menu.back(to) : ""
    onHome: menu ? menu.home() : ""
    onDisplayDialog: (dialog) => menu ? menu.displayDialog(dialog) : ""
    onDisplayDialogs: (dialogs) => menu ? menu.displayDialogs(dialogs) : ""

    Keys.forwardTo: activity.children
    Keys.onEscapePressed: home();

    Keys.onPressed: (event) => {
        if (event.modifiers === Qt.ControlModifier && event.key === Qt.Key_W) {
//          Ctrl+W exit the current activity
            home();
        }
    }
    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_Back) {
            event.accepted = true;
            home();
        }
    }

    Loader {
        id: activity
        sourceComponent: page.pageComponent
        anchors.fill: parent
    }

    onLevelFolderChanged: {
        if(levelFolder === undefined || levelFolder.length === 0) {
            return
        }

        datasets = [];
        var data = [];
        // sorting levelFolders in numeric manner
        levelFolder.sort(function(a, b) { return (parseInt(a) - parseInt(b)) });
        for(var level in levelFolder) {
            var id = levelFolder[level];
            var dataset = activityInfo.getDataset(id);
            if(dataset) {
                data = data.concat(dataset.data);
            }
        }
        datasets = data;
    }
}
