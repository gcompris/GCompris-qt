<<<<<<< HEAD
/* GCompris - shapes.qml
*
* Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
*
* Authors:
*   Divyam Madaan <divyam3897@gmail.com> (Qt Quick port)
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

import "../../core"
import "shapes.js" as Activity
import"."

ActivityBase {
    id: activity
    
    property string dataSetUrl: "qrc:/gcompris/src/activities/shapes/resource/"
    onStart: focus = true
    onStop: {}
    
    pageComponent: Image {
        id: background
        source: activity.dataSetUrl+"shapes.jpg"
        anchors.fill: parent
        sourceSize.width:parent.width
        signal start
        signal stop
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        
        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }
        
        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
        
        
        
        Rectangle{
            id:leftscreen
            width:background.width/3
            height: background.height
            color:"red"
            opacity: 0.4
        }
        
        Rectangle{
            id:middlescreen
            anchors.left: leftscreen.right
            width:background.width/3
            height:background.width
            color:"white"
            opacity: 0.4
            
        }
        Rectangle{
            id:rightscreen
            anchors.left: middlescreen.right
            width:background.width/3
            height:background.width
            color:"green"
            opacity: 0.4
        }
        Image{
            id:semi
            anchors.left:leftscreen.right
            anchors.right:rightscreen.left
            anchors.leftMargin:200
            width:120
            height:120
            source:"resource/semicircle.png"
            opacity:1
        }
        GCText{
            id:information
            anchors.right:semi.left
            anchors.left:leftscreen.right
            text:"SEMICIRCLE
   Half of circle"
        }
        DropArea{
            anchors.fill:rightscreen && leftscreen
        }
        Grid{
            anchors.left:leftscreen.right
            anchors.right:rightscreen.left
            y:150
            id:options
            rows:3
            columns:3
            spacing:8
            
            Image{ id:clock1
                source:"resource/clock.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active=1
                 y: Drag.active=1
                 x: Drag.active=1
                
                MouseArea {
                    id: dragArea
                    anchors.fill:parent
                    drag.target: parent
                }
            }
            Image{ source:"resource/protractor.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active1=1
                 y: Drag.active1=1
                 x: Drag.active1=1
                MouseArea {
                    id: dragArea1
                    anchors.fill:parent
                    drag.target: parent
                }
            }
            Image{ source:"resource/rainbow.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active2=1
                 y: Drag.active2=1
                 x: Drag.active2=1
                MouseArea {
                    id: dragArea2
                    anchors.fill:parent
                    drag.target: parent
                }
            }
            Image{ source:"resource/watermelon.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active3=1
                 y: Drag.active3=1
                MouseArea {
                    id: dragArea3
                    anchors.fill:parent
                    drag.target: parent
                }
            }
            Image{ source:"resource/scale.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active4=1
                 y: Drag.active4=1
                MouseArea {
                    id: dragArea4
                    anchors.fill:parent
                    drag.target: parent
                }
            }
            
            Image{ source:"resource/triangle.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active5=1
                 y: Drag.active5=1
                MouseArea {
                    id: dragArea5
                    anchors.fill:parent
                    drag.target: parent
                }
            }
            Image{ source:"resource/case.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active6=1
                 y: Drag.active6=1
                MouseArea {
                    id: dragArea6
                    anchors.fill:parent
                    drag.target: parent
                }
            }
            Image{ source:"resource/biscuit.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active7=1
                y: Drag.active7=1
               MouseArea {
                    id: dragArea7
                    anchors.fill:parent
                    drag.target: parent
                }
            }
            Image{ source:"resource/fan.jpg"
                width:145;height:150
                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: 150
                Drag.hotSpot.y: 150
                z: Drag.active8=1
                y: Drag.active8=1
                MouseArea {
                    id: dragArea8
                    anchors.fill:parent
                    drag.target: parent
                }
            }
        }
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
        
        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }
        
        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
    
}
=======
		  /* GCompris - shapes.qml
		  *
		  * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
		  *
		  * Authors:
		  *   Divyam Madaan <divyam3897@gmail.com> (Qt Quick port)
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

		  import "../../core"
		  import "shapes.js" as Activity
		  import"."

		  ActivityBase {
		      id: activity

		    property string dataSetUrl: "qrc:/gcompris/src/activities/shapes/resources/"
		    onStart: focus = true
		      onStop: {}

		      pageComponent: Image {
			  id: background
			  source: activity.dataSetUrl+"shapes.jpg"
			  anchors.fill: parent
			  sourceSize.width:parent.width
			  signal start
			  signal stop

			  Component.onCompleted: {
			      activity.start.connect(start)
			      activity.stop.connect(stop)
			  }

			  // Add here the QML items you need to access in javascript
			  QtObject {
			      id: items
			      property Item main: activity.main
			      property alias background: background
			      property alias bar: bar
			      property alias bonus: bonus
			  }

			  onStart: { Activity.start(items) }
			  onStop: { Activity.stop() }
		  
	      
	      
		Flipable {
		id: flipable
		width:background.width
		height:background.height
		property bool flipped:false

		front:Image{
	    id:cardfront
	    source:"resources/back.png"
	    width:200
	    height:240
	    x:background.width*0.45
	    y:background.height*0.05
    GCText{
	    x:cardfront.width*0.1
	    y:cardfront.height*0.75
	    color:"#ffffff"
	    text:"semicircle"
	    font.bold:true
	    fontSize:mediumSize
	    
	  }
	    
	  }
	  back:Image{
	    id:cardback
	    width:200
	    height:240
	    source:"resources/emptycard.png"
	    x:background.width*0.45
	    y:background.height*0.05
	    Image{
	      y:cardback.height*0.3
	      source:"resources/semicircle.png"
	      width:200
	      height:100
	    }
	  }
	    transform: Rotation {
		id: rotation
		origin.x: background.width*0.45
		origin.y: background.height*0.05
		axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
		angle: 0 // the default angle
	    }
		  states:State{
		    name:"back"
		  
		    PropertyChanges{ target:rotation;angle:180
	    
		    }
		    when:flipable.flipped
		}
		  
	  transitions: Transition {
		NumberAnimation { target: rotation; property: "angle"; duration: 750 }
	    }
		MouseArea {
		id:myMouse
		  anchors.fill: cardback && cardfront
		onClicked: flipable.flipped = !flipable.flipped
	    }}
	    Grid{
	      columns:4
	      spacing:15
	      x:120
	      y:background.height*0.5
	      Image{
		width:250
		height:250
		source:"resources/clock.jpg"
	      }
	      Image{
		width:250
		height:250
		source:"resources/stick.jpg"
	      }
	      Image{
		width:250
		height:250
		source:"resources/triangle.jpg"
	      }
	      Image{
		width:250
		height:250
		source:"resources/rainbow.jpg"
	      }
	    }
		
		DialogHelp {
			      id: dialogHelp
			      onClose: home()
			  }

			  Bar {
			      id: bar
			      content: BarEnumContent { value: help | home | level }
			      onHelpClicked: {
				  displayDialog(dialogHelp)
			      }
			      onPreviousLevelClicked: Activity.previousLevel()
			      onNextLevelClicked: Activity.nextLevel()
			      onHomeClicked: activity.home()
			  }

			  Bonus {
			      id: bonus
			      Component.onCompleted: win.connect(Activity.nextLevel)
			  }
		      }

		  }
		  
>>>>>>> 93b78399df286161810c7b82ab12c77c414d1002
