import QtQuick 2.1
import QtQuick.Controls 1.0
import "core.js" as Core

DialogBackground {
    title: "About GCompris"
    subtitle: "GCompris Home Page: http://gcompris.net"
    visible: false

    property string translators: "Bruno Coudoin <bruno.coudoin@free.fr>\n" +
    "Christophe Merlet <redfox@redfoxcenter.org>\n" +
    "Laurent Richard <laurent.richard@lilit.be>\n" +
    "Jonathan Ernst <jonathan@ernstfamily.ch>\n" +
    "Claude Paroz <claude@2xlibre.net>\n" +
    "Jean-Philippe Ayanidès <jp.ayanides@free.fr>\n" +
    "Mickael Albertus <mickael.albertus@gmail.com>"

    Image {
        id: logo
        source: "qrc:/gcompris/src/core/resource/gcompris.png";
        width: 70
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        visible: parent.width > 700
        smooth: true
        SequentialAnimation {
              id: anim
              running: true
              loops: Animation.Infinite
              NumberAnimation {
                  target: logo
                  property: "rotation"
                  from: -10; to: 10
                  duration: 500
                  easing.type: Easing.InOutQuad
              }
              NumberAnimation {
                  target: logo
                  property: "rotation"
                  from: 10; to: -10
                  duration: 500
                  easing.type: Easing.InOutQuad }
          }
    }

    content: Item {
        TextArea {
            width: parent.width
            height: parent.height - footer.height
            text: "<center><b>" + "GCompris V13.11" + "</b></center>" + "<br/>" + "<b>" + "Translators: " +"</b>" + translators
            font.pointSize: 12
            wrapMode: Text.WordWrap
            textFormat: TextEdit.RichText
            readOnly: true
            selectByMouse: false
            MouseArea {
                anchors.fill: parent
                onClicked: Core.pagePop()
            }
        }
        Column {
            id: footer
            anchors.bottom: parent.bottom
            width: parent.width
            Text {
                text: "Copyright 2000-2013 Bruno Coudoin and Others"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                font.pointSize: 14
            }
            Text {
                text: "This software is a GNU Package and is released under the GNU General Public License"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                fontSizeMode: Text.Fit
                minimumPointSize: 7
                font.pointSize: 14
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
            }
        }
    }
}
