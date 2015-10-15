/* gcompris - DropAnswerItem.qml
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
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
import "solarsystem.js" as Activity

Rectangle {
    id: dropCircle
    
    property string dropCircleColor: "pink"
    property string positionType
    property string text
    property double posX
    property double posY
    property double imgHeight
    property double imgWidth
    property int dropAreaSize
    property string imageName
    property int area: dragTarget.width * dragTarget.height

    width: parent.width > parent.height ? parent.height/35 : parent.width/35
    height: width
    radius: width/2
    z: Math.round(10000000/area) / 100
    
    border.width: 1
    color: Activity.displayDropCircle ? dropCircleColor : "transparent"
    border.color: dropCircle.color == "#000000" ? "transparent" : "red"
    
    x: posX * parent.width - width/2
    y: posY * parent.height - height/2
    
    Image {
        id: dropAreaImage
        width: 0
        height : 0
        z: 0
        anchors.centerIn: dropCircle
        source: Activity.url + imageName
    }
    
    DropArea {
        id: dragTarget
        
        width: 3 * dropCircle.width
        height: 3 * dropCircle.width
        z: dropCircle.z
        anchors.centerIn: parent
        
        property double xCenter: dropCircle.x + dropCircle.width/2
        property double yCenter: dropCircle.y + dropCircle.height/2
        property QtObject dragSource 
        property string imgName: imageName
        
        states: [
            State {
                when: dragTarget.containsDrag && Activity.displayDropCircle
                PropertyChanges {
                    target: dropCircle
                    color: "lightgreen"
                }
            }
        ]
        onDropped: {
			if(dragSource === null) 
                dragSource = dragTarget.drag.source
            else if(dragSource != dragTarget.drag.source) {
                dragSource.imageRemove()
                dragSource = dragTarget.drag.source
            }
            dropCircle.dropCircleColor = "transparent"
        }
    }
    
    //Display a shadow of image, when the image is hovered over a drop area
    Image {
        id: targetImage
        width: 0
        height : 0
        fillMode: Image.PreserveAspectFit
        z: 4
        anchors.centerIn: dropCircle
        source: ""
        
        states: State {
                    when: dragTarget.containsDrag
                    PropertyChanges {
                        target: targetImage
                        source: dragTarget.drag.source.source
                        
                        width: imgWidth ? imgWidth * dropCircle.parent.width : (dropCircle.parent.source == "" ? 
							   dropCircle.parent.width * dragTarget.drag.source.sourceSize.width/dropCircle.parent.width : 
							   dropCircle.parent.width * dragTarget.drag.source.sourceSize.width/
							   dropCircle.parent.sourceSize.width)
							   
                        height: imgHeight ? imgHeight * dropCircle.parent.height : (dropCircle.parent.source == "" ? 
								dropCircle.parent.height * dragTarget.drag.source.sourceSize.height/dropCircle.parent.height : 
								dropCircle.parent.height * dragTarget.drag.source.sourceSize.height/
								dropCircle.parent.sourceSize.height)
								
                        opacity: 0.5
                    }
                }
    }
}
