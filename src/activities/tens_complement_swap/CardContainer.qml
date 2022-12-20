/* GCompris - CardContainer.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"

Item {
    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage:  "qrc:/gcompris/src/core/resource/cancel.svg"

    Rectangle {
        id: cardContainer
        color: "#EBEBEB"
        height: items.isHorizontal ? parent.height - background.layoutMargins :
                                    (parent.height - background.layoutMargins) * 0.67
        width: parent.width
        anchors.centerIn: parent
        radius: 15

        property int cardWidth: cardContainer.width / numberOfItemsInModel()

        // add 1 for numberCard or resultCard, else add 0.5
        function numberOfItemsInModel() {
            var numberOfItems = 0;
            if(listmodel) {
                for (var i = 0; i < listmodel.count; i++) {
                    if (listmodel.get(i).type == "symbolCard") {
                        numberOfItems += 0.5;
                    } else {
                        numberOfItems += 1;
                    }
                }
                return numberOfItems;
            } else {
                return 1;
            }
        }

        ListView {
            height: parent.height
            width: parent.width
            interactive: false
            orientation: ListView.Horizontal
            model: listmodel
            delegate: Card {
                height: cardContainer.height
                width: type == "symbolCard" ? cardContainer.cardWidth * 0.5 : cardContainer.cardWidth
            }
        }
    }

    Image {
        id: validationImage
        visible: isValidationImageVisible
        height: cardContainer.height
        width: height
        sourceSize.height: height
        source: isGood === true ? correctAnswerImage : wrongAnswerImage
        states: [
            State {
                name: "horizontalLayout"
                when: items.isHorizontal
                PropertyChanges {
                    target: validationImage
                    height: cardContainer.height
                    anchors.margins: background.layoutMargins * 0.5
                }
                AnchorChanges {
                    target: validationImage
                    anchors {
                        left: cardContainer.right
                        verticalCenter: cardContainer.verticalCenter
                        right: undefined
                        top: undefined
                    }
                }
            },
            State {
                name: "verticaleLayout"
                when: !items.isHorizontal
                PropertyChanges {
                    target: validationImage
                    height: cardContainer.height * 0.5
                    anchors.margins: -background.layoutMargins * 0.5
                }
                AnchorChanges {
                    target: validationImage
                    anchors {
                        left: undefined
                        verticalCenter: undefined
                        right: cardContainer.right
                        top: cardContainer.bottom
                    }
                }
            }
        ]
    }
}
