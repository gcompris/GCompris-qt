/* GCompris - GCStyle.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma Singleton
import QtQuick 2.12
import core 1.0

/**
 * A QML singleton to store all shared style-related values (common colors, borders and margins)
 */

QtObject {
    // margins (used also for rectangle corner's radius)
    readonly property int baseMargins: 10 * ApplicationInfo.ratio
    readonly property int halfMargins: 5 * ApplicationInfo.ratio
    readonly property int tinyMargins: Math.max(1, 2 * ApplicationInfo.ratio)

    // border sizes
    readonly property int thickestBorder: Math.max(3, 5 * ApplicationInfo.ratio)
    readonly property int thickBorder: Math.max(2, 4 * ApplicationInfo.ratio)
    readonly property int midBorder: Math.max(2, 3 * ApplicationInfo.ratio)
    readonly property int thinBorder: Math.max(1, 2 * ApplicationInfo.ratio)
    readonly property int thinnestBorder: Math.max(1, ApplicationInfo.ratio)

    // small button's height in menu config page
    readonly property int smallButtonHeight: 30 * ApplicationInfo.ratio

    // border colors
    readonly property color whiteBorder: "#ffffff"
    readonly property color darkBorder: "#373737"
    readonly property color darkerBorder: "#191919"
    readonly property color noBorder: "#00ffffff"
    readonly property color blueBorder: "#87A6DD"
    readonly property color grayBorder: "#808080"

    // colors for text and its background
    readonly property color whiteText: "#ffffff"
    readonly property color lightText: "#f2f2f2"
    readonly property color darkText: "#373737"
    readonly property color darkerText: "#191919"

    readonly property color lightBg: "#f2f2f2"
    readonly property color lighterBg: "#f8f8f8"
    readonly property color lightTransparentBg: "#AAffffff"
    readonly property color whiteBg: "#ffffff"
    readonly property color whiteBlueBg: "#f6fbfc"
    readonly property color whiteBlueTransparentBg: "#80f6fbfc"
    readonly property color darkBg: "#373737"
    readonly property color darkTransparentBg: "#13373737"

    readonly property color highlightColor: "#3ac5f7"
    readonly property color focusColor: "#99e1fc"

    // special button Bg colors
    readonly property color buttonColor: "#ffffff"
    readonly property color goodAnswer: "#0099ff"
    readonly property color badAnswer: "#ff6666"
    // special sliders colors
    readonly property color sliderHandle: "#ffffff"
    readonly property color sliderPressed: "#3ac5f7"
    readonly property color sliderFill: "#3ac5f7"
    readonly property color sliderEmpty: "#585858"
    readonly property color sliderBorder: "#808080"

    // color for config panels
    readonly property color configBg: "#696da3"
    // color for GCCreationHandler Bg and some activities
    readonly property color lightBlueBg: "#abcdef"

    // grayed background behind pop-up dialogs
    readonly property color grayedBg: "#C080a0c0"
}
