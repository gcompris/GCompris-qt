/* GCompris - GCButtonStyle.qml
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
import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4
import GCompris 1.0

/**
 * Provides styling for GCompris' Buttons.
 * @ingroup components
 *
 * @inherit QtQuick.Controls.Styles.ButtonStyle
 */
ButtonStyle {
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
     * theme of the button. For now, three themes are accepted: "light" and "dark" and "highContrast"
     *
     * Default is dark.
    */
    property string theme: "dark"

    /**
     * type:var
     * existing themes for the button.
     * A theme is composed of:
     *   the colors of the button when selected: selectedColorGradient0 and selectedColorGradient1.
     *   the colors of the button when not selected: backgroundColorGradient0 and backgroundColorGradient1.
     *   the button's border color
     *   the text color
    */
    property var themes: {
        "dark": {
            backgroundColorGradient0: "#23373737",
            selectedColorGradient0: "#C03ACAFF",
            backgroundColorGradient1: "#13373737",
            selectedColorGradient1: "#803ACAFF",
            borderColor: "#FF373737",
            textColor: "#FF373737"
        },
        "light": {
            backgroundColorGradient0: "#42FFFFFF",
            selectedColorGradient0: "#C03ACAFF",
            backgroundColorGradient1: "#23FFFFFF",
            selectedColorGradient1: "#803ACAFF",
            borderColor: "white",
            textColor: "white"
        },
        "highContrast": {
            backgroundColorGradient0: "#EEFFFFFF",
            selectedColorGradient0: "#C03ACAFF",
            backgroundColorGradient1: "#AAFFFFFF",
            selectedColorGradient1: "#803ACAFF",
            borderColor: "white",
            textColor: "373737"
            
        }
    }

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
    
    background: Rectangle {
        border.width: control.activeFocus ? 4 : 2
        border.color: themes[theme].borderColor
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0 ; color: control.pressed ? themes[theme].selectedColorGradient0 : themes[theme].backgroundColorGradient0 }
            GradientStop { position: 1 ; color: control.pressed ? themes[theme].selectedColorGradient1 : themes[theme].backgroundColorGradient1 }
        }
    }
    label: Item {
        id: labelItem
        anchors.fill: parent
        implicitWidth: labelText.implicitWidth
        implicitHeight: labelText.implicitHeight

        GCText {
            id: labelText
            color: themes[theme].textColor
            text: control.text
            fontSize: textSizes[textSize].fontSize
            font.bold: textSizes[textSize].fontBold
            anchors.fill: parent
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
