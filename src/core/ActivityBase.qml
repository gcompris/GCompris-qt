/* GCompris - ActivityBase.qml
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
import QtQuick 2.2
import GCompris 1.0
import "qrc:/gcompris/src/core/core.js" as Core

/**
 * The base QML component for activities in GCompris.
 * @ingroup components
 *
 * Each activity should be derived from this component. It is responsible for
 *
 * * basic common key handling,
 * * unified audio handling,
 * * screen switching dynamics (from/to Menu/DialogHelp/etc.)
 *
 * The following common keys are handled so far:
 *
 * * @c Ctrl+q: Exit the application.
 * * @c Ctrl+b: Toggle the bar.
 * * @c Ctrl+f: Toggle fullscreen.
 * * @c Ctrl+m: Toggle audio effects.
 * * @c Ctrl+w: Exit the current activity and return to the menu.
 * * @c Ctrl+p: Make a screenshot.
 * * @c Back:   Return to the home screen (corresponds to the 'Back' button on
 *              Android).
 *
 * Cf. Template.qml for a sample skeleton activity.
 *
 * Cf.
 * [the wiki](http://gcompris.net/wiki/Qt_Quick_development_process#Adding_a_new_activity)
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
    property Item main: parent;

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
     * @sa GCAudio audioEffects
     */
    property GCAudio audioVoices

    /**
     * type:GCAudio
     * The global audio item for audio effects.
     *
     * Append to it to play your effects.
     * @sa GCAudio audioEffects
     */
    property GCAudio audioEffects

    /**
     * type:GCAudio
     * The global audio item for background music.
     *
     * @sa GCAudio backgroundMusic
     */
    property GCAudio backgroundMusic

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
     * type:Loading
     * The global loading object.
     *
     * Start it to signal heavy computation in case of GUI freezes.
     * @sa Loading
     */
    property Loading loading

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

    onBack: menu ? menu.back(to) : ""
    onHome: menu ? menu.home() : ""
    onDisplayDialog: menu ? menu.displayDialog(dialog) : ""
    onDisplayDialogs: menu ? menu.displayDialogs(dialogs) : ""

    Keys.forwardTo: activity.children
    Keys.onEscapePressed: home();
    Keys.onPressed: {
        if (event.modifiers === Qt.ControlModifier &&
                event.key === Qt.Key_Q) {
            // Ctrl+Q exit the application
            Core.quit(main);
        } else if (event.modifiers === Qt.ControlModifier &&
                event.key === Qt.Key_B) {
            // Ctrl+B toggle the bar
            ApplicationSettings.isBarHidden = !ApplicationSettings.isBarHidden;
        } else if (event.modifiers === Qt.ControlModifier &&
                event.key === Qt.Key_F) {
            // Ctrl+F toggle fullscreen
            ApplicationSettings.isFullscreen = !ApplicationSettings.isFullscreen
        } else if (event.modifiers === Qt.ControlModifier &&
                   event.key === Qt.Key_M) {
            // Ctrl+M toggle sound
            // We mute / unmute both channels in sync
            ApplicationSettings.isAudioVoicesEnabled = !ApplicationSettings.isAudioVoicesEnabled
            ApplicationSettings.isAudioEffectsEnabled = ApplicationSettings.isAudioVoicesEnabled
            ApplicationSettings.isBackgroundMusicEnabled = ApplicationSettings.isAudioVoicesEnabled
        } else if (event.modifiers === Qt.ControlModifier &&
                   event.key === Qt.Key_W) {
            // Ctrl+W exit the current activity
            home()
        } else if (event.modifiers === Qt.ControlModifier &&
                   event.key === Qt.Key_P) {
            // Ctrl+P Screenshot
            ApplicationInfo.screenshot("/tmp/" + activityInfo.name.split('/')[0] + ".png")
        }
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            event.accepted = true
            home()
        }
    }

    Loader {
        id: activity
        sourceComponent: pageComponent
        anchors.fill: parent
    }

    Loader {
        id: demoPageLoader
        source: ApplicationSettings.activationMode == 1 ?
                    "BuyMeOverlayInapp.qml" : "BuyMeOverlay.qml"
        anchors.fill: parent
        active: !activityInfo.demo && ApplicationSettings.isDemoMode
    }
}
