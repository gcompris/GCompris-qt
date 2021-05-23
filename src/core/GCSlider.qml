/* GCompris - GCSlider.qml
 *
 * SPDX-FileCopyrightText: 2018 Alexis Breton <alexis95150@gmail.com>
 *
 * Authors:
 *   Alexis Breton <alexis95150@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import QtQuick.Controls 1.5


/**
  * A Slider component with GCompris' style.
  * @ingroup components
  *
  * Provides the "scrollEnabled" property to replace "wheelEnabled"
  * that is only available with QtQuick.Controls > 1.6. If using
  * QtQuick.Controls >= 1.6, please use the built-in "wheelEnabled" property
  *
  * @inherit QtQuick.Controls.Slider
  */
Slider {

    /**
      * type:bool
      * Set to false to disable changing the value by scrolling the mouse.
      * Default is true.
      *
      * If false, the mouse scrolling is disabled while hovering the slider.
      *
      * Deprecated if using QtQuick.Controls >= 1.6
      */
    property bool scrollEnabled : true


    style: GCSliderStyle {}
    stepSize: 1.0
    tickmarksEnabled: true

    // Removes scrolling when hovering sliders if scrollEnabled = false
    MouseArea {
        anchors.fill: parent
        enabled: !scrollEnabled
        onWheel: {}
        onPressed: mouse.accepted = false
        onReleased: mouse.accepted = false
    }

}
