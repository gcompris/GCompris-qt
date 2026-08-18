import "../../core"
/* GCompris - multiple_questions_exercices.qml
 *
 * SPDX-FileCopyrightText: 2024 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 6.7
import QtQuick.Controls
import QtQuick.Layouts
import "markup-exercice-engine.js" as Activity



ActivityBase {
    id: activity

    property color selectedColor: "transparent"
    property bool isSelecting: false

    onStart: focus = true
    onStop: {
    }

    pageComponent: Rectangle {
        id: background

        signal start()
        signal stop()

        anchors.fill: parent
        color: "#ABCDEF"
        Component.onCompleted: {
            activity.start.connect(start);
            activity.stop.connect(stop);
        }
        onStart: {
            Activity.start(items);
        }
        onStop: {
            Activity.stop();
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items

            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias textAreaInput: textAreaInput
            property alias flowsColumn: flowsColumn
            property alias realViewArea: realViewArea
        }

        SplitView {
            id: mySplitView

            anchors.fill: parent
            orientation: Qt.Horizontal

            Rectangle {
                id: mDViewArea
                //color: "#FF0000"

                SplitView.minimumWidth: 100
                SplitView.minimumHeight: 100
                SplitView.preferredWidth: background.width / 2
                width: 1000


                ScrollView {

                    width: mDViewArea.width
                    height: activity.height - bar.height



                    TextArea {
                        id: textAreaInput

                        property bool textIsBold: false
                        anchors.fill: parent
                        onTextChanged: {
                            Activity.convertSourceTextToApp()
                        }

                        Component.onCompleted: {
                            text = [
                                "# Ceci est un titre de paragraphe",
                                "La ligne suivante permet de donner le type d'exercice (qcm - gap-fill - highlight).",
                                "Elle n'apparaît pas à l'écran.",
                                "#set type_exercice(qcm-exercice)",
                                "",
                                "La ligne suivante permet de créer un nouvel exercice, cela va entre autre gérer la numérotation des exercices et de ses questions.",
                                "Elle n'apparaît pas à l'écran.",
                                "",
                                "La ligne suivante déclare la ligne comme était une ligne d'énoncé.",
                                "L'énoncé est numéroté.",
                                "",
                                "#set new_exercice",
                                "#set enumeration_marks( )",
                                "$ *Choisis* la bonne forme du verbe à l'imparfait",
                                "1. Je [jouerai|jouerais|*jouais]",
                                "2. Tu [*regardais|regarderais|regarderas]",
                                "3. Il [*mangeait|mangerait|mangera]",
                                "4. Nous [finirions|finirons|*finissions]",
                                "5. Vous [*lisiez|liriez|lirez]",
                                "#set score(middle)",
                                "#set end_exercice",
                                "",
                                "#set new_exercice",
                                "$ *Complète* avec le verbe à l'imparfait",
                                "1. Chaque matin, je [prendrais|*prenais|prendrai]",
                                "2. Le chien [*aboyait|aboiera|aboyerait]",
                                "3. Les enfants [chanteraient|*chantaient|chanteront]",
                                "4. Elle [*jouait|jouera|jouerait]",
                                "5. Nous [*allions|irons|irions]",
                                "#set score(middle)",
                                "#set end_exercice",
                                "",
                                "#set type_exercice(gap-fill-exercice)",
                                "#set new_exercice",
                                "#set enumeration_marks( )",
                                "$ *Complète* les terminaisons à l'imparfait",
                                "Je mang[.....|eais]",
                                "Tu regard[.....|ais]",
                                "Elle parl[.....|ait]",
                                "Nous jou[.....|ions]",
                                "#set score(middle)",
                                "#set end_exercice",
                            ].join("\n")
                        }
                    }
                }
            }

            Rectangle {
                id: realViewArea

                SplitView.preferredWidth: 500
                SplitView.minimumHeight: 100

                Flickable {
                    id: zoomFlickable
                    anchors.fill: parent

                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.HorizontalAndVerticalFlick
                    clip: true
                    interactive: true

                    contentWidth: flowsContainer.width * flowsContainer.scale
                    contentHeight: flowsContainer.height * flowsContainer.scale

                    // Enable smooth scrolling with mouse wheel
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                    ScrollBar.horizontal: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    // Container for pinch-to-zoom and translation
                    Item {
                        id: flowsContainer
                        width: Math.max(flowsColumn.width, zoomFlickable.width / flowsContainer.scale)
                        height: flowsColumn.implicitHeight
                        scale: 1.0
                        transformOrigin: Item.TopLeft

                        // ColumnLayout {
                        //     id: flowsColumn
                        //     width: flowsContainer.scale <= 1.0 ? zoomFlickable.width : 800
                        //     anchors.margins: 4
                        //     spacing: 10
                        // }

                        ColumnLayout {
                            id: flowsColumn
                            width: flowsContainer.scale <= 1.0 ? zoomFlickable.width : 800
                            // Force la colonne à prendre toute la hauteur nécessaire pour tous ses FlexboxLayout
                            //height: implicitHeight
                            anchors.margins: 4
                            spacing: 10

                            anchors.left: parent.left
                            anchors.leftMargin: 20

                        }

                        PinchArea {
                            id: pinchArea
                            anchors.fill: parent
                            pinch.target: flowsContainer
                            pinch.minimumScale: 0.5
                            pinch.maximumScale: 3.0

                            onPinchUpdated: (pinch) => {
                                // adjust Flickable content origin keeping pinch center stable
                                zoomFlickable.contentX -= (pinch.center.x * (flowsContainer.scale - pinch.previousScale))
                                zoomFlickable.contentY -= (pinch.center.y * (flowsContainer.scale - pinch.previousScale))
                            }

                            // Allow mouse events to pass through when not pinching
                            MouseArea {
                                anchors.fill: parent
                                propagateComposedEvents: true

                                onWheel: (wheel) => {
                                    // Check if Ctrl is pressed for zoom
                                    if (wheel.modifiers & Qt.ControlModifier) {
                                        // Zoom with Ctrl + Wheel
                                        var factor = wheel.angleDelta.y > 0 ? 1.12 : 0.88

                                        var local = Qt.point(wheel.x, wheel.y)
                                        var oldScale = flowsContainer.scale
                                        var newScale = Math.max(0.5, Math.min(3.0, oldScale * factor))
                                        var scaleRatio = newScale / oldScale

                                        var pointerContentX = zoomFlickable.contentX + local.x
                                        var pointerContentY = zoomFlickable.contentY + local.y

                                        zoomFlickable.contentX = (pointerContentX * scaleRatio) - local.x
                                        zoomFlickable.contentY = (pointerContentY * scaleRatio) - local.y

                                        flowsContainer.scale = newScale

                                        // Keep content within bounds
                                        zoomFlickable.contentX = Math.max(0, Math.min(zoomFlickable.contentX,
                                            Math.max(0, flowsContainer.width * flowsContainer.scale - zoomFlickable.width)))
                                        zoomFlickable.contentY = Math.max(0, Math.min(zoomFlickable.contentY,
                                            Math.max(0, flowsContainer.height * flowsContainer.scale - zoomFlickable.height)))

                                        wheel.accepted = true
                                    } else if (wheel.modifiers & Qt.ShiftModifier) {
                                        // Shift + Wheel = Horizontal scroll
                                        var delta = wheel.angleDelta.y
                                        zoomFlickable.contentX = Math.max(0, Math.min(
                                            zoomFlickable.contentX - delta,
                                            Math.max(0, flowsContainer.width * flowsContainer.scale - zoomFlickable.width)
                                        ))
                                        wheel.accepted = true
                                    } else {
                                        // Normal scroll - let it propagate to Flickable
                                        wheel.accepted = false
                                    }
                                }

                                onPressed: (mouse) => {
                                    mouse.accepted = false
                                }
                                onReleased: (mouse) => {
                                    mouse.accepted = false
                                }
                                onClicked: (mouse) => {
                                    mouse.accepted = false
                                }
                            }
                        }
                    }
                }

                Button {
                    id: okButton
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    text: "Ok"
                    z: 10
                    onClicked: {
                        Activity.checkAnswers()
                    }
                }

                // Color Selection (exercice type: highlight)
                Column {
                    id: colorSelection
                    anchors.right: parent.right
                    anchors.bottomMargin: 10
                    z: 10
                    spacing: 8

                    Repeater {
                        model: [
                            { name: "red", value: "red" },
                            { name: "blue", value: "blue" },
                            { name: "yellow", value: "yellow" },
                            { name: "green", value: "green" }
                        ]
                        delegate: Button {
                            text: modelData.name
                            onClicked: selectedColor = modelData.value
                            z: 1000
                            background: Rectangle {
                                color: modelData.value
                                radius: 6
                                border.width: selectedColor === modelData.value ? 3 : 0
                                border.color: "black"
                            }
                        }
                    }

                    Rectangle {
                        width: 36
                        height: 24
                        radius: 4
                        color: selectedColor === "transparent" ? "#eeeeee" : selectedColor
                        border.width: 1
                        border.color: "black"
                    }
                }

                DisplayText {
                    anchors.bottom: colorSelection.top
                    anchors.right: parent.right
                    wordText: flowsColumn.width
                    width: 50
                    height: 50
                }
            }
        }

        DialogHelp {
            id: dialogHelp

            onClose: home()
        }

        Bar {
            id: bar

            level: items.currentLevel + 1
            onHelpClicked: {
                displayDialog(dialogHelp);
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()

            content: BarEnumContent {
                value: help | home | level
            }

        }

        Bonus {
            id: bonus

            Component.onCompleted: win.connect(Activity.nextLevel)
        }

    }

}
