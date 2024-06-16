/* GCompris - Style.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma Singleton
import QtQuick 2.12

Item {
// Bruno's colors
    readonly property color colorBackground: "beige"
    readonly property color textInputBackground: "white"
    readonly property color colorNavigationBarBackgroundDisabled: "wheat"
    readonly property color colorNavigationBarBackground: "peru"
    readonly property color colorBackgroundDialog: "wheat"
    readonly property color colorButtonDialog: "sienna"
    readonly property color colorHover: "lightcoral"
    readonly property color colorNavigationBarFont: "maroon"
    readonly property color colorErrorDialog: "tomato"
    readonly property color colorButton: "burlywood"
    readonly property color colorHoveredButton: "darkgoldenrod"
    readonly property real widthNavigationButtonIcon: 70
    readonly property real heightNavigationButtonIcon: 60

    readonly property color colorBackgroundPane: "wheat"
    readonly property color colorHeaderPane: "burlywood"
    readonly property color colorDateSelected: "peru"

    readonly property real heightTopPanel: heightNavigationButtonIcon

    property int defaultLineHeight: 1.8 * defaultPixelSize
    property int mediumLineHeight: defaultLineHeight + 6
    property int defaultPixelSize: 13

//    readonly property int defaultLineHeight: 25
//    readonly property int mediumLineHeight: 35
    readonly property int activityHeaderHeight: 50
    readonly property int linesSpacing: -1
    readonly property int displayLineHeight: 20

// Historical colors
//     readonly property color colorBackground: "#ffffff"
//    readonly property color colorBackgroundDialog: "azure"

    readonly property real sizeScreenMargin: 20
    readonly property real sizeControlSpacing: 10

//    readonly property color colorNavigationBarBackgroundDisabled: "#aaaaaa"
//    readonly property color colorNavigationBarBackground: "#2a56c6"
//    readonly property color colorNavigationBarFont: "#ffffff"
    readonly property int pixelSizeNavigationBarIcon: 42
    readonly property int pixelSizeNavigationBarText: 15
    readonly property int pixelSizeTopPanelText: 25
    readonly property real widthNavigationBarCollapsed: widthNavigationButtonIcon
    readonly property real widthNavigationBarExpanded: widthNavigationButton

//    readonly property real widthNavigationButtonIcon: 80
//    readonly property real heightNavigationButtonIcon: widthNavigationButtonIcon
    readonly property real widthNavigationButtonDescription: 160
    readonly property real heightNavigationButtonDescription: heightNavigationButtonIcon
    readonly property real widthNavigationButton: widthNavigationButtonIcon + widthNavigationButtonDescription
    readonly property real heightNavigationButton: Math.max(heightNavigationButtonIcon, heightNavigationButtonDescription)
}
