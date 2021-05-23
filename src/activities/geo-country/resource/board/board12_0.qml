/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
    property string instruction: qsTr("States of India")
    property var levels: [
        {
            "pixmapfile" : "india/background.png",
            "type" : "SHAPE_BACKGROUND_IMAGE"
        },
        {
            "pixmapfile" : "india/jammu_and_kashmir.png",
            //: State of India: Jammu and Kashmir
            "toolTipText" : qsTr("Jammu and Kashmir"),
            "x" : "0.313",
            "y" : "0.111"
        },
        {
            "pixmapfile" : "india/himachal_pradesh.png",
            //: State of India: Himachal Pradesh
            "toolTipText" : qsTr("Himachal Pradesh"),
            "x" : "0.337",
            "y" : "0.205"
        },
        {
            "pixmapfile" : "india/punjab.png",
            //: State of India: Punjab
            "toolTipText" : qsTr("Punjab"),
            "x" : "0.278",
            "y" : "0.228"
        },
        {
            "pixmapfile" : "india/harayana.png",
            //: State of India: Harayana
            "toolTipText" : qsTr("Harayana"),
            "x" : "0.296",
            "y" : "0.294"
        },
        {
            "pixmapfile" : "india/uttarakhand.png",
            //: State of India: Uttarakhand
            "toolTipText" : qsTr("Uttarakhand"),
            "x" : "0.403",
            "y" : "0.267"
        },
        {
            "pixmapfile" : "india/rajasthan.png",
            //: State of India: Rajasthan
            "toolTipText" : qsTr("Rajasthan"),
            "x" : "0.216",
            "y" : "0.377"
        },
        {
            "pixmapfile" : "india/uttar_pradesh.png",
            //: State of India: Uttar Pradesh
            "toolTipText" : qsTr("Uttar Pradesh"),
            "x" : "0.459",
            "y" : "0.36"
        },
        {
            "pixmapfile" : "india/bihar.png",
            //: State of India: Bihar
            "toolTipText" : qsTr("Bihar"),
            "x" : "0.623",
            "y" : "0.4"
        },
        {
            "pixmapfile" : "india/gujarat.png",
            //: State of India: Gujarat
            "toolTipText" : qsTr("Gujarat"),
            "x" : "0.124",
            "y" : "0.507"
        },
        {
            "pixmapfile" : "india/madhya_pradesh.png",
            //: State of India: Madhya Pradesh
            "toolTipText" : qsTr("Madhya Pradesh"),
            "x" : "0.375",
            "y" : "0.461"
        },
        {
            "pixmapfile" : "india/jharkhand.png",
            //: State of India: Jharkhand
            "toolTipText" : qsTr("Jharkhand"),
            "x" : "0.621",
            "y" : "0.471"
        },
        {
            "pixmapfile" : "india/maharashtra.png",
            //: State of India: Maharashtra
            "toolTipText" : qsTr("Maharashtra"),
            "x" : "0.314",
            "y" : "0.624"
        },
        {
            "pixmapfile" : "india/chhattisgarh.png",
            //: State of India: Chhattisgarh
            "toolTipText" : qsTr("Chhattisgarh"),
            "x" : "0.511",
            "y" : "0.559"
        },
        {
            "pixmapfile" : "india/orrisa.png",
            //: State of India: Orrisa
            "toolTipText" : qsTr("Orrisa"),
            "x" : "0.591",
            "y" : "0.584"
        },
        {
            "pixmapfile" : "india/goa.png",
            //: State of India: Goa
            "toolTipText" : qsTr("Goa"),
            "x" : "0.208",
            "y" : "0.733"
        },
        {
            "pixmapfile" : "india/karnataka.png",
            //: State of India: Karnataka
            "toolTipText" : qsTr("Karnataka"),
            "x" : "0.295",
            "y" : "0.748"
        },
        {
            "pixmapfile" : "india/telangana.png",
            //: State of India: Telangana
            "toolTipText" : qsTr("Telangana"),
            "x" : "0.405",
            "y" : "0.66"
        },

        {
            "pixmapfile" : "india/andhra_pradesh.png",
            //: State of India: Andhra Pradesh
            "toolTipText" : qsTr("Andhra Pradesh"),
            "x" : "0.454",
            "y" : "0.71"
        },
        {
            "pixmapfile" : "india/kerala.png",
            //: State of India: Kerala
            "toolTipText" : qsTr("Kerala"),
            "x" : "0.286",
            "y" : "0.885"
        },
        {
            "pixmapfile" : "india/tamil_nadu.png",
            //: State of India: Tamil Nadu
            "toolTipText" : qsTr("Tamil Nadu"),
            "x" : "0.371",
            "y" : "0.875"
        },
        {
            "pixmapfile" : "india/west_bengal.png",
            //: State of India: West Bengal
            "toolTipText" : qsTr("West Bengal"),
            "x" : "0.689",
            "y" : "0.445"
        },
        {
            "pixmapfile" : "india/sikkim.png",
            //: State of India: Sikkim
            "toolTipText" : qsTr("Sikkim"),
            "x" : "0.702",
            "y" : "0.344"
        },
        {
            "pixmapfile" : "india/assam.png",
            //: State of India: Assam
            "toolTipText" : qsTr("Assam"),
            "x" : "0.842",
            "y" : "0.37"
        },
        {
            "pixmapfile" : "india/arunachal_pradesh.png",
            //: State of India: Arunachal Pradesh
            "toolTipText" : qsTr("Arunachal Pradesh"),
            "x" : "0.891",
            "y" : "0.305"
        },
        {
            "pixmapfile" : "india/nagaland.png",
            //: State of India: Nagaland
            "toolTipText" : qsTr("Nagaland"),
            "x" : "0.891",
            "y" : "0.37"
        },
        {
            "pixmapfile" : "india/manipur.png",
            //: State of India: Manipur
            "toolTipText" : qsTr("Manipur"),
            "x" : "0.884",
            "y" : "0.416"
        },
        {
            "pixmapfile" : "india/mizoram.png",
            //: State of India: Mizoram
            "toolTipText" : qsTr("Mizoram"),
            "x" : "0.854",
            "y" : "0.473"
        },
        {
            "pixmapfile" : "india/tripura.png",
            //: State of India: Tripura
            "toolTipText" : qsTr("Tripura"),
            "x" : "0.819",
            "y" : "0.457"
        },
        {
            "pixmapfile" : "india/meghalaya.png",
            //: State of India: Meghalaya
            "toolTipText" : qsTr("Meghalaya"),
            "x" : "0.796",
            "y" : "0.395"
        },
        {
            "pixmapfile" : "india/lakshadweep_islands.png",
            //: State of India: Lakshadweep Islands
            "toolTipText" : qsTr("Lakshadweep Islands"),
            "x" : "0.153",
            "y" : "0.888"
        },
        {
            "pixmapfile" : "india/andaman_and_nicobar_islands.png",
            //: State of India: Andaman and Nicobar Islands
            "toolTipText" : qsTr("Andaman and Nicobar Islands"),
            "x" : "0.909",
            "y" : "0.876"
        },
        {
            "pixmapfile" : "india/delhi.png",
            //: State of India: Delhi
            "toolTipText" : qsTr("Delhi"),
            "x" : "0.336",
            "y" : "0.31"
        }
    ]
}
