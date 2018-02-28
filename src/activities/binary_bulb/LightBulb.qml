import QtQuick 2.6

Image {
	id: bulb
	anchors.verticalCenter: parent.verticalCenter
	width: 50
	height: 100
	source: "resource/bubl.svg"
	state: "off"

	property string t: ""

	MouseArea {
		anchors.fill: parent
		onClicked: {
			if(bulb.state == "off") {
				bulb.state = "on"
			}	
			else {
				bulb.state = "off"
			}
		}
	}	

	Text {
	    anchors.top: bulb.bottom
	    anchors.horizontalCenter: parent.horizontalCenter
	    text: t
	    color: "white"
	}

	states: [
		State {
			name: "off"
			PropertyChanges {
				target: bulb;
				source: "resource/bubl.svg"
				t: "0"
			}
		},
		State {
			name: "on"
			PropertyChanges {
				target: bulb;
				source: "resource/bulb_on.svg"
				t: "1"
			}
		}
	]
}