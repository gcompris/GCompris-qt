// import QtQuick 2.12

// import "markup-exercice-engine.js" as Activity

// Flow {
//     // anchors.left: parent.left
//     // anchors.right: parent.right
//     // anchors.leftMargin: Activity.flowLeftPadding
//     // anchors.rightMargin: Activity.flowRightPadding
//     // anchors.horizontalCenter: parent.horizontalCenter

//     anchors.horizontalCenter: parent.horizontalCenter
//     width: parent.width * 0.8  // ou la largeur souhaitée

// }

// import QtQuick
// import QtQuick.Layouts

import QtQuick
import QtQuick.Layouts

FlexboxLayout {
    id: root

    // Configuration Flexbox
    direction: FlexboxLayout.Row
    wrap: FlexboxLayout.Wrap
    justifyContent: FlexboxLayout.JustifyStart
    alignItems: FlexboxLayout.AlignStart
    alignContent: FlexboxLayout.AlignStart

    // Espacements
    columnGap: 6
    rowGap: 8

    // Propriétés de padding utilisées par markup-exercice-engine.js
    property real leftPadding: 0
    property real rightPadding: 0
    property real topPadding: 0
    property real bottomPadding: 0

    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined
    width: parent ? parent.width * 0.8 : 0
    height: implicitHeight

    function alignEnd() {
        justifyContent = FlexboxLayout.JustifyEnd
    }
}
