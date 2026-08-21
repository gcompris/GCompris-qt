/* GCompris - OrderingNumbersDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2026 GCompris
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import "../../components"
import "../../singletons"

Item {
    id: root
        required property var jsonData
         height: contentColumn.height + Style.smallMargins * 2
         width: parent ? parent.width : 300

        Column {
             id: contentColumn
             anchors.centerIn: parent
             spacing: Style.smallMargins
        }
    //     // Sens du rangement & statut
    //     Row {
    //         spacing: Style.margins
    //         GCText {
    //             text: root.jsonData.sortDirection === "ascending" ? "↑ (Croissant)" : "↓ (Décroissant)"
    //             font.bold: true
    //         }
    //         GCText {
    //             text: root.jsonData.isSuccess ? "✓ Correct" : "✗ Erreur"
    //             color: root.jsonData.isSuccess ? "green" : "red"
    //         }
    //     }

    //     // Réponse de l'élève vs Attendue
    //     Row {
    //         spacing: Style.margins

    //         // Ce qu'a mis l'élève
    //         Row {
    //             spacing: 4
    //             GCDtext { text: "Élève : "; font.pixelSize: Style.smallTextSize }
    //             Repeater {
    //                 model: root.jsonData.currentOrder
    //                 delegate: Rectangle {
    //                     required property var modelData
    //                     required property int index

    //                     // Vérification si l'élément est à la bonne place
    //                     readonly property bool isCorrect: root.jsonData.expectedOrder &&
    //                                                        root.jsonData.expectedOrder[index] === modelData

    //                     width: cellText.implicitWidth + 8
    //                     height: cellText.implicitHeight + 4
    //                     color: isCorrect ? "#e0ffe0" : "#ffe0e0"
    //                     border.color: isCorrect ? "green" : "red"
    //                     radius: 4

    //                     GCDtext {
    //                         id: cellText
    //                         anchors.centerIn: parent
    //                         text: parent.modelData
    //                     }
    //                 }
    //             }
    //         }
    //     }

    //     // Ordre attendu si erreur
    //     Row {
    //         visible: !root.jsonData.isSuccess && root.jsonData.expectedOrder
    //         spacing: 4
    //         GCDtext { text: "Attendu : "; font.pixelSize: Style.smallTextSize; color: "gray" }
    //         Repeater {
    //             model: root.jsonData.expectedOrder
    //             delegate: GCDtext {
    //                 required property var modelData
    //                 text: modelData + (index < root.jsonData.expectedOrder.length - 1 ? " →" : "")
    //                 color: "gray"
    //             }
    //         }
    //     }
    // }
}