/* GCompris - GCTextPanel.qml
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

/**
 * A QML component with a Rectangle containing a GCText.
 * @ingroup components
 *
 * The textPanel expands depending on the textItem contentHeight/contentWidth,
 * with fixed padding around the text. Mostly used for instructions at the top of an activity.
 * @ref panelWidth and @ref panelHeight define the maximum size it can use.
 * @ref fixedHeight should be set to true when the size of the panel impacts the rest of
 * the activity's layout to avoid everything resizing depending on the panel size.
 */

Rectangle {
    id: textPanel

    /**
     * type:double
     * The maximum width available for the component.
     *
     * Typical values when used as a top instruction panel are:
     *     panelWidth: parent.width - 2 * GCStyle.baseMargins
     */
    required property double panelWidth

    /**
     * type:double
     * The maximum height available for the component.
     *
     * Typical values when used as a top instruction panel are:
     *     panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
     */
    required property double panelHeight

    /**
     * type:bool
     * Wether the panel height should be fixed to panelHeight or
     * relative to textItem's contentHeight.
     */
    property bool fixedHeight: false

    /**
     * type:bool
     * Wether the panel should be hidden if text is empty.
     */
    property bool hideIfEmpty: false

    /**
     * type:GCText
     * Alias of the textItem, to allow setting its text, color, fontSize or other variables.
     */
    property alias textItem: textItem

    visible: hideIfEmpty ? (textItem.text != "") : true
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
