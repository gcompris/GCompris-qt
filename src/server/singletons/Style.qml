/* GCompris - Style.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma Singleton

import QtQuick

QtObject {

    readonly property Palette darkPalette: Palette {
        accent: "#4a4a4a"
        alternateBase: "#292929"
        base: "#383838"
        button: "#747474" // actually used for scrollbars
        light: "#4a4a4a"
        text: "#C0C0C0"
        highlightedText: "#f2f2f2"
        highlight: "#53728E"
        window: "#7f7f7f"
    }

    readonly property Palette lightPalette: Palette {
        accent: "#d0d0d0"
        alternateBase: "#f4f4f4"
        base: "#e4e4e4"
        button: "#949494" // actually used for scrollbars
        light: "#f2f2f2"
        text: "#373737"
        highlightedText: "#080808"
        highlight: "#55a1ef"
        window: "#7f7f7f"
    }

    property bool isDarkTheme: true
    readonly property Palette selectedPalette: isDarkTheme ? darkPalette : lightPalette
    // used to load icons depending on selected theme
    readonly property string themePrefix: isDarkTheme ? "dark_" : "light_"

    readonly property int defaultRadius: 4
    readonly property int defaultBorderWidth: 2

    readonly property int margins: 8
    readonly property int smallMargins: 4
    readonly property int tinyMargins: 2
    readonly property int bigMargins: 16
    readonly property int hugeMargins: 32

    readonly property int controlSize: lineHeight
    readonly property int bigControlSize: controlSize * 2

    property int textSize: 16 // can be edited in settings
    readonly property int mediumTextSize: textSize * 1.5
    readonly property int bigTextSize: textSize * 2

    readonly property int lineHeight: textSize + bigMargins
    readonly property int mediumLineHeight: mediumTextSize + bigMargins
    readonly property int bigLineHeight: bigTextSize + bigMargins

    readonly property int textInputHeight: textSize + bigMargins
}
