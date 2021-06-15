/* GCompris - MoveButtons.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

import "../../core" as Core
import "deplacements.js" as Activity

Item {
    id: moveButtons
    
    property double size: Math.min(width/4, 55 * ApplicationInfo.ratio)
    
    Flow {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 15 * ApplicationInfo.ratio        
        
        Rectangle {
            id: upButton
            width: size
            height: size
            color: "pink"
            border {
                color: "white"
                width: 3
            }
            radius: 0.5 * width
        }
        
        Rectangle {
            id: downButton
            width: size
            height: size
            color: "pink"
            border {
                color: "white"
                width: 3
            }
            radius: 0.5 * width
        }
        
        Rectangle {
            id: leftButton
            width: size
            height: size
            color: "pink"
            border {
                color: "white"
                width: 3
            }
            radius: 0.5 * width
        }
        
        Rectangle {
            id: rightButton
            width: size
            height: size
            color: "pink"
            border {
                color: "white"
                width: 3
            }
            radius: 0.5 * width
        }
    }
    
}
