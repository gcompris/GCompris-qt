import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

ComboBoxStyle {
    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 25
        border.width: control.activeFocus ? 4 : 2
        border.color: "black"
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0 ; color: control.pressed ? "#87ff5c" : "#ffe85c" }
            GradientStop { position: 1 ; color: control.pressed ? "#44ff00" : "#f8d600" }
        }
    }
}
