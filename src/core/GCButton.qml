/* GCompris - GCButton.qml
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import QtQuick.Controls.Basic

/**
 * A QML component representing GCompris' buttons.
 * @ingroup components
 *
 * @inherit QtQuick2.Button
 */
Button {
    id: buttonControl

    /**
     * type:real
     * Fixed font size of the label in pt.
     *
     * Set to a value > 0 for enforcing a fixed font.pointSize for the label,
     * that won't be updated with ApplicationSettings.baseFontSize.
     * @sa ApplicationSettings.baseFontSize, GCText.fixFontSize
     */
    property real fixedFontSize: -1

    /**
     * type:string
     * theme of the button.
     *
     * Default is dark.
    */
    property string theme: "dark"

    /**
     * type:real
     * if there is an icon on the right, we need to add a rightMargin for the text label
     * 
     * Default is 0.
     */
    property real rightIconSize: 0

    /**
     * type:var
     * existing themes for the button.
     * A theme is composed of:
     *   the color of the button when not selected: backgroundColor
     *   the color of the button when pressed: pressedColor
     *   the color of the button selected: focusColor
     *   the button's border color
     *   the text color
    */
    property var themes: {
        "dark": {
            backgroundColor: GCStyle.darkTransparentBg,
            pressedColor: GCStyle.highlightColor,
            focusColor: GCStyle.focusColor,
            borderColor: GCStyle.darkBorder,
            textColor: GCStyle.darkText
        },
        "highContrast": {
            backgroundColor: GCStyle.lighterBg,
            pressedColor: GCStyle.highlightColor,
            focusColor: GCStyle.focusColor,
            borderColor: GCStyle.whiteBorder,
            textColor: GCStyle.darkText
        },
        "categories": {
            backgroundColor: GCStyle.whiteBlueTransparentBg,
            pressedColor: GCStyle.whiteBlueBg,
            focusColor: GCStyle.whiteBlueTransparentBg,
            borderColor: GCStyle.blueBorder,
            textColor: GCStyle.darkText
        },
        "settingsButton": {
            backgroundColor: GCStyle.lightTransparentBg,
            pressedColor: GCStyle.lightBg,
            focusColor: GCStyle.lightBg,
            borderColor: selected ? GCStyle.whiteBorder : GCStyle.noBorder,
            textColor: GCStyle.darkerText
        },
        "noStyle": {
            backgroundColor: "#00FFFFFF",
            pressedColor: "#00FFFFFF",
            focusColor: "#00FFFFFF",
            borderColor: "#00FFFFFF",
            textColor: "#00000000"
        }
    }

    property bool selected: false

    property string textSize: "regular"
    
    property var textSizes: {
        "regular": {
            fontSize: 14,
            fontBold: false
        },
        "subtitle": {
            fontSize: 16,
            fontBold: true
        },
        "title": {
            fontSize: 24,
            fontBold: true
        }
    }
    
    focusPolicy: Qt.NoFocus
    
    background: Rectangle {
        border.width: buttonControl.activeFocus || buttonControl.selected ? GCStyle.midBorder : GCStyle.thinnestBorder
        border.color: themes[theme].borderColor
        radius: GCStyle.halfMargins
        color: (buttonControl.pressed || buttonControl.down ? themes[theme].pressedColor :
                (buttonControl.selected ? themes[theme].focusColor : themes[theme].backgroundColor))
    }
    contentItem: Item {
        id: labelItem
        anchors.fill: parent
        implicitWidth: labelText.implicitWidth
        implicitHeight: labelText.implicitHeight

        GCText {
            id: labelText
            color: themes[theme].textColor
            text: buttonControl.text
            fontSize: textSizes[textSize].fontSize
            font.bold: textSizes[textSize].fontBold
            anchors.fill: parent
            anchors.margins: GCStyle.halfMargins
            anchors.rightMargin: rightIconSize > 0 ? rightIconSize :  GCStyle.halfMargins // if there's a rightIconSize, it must handle the rightMargin
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit

            Component.onCompleted: {
                if (fixedFontSize > 0) {
                    labelText.fixFontSize = true;
                    labelText.fontSize = fixedFontSize;
                }
            }
        }
    }
}
