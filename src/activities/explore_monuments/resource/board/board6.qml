/* GCompris
 *
 * Copyright (C) 2016 Ayush Agrawal <ayushagrawal288@gmail.com>
 *
 * Authors:
 *   Ayush Agrawal <ayushagrawal288@gmail.com> (Qt Quick port)
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

QtObject {
    property string backgroundImage: "qrc:/gcompris/src/activities/explore_monuments/resource/egypt/egyptbg.jpg"
    property var tab : [
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Great Pyramid of Giza"),
            "text": qsTr("The Great Pyramid of Giza is also known as the Pyramid of Khufu or the Pyramid of Cheops. It is considered to be the oldest of all the Seven Wonders of the Ancient World. It is also the largest of all the three pyramids in the Giza. It is situated in Giza Necropolis of Egypt. The initial construction has been started by Egyptian Pharaoh Khufu then it was continued by his son Khafre and finally completed by Menkaure. It took almost 20 years to build the pyramid and approximately 2 million blocks of stone has been used in the construction. The height of the pyramid is approximately 139 meters making it the highest pyramid of Egypt."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/egypt/greatPyramidOfGiza.jpg",
            "text2" : qsTr("Great Pyramid of Giza"),
            "x": "0.627",
            "y": "0.141",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Bent Pyramid"),
            "text": qsTr("The Bent Pyramid located at Dahshur was the second pyramid built by pharaoh Sneferu. Mysteriously, this true pyramid rises from the desert at an angle of 55 degrees and then suddenly changes to a more gradual angle of 43 degrees. One theory holds that due to the steepness of the original angle the weight to be added above the inner chambers and passageways became too large, forcing the builders to adopt a shallower angle. Today, the Bent Pyramid is the only pyramid in Egypt of which the outer casing of polished limestone is still largely intact."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/egypt/bentPyramid.jpg",
            "text2" : qsTr("Bent Pyramid"),
            "x": "0.596",
            "y": "0.200",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Pyramid of Meidum"),
            "text": qsTr("Five miles south of Saqqara in Egypt stands the mysterious tower-like pyramid of Meidum, which today scarcely resembles a typical pyramid at all. The pyramid was probably built during the reign of the 4th Dynasty pharaoh Sneferu, although it is believed by some that the pyramid may have been started by Sneferu’s predecessor, Huni. At some point during its construction the steps of the pyramid were filled with limestone encasing marking the first attempt by the ancient Egyptians at the construction of a true pyramid."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/egypt/meidumPyramid.jpg",
            "text2" : qsTr("Pyramid of Meidum"),
            "x": "0.609",
            "y": "0.260",
            "height": "0.07",
            "width": "0.07"
        },
        {
            "image": "qrc:/gcompris/src/activities/explore_monuments/resource/wonders/key.png",
            "title": qsTr("Red Pyramid"),
            "text": qsTr("Red Pyramid was one of the finest and successful attempts by Pharaoh Sneferu in building world’s first ever smooth sided pyramid during the Ancient Egypt period. The height of the pyramid is 104 meters making it the world’s 4th largest pyramid in Egypt. The pyramid has been built with red limestone stones and hence the name. The local people of Egypt called it as el-heram el-watwaat meaning the Bat Pyramid."),
            "image2": "qrc:/gcompris/src/activities/explore_monuments/resource/egypt/redPyramid.jpg",
            "text2" : qsTr("Red Pyramid"),
            "x": "0.535",
            "y": "0.240",
            "height": "0.07",
            "width": "0.07"
        }
    ]

    property var instructions : [
        {
            "text": qsTr("Egyptian pyramids")
        },
        {
            "text": qsTr("Click on location where the given pyramid is located.")
        }
    ]
}
