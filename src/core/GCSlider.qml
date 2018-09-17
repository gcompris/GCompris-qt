/* GCompris - GCSlider.qml
 *
 * Copyright (C) 2018 Alexis Breton <alexis95150@gmail.com>
 *
 * Authors:
 *   Alexis Breton <alexis95150@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
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
