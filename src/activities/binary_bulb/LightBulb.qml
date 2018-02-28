import QtQuick 2.6
import "../../core"

Image {
	id: bulb
	anchors.verticalCenter: parent.verticalCenter
	width: 50
	height: 100
	source: "resource/bubl.svg"
	state: "off"

	property string bit: ""

	GCText {
	    anchors.bottom: parent.top
	    anchors.horizontalCenter: parent.horizontalCenter
	    text: bulb.value
	    color: "white"
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			if(bulb.state == "off") {
				bulb.state = "on"
				sum += bulb.value
			}	
			else {
				bulb.state = "off"
				sum -= bulb.value
			}
		}
	}	

	GCText {
	    anchors.top: bulb.bottom
	    anchors.horizontalCenter: parent.horizontalCenter
	    text: bit
	    color: "white"
	}

	states: [
		State {
			name: "off"
			PropertyChanges {
				target: bulb;
				source: "resource/bubl.svg"
				bit: "0"
			}
		},
		State {
			name: "on"
			PropertyChanges {
				target: bulb;
				source: "resource/bulb_on.svg"
				bit: "1"
			}
		}
	]
}