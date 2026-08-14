import QtQuick 2.12
import QtQuick.Controls


Item {
    id: enumerationMarker

    property int fontPixelSize: 17
    property string wordText: ""
    property string fontColor: "darkmagenta"
    property string fontFamily: "DejaVu Sans"

    Text {
        text: enumerationMarker.wordText
        color: enumerationMarker.fontColor
        font.bold: true
        font.pointSize: enumerationMarker.fontPixelSize
        font.family: enumerationMarker.fontFamily
    }

}
