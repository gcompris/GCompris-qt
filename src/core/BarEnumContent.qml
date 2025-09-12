/* GCompris - BarEnumContent.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

/*!
  \qmltype BarEnumContent
  \inqmlmodule core

  \brief QML container for defining all visible child elements of a Bar.
  \ingroup components

  Used in the Bar.content property.

  The value property must be set to a logically OR-ed combination of
  the other properties each representing one Bar element.
 */
QtObject {
    /**
     \brief Bitmask defining all visible elements of a bar.
     */
    property int value: 0

    /**
     \brief Representation of the help button.
     Used for opening a help screen.
     */
    readonly property int help: 1

    /**
     \brief Representation of the about button.
     Used on the menu screen.
     */
    readonly property int about: 2

    /**
     \brief Representation of the exit button.
     Used for exiting the application or returning to the menu.
     */
    readonly property int exit: 4

    /**
     \brief Representation of the home button.
     Used for returning from an acitivity to the main menu.
     */
    readonly property int home: 8

    /**
     \brief Representation of the config button.
     Used for switching to a config screen.
     */
    readonly property int config: 16

    /**
     \brief Representation of the current level and next and previous buttons.
     */
    readonly property int level: 32

    /**
     \brief Representation of the reload button.
     Used for restarting the current level of an activity.
     */
    readonly property int reload: 64

    /**
     \brief Representation of the repeat button.
     Used for repeating audio voices.
     */
    readonly property int repeat: 128

    /**
     \brief Representation of a currently running download.
     Shown automatically during running download.
     */
    readonly property int download: 256

    /**
     \brief Representation of the hint button.
     Used for displaying a hint to the children to help.
     */
    readonly property int hint: 512

    /**
     \brief Representation of the activity configuration button.
     Used for displaying the configuration of activities in the menu.
     */
    readonly property int activityConfig: 1024
}
