/* GCompris - Loading.qml
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
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
import GCompris 1.0

/**
 * A QML component presenting a loading overlay to the user
 *
 * Should be used whenever the application is performing heavy work, that
 * would lead to a freeze in the GUI. The interface is simple:
 * <ul>
 *   <li>
       start() starts the loading overlay. As a result interaction with the ui
 *     is no longer possible (via touch/mouse) except for key event handling.
 *   </li>
 *   <li>
 *     stop() stops the loading overlay. A user must take care to call stop()
 *     in all possible (also error-) cases or the application never leaves
 *     the loading overlay again.
 *   </li>
 * </ul>
 *
 * There should be only one single Loading object anchored in the main window
 * as a sibling to the page stack. Activities are supposed to use this single
 * instance via the ActivityBase.loading property.
 *
 * Note that you can't use the loading animation to signal heavy ui changes that are
 * issued synchronously as the QML scene won't be updated fast enough to
 * even show the loading item. Therefore, to avoid freezing the ui, use...
 * <ul>
 *   <li>
 *     ... WorkerScript-s for ListModel based ui changes and
 *   </li>
 *   <li>
 *     ... Component.incubateObject() for dynamic ui changes object creation
 *   </li>
 * </ul>
 */
Item {
    id: root

    /**
     * type:bool
     * Whether the loading icon is active.
     */
    property bool active: true

    /**
     * Start the loading overlay.
     */
    function start() {
        visible = true;
        active = true;
    }

    /**
     * Stop the loading overlay.
     */
    function stop() {
        active = false;
        visible = false;
    }

    anchors.fill: parent
    z: 10001  // should be the highest value in the whole scene

    visible: false

    MultiPointTouchArea {
        // Just to catch mouse events
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        color: "grey"
    }

    Image {
        id: loadingImage
        source: "qrc:/gcompris/src/core/resource/loading.svg";
        anchors.centerIn: parent
        sourceSize.width: 1024
        width: 150
        height: 150
        opacity: 0.8

        RotationAnimation on rotation {
            id: rotation
            running: root.active
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1500
        }
    }
}
