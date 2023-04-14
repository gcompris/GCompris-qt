/* GCompris - GCDialogCheckBox.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import GCompris 1.0

/**
 * GCompris' CheckBox component.
 * @ingroup components
 *
 * @inherit QtQuick.Controls2.CheckBox
 */
CheckBox {
    id: checkBox
    width: parent.width

    /**
    * type:int
    * Font size of the label text.
    * By default it is set to 16 i.e. GCText.mediumSize
    *
    */
    property int labelTextFontSize: 16
    /**
    * type:int
    * Height of the indicator image.
    */
    property int indicatorImageHeight: 50 * ApplicationInfo.ratio

    focusPolicy: Qt.NoFocus

    indicator: Image {
        sourceSize.height: checkBox.indicatorImageHeight
        property string suffix: checkBox.enabled ? ".svg" : "_disabled.svg"
        source:
        checkBox.checked ? "qrc:/gcompris/src/core/resource/apply" + suffix :
        "qrc:/gcompris/src/core/resource/cancel" + suffix
    }
    contentItem: GCText {
        anchors.left: indicator.right
        anchors.leftMargin: 10
        anchors.right: checkBox.right
        fontSize: labelTextFontSize
        text: checkBox.text
        wrapMode: Text.WordWrap
    }
}
