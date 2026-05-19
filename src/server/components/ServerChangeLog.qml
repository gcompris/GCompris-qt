/* GCompris - ServerChangeLog.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

Popup {
    id: serverChangelog

    readonly property string label: qsTr("Changelog")

    anchors.centerIn: Overlay.overlay
    width: Overlay.overlay.width
    height: Overlay.overlay.height
    modal: true
    closePolicy: Popup.CloseOnEscape

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.text
        border.width: Style.defaultBorderWidth
    }

    Column {
        id: topColumn
        width: parent.width
        height: childrenRect.height
        spacing: Style.margins

        Rectangle {
            width: parent.width
            height: exampleText.height + Style.bigMargins
            color: Style.selectedPalette.alternateBase
            Text {
                id: exampleText
                width: parent.width - Style.bigMargins
                anchors.centerIn: parent
                font.pixelSize: Style.textSize
                color: Style.selectedPalette.text
                text: getLogBetween(0, 10000000)
                wrapMode: Text.WordWrap
            }
        }
    }

    OkCancelButtons {
        id: bottomButtons
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        cancelButtonEnabled: false
        onValidated: close()
    }

    /**
     * type: list
     * List of changelog objects.
     *
     * A changelog object consists of the properties @c versionCode
     * and an optional @c content (which changes have been added in this version).
     * The activities added in this version are retrieved from the ActivityInfoTree and directly displayed.
     *
     */
    property var changelog: [
            { "versionCode": 270000, "content": [
                qsTr("Sequences added: ..."),
                qsTr("Editors added for activities: ..."),
                qsTr("Display updated for activities: ..."),
                qsTr("Note: the following activities have their current data erased in order to improve the quality of their data display: gletters, smallnumbers, smallnumbers2 and wordsgame.")
                ]
            },
            { "versionCode": 260000, "content": [
                qsTr("Initial version")
            ]
            }
    ]

    function isNewerVersion(previousVersion, newVersion) {
        return newVersion > previousVersion
    }

    function getLogBetween(previousVersion, newVersion) {
        var filtered = changelog.filter(function filter(obj) {
            return isNewerVersion(previousVersion, obj['versionCode'])
        });
        var output = "";
        // display for each version an optional text ("content") then the new activities
        filtered.map(function filter(obj) {
            var major = Math.floor((obj['versionCode'] / 10000));
            var minor = (obj['versionCode'] % 10000 / 100);
            var patch = (obj['versionCode'] % 100);

            var version = major + "." + minor;
            if(patch !== 0) {
                version += "."+patch;
            }
            output += "<b>" + qsTr("Version %1:").arg(version) + "</b>";
            output += "<ul>";
            // display free text if exist
            for(const text of obj['content'])
                output += "<li>" + text + "</li>";
            output += "</ul>";
        });

        return output
    }
}
