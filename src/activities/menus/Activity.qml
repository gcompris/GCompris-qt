import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
//import "../../lib"
import "qrc:///lib"
import "activity.js" as Activity

Item {
    Component.onCompleted: Activity.start();
}
