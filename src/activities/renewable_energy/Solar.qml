/* GCompris - solar.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick)
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
import "renewable_energy.js" as Activity
import "../../core"

Item {
    id: solar

    Image {
        id: solar_transformer
        source: activity.url + "transformer.svg"
        sourceSize.width: parent.width*0.05
        height: parent.height*0.08
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height*0.38
            rightMargin: parent.width*0.11
        }
        MouseArea {
            id: solar_area
            visible: false
            anchors.fill: solar_transformer
            onClicked: {
                if(Activity.click == false && Activity.panel_activate == true) {
                    solarpower.source = activity.url + "solar/solarpoweron.svg"
                    solar_info.text = "400 W"
                    Activity.click = true
                    Activity.add(400)
                    Activity.volt(400)
                    Activity.update()
                }
                else {
                    solarpower.source = activity.url + "solar/solarpoweroff.svg"
                    solar_info.text = "0 W"
                    Activity.click = false
                    Activity.add(-400)
                    Activity.volt(-400)
                    Activity.update()
                    Activity.verify()
                }
            }
        }
    }

    Image{
        source: activity.url + "left.svg"
        sourceSize.width: solar_transformer.width/2
        sourceSize.height: solar_transformer.height/2
        anchors {
            top: solarpaneloff.top
            left:solar_transformer.left
            leftMargin: solar_transformer.width
            topMargin: solar_transformer.height
        }
        Rectangle{
            width: solar_info.width*1.1
            height: solar_info.height*1.1
            border.color: "black"
            radius :5
            color:"yellow"
            anchors {
                left: parent.right
            }
            GCText {
                id: solar_info
                fontSize: smallSize * 0.5
                anchors.centerIn: parent
                text: "0 W"
            }
        }
    }

    Image {
        id: solarpower
        source: activity.url + "solar/solarpoweroff.svg"
        sourceSize.width: parent.width
        anchors.fill: parent
        visible: true
    }

    Image {
        id: solarpaneloff
        source: activity.url + "solar/solarpaneloff.svg"
        sourceSize.width: parent.width*0.07
        height: parent.height*0.09
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height*0.31
            rightMargin: parent.width*0.14
        }
        visible: true
        MouseArea {
            id: solarpanelarea
            anchors.fill: solarpaneloff
            onClicked: {
                if( Activity.panel_activate == true ) {
                    solar_area.visible = true
                    solarpaneloff.source = activity.url + "solar/solarpanelon.svg"
                    panelpower.source = activity.url + "solar/panelpoweron.svg"
                    solarpanelarea.visible= false
                }
            }
        }
    }

    Image {
        id: panelpower
        source: activity.url + "solar/panelpoweroff.svg"
        sourceSize.width: parent.width
        anchors.fill: parent
        visible: true
    }
}
