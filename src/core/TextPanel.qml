/* GCompris - TextPanel.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

/* A text panel which expands depending on the text contentHeight/contentWidth,
 * with fixed padding around the text. Mostly used for instructions at the top of an activity.
 * "panelWidth" and "panelHeight" define the maximum size it can use.
 * Typical values when used as a top instruction panel are:
 *     panelWidth: parent.width - 2 * GCStyle.baseMargins
 *     panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
 * "fixedHeight" should be set to true when the size of the panel impacts the rest of the activity's
 * layout to avoid everything resizing depending on the panel size.
 */

Rectangle {
    id: textPanel
    required property double panelWidth
    required property double panelHeight
    property bool fixedHeight: false
    property alias textItem: textItem

    width: textItem.contentWidth + GCStyle.baseMargins * 2
    height: fixedHeight ? panelHeight : textItem.contentHeight + GCStyle.baseMargins
    radius: GCStyle.halfMargins

    // default panel color and borders
    color: GCStyle.darkBg
    border.color: GCStyle.lightBorder
    border.width: GCStyle.thinnestBorder

    GCText {
        id: textItem
        width: textPanel.panelWidth - GCStyle.baseMargins * 2
        height: textPanel.panelHeight - GCStyle.baseMargins
        anchors.centerIn: parent
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        // default text color and size
        color: GCStyle.lightText
        fontSize: mediumSize
    }
}
