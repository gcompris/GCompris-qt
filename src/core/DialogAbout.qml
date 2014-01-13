import QtQuick 2.1
import QtQuick.Controls 1.0

DialogBackground {
    visible: false
    title: "About GCompris"
    subtitle: "GCompris Home Page: http://gcompris.net"

    property string translators: "Bruno Coudoin <bruno.coudoin@free.fr>\n" +
    "Christophe Merlet <redfox@redfoxcenter.org>\n" +
    "Laurent Richard <laurent.richard@lilit.be>\n" +
    "Jonathan Ernst <jonathan@ernstfamily.ch>\n" +
    "Claude Paroz <claude@2xlibre.net>\n" +
    "Jean-Philippe Ayanidès <jp.ayanides@free.fr>\n" +
    "Mickael Albertus <mickael.albertus@gmail.com>"

    content: Item {
        TextArea {
            width: parent.width
            height: parent.height - footer.height
            text: "<center><b>" + "GCompris V13.11" + "</b></center>" + "<br/>" +
                  "<b>" + "Translators: " +"</b>" + translators
            font.pointSize: 16
            wrapMode: Text.WordWrap
            textFormat: TextEdit.RichText
            readOnly: true
            selectByMouse: false
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
