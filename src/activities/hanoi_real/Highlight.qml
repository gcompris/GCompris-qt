import QtQuick 2.3
import QtGraphicalEffects 1.0

Colorize {
    anchors.fill: parent
    source: parent
    hue: 0.4
    saturation: 1
    lightness: .5
    cached: true
    opacity: 0

    property bool highlight: false
    onHighlightChanged: highlight ? opacity = 0.75 : opacity = 0

    Behavior on opacity { PropertyAnimation { duration: 150 } }
}
