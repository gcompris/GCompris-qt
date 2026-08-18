import QtQuick
import QtQuick.Layouts

Item {
    id: bgRect

    property string fontColor: "black"
    property string fontFamily: "DejaVu Sans"
    property int fontPixelSize: 17
    property string wordText: ""
    property bool fontIsBold: false

    implicitWidth: txt.implicitWidth
    implicitHeight: txt.implicitHeight

    // Layout.preferredWidth: implicitWidth
    // Layout.preferredHeight: implicitHeight

    Text {
        id: txt
        text: bgRect.wordText
        font.pixelSize: bgRect.fontPixelSize
        font.family: bgRect.fontFamily
        font.bold: bgRect.fontIsBold
        color: bgRect.fontColor
    }
}

