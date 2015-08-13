/* GCompris - quiz.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick)
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
import QtQuick 2.1
import GCompris 1.0

import "../../core"
import "computer.js" as Activity

Item {

    property bool horizontalLayout: parent.width > parent.height

    QtObject {
        id: quiz
        property alias answers: answers
    }

    Column
    {
        id: buttonHolder
        property bool buttonHolderMouseArea : true
        spacing: 10 * ApplicationInfo.ratio
        x: holder.x - width - 10 * ApplicationInfo.ratio
        y: 30

        add: Transition {
            NumberAnimation { properties: "y"; from: 10; duration: 500 }
        }

        Repeater
        {
            id: answers

            AnswerButton {
                width: 120 * ApplicationInfo.ratio
                height: 80 * ApplicationInfo.ratio
                textLabel: modelData
                isCorrectAnswer: modelData === Activity.getCorrectAnswer()
                onCorrectlyPressed: Activity.answerPressed(modelData)
                onPressed: {
                    Activity.playLetter(modelData)
                    if(modelData === Activity.getCorrectAnswer()) Activity.showAnswer()
                }
            }
        }
    }
}
