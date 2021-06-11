/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
    property string instruction: qsTr("States and Union Territories of India")
    property var levels: [
        {
            "pixmapfile" : "india/india.svgz",
            "type" : "SHAPE_BACKGROUND_IMAGE"
        },
        {
            "pixmapfile" : "india/himachal_pradesh.svgz",
            //: State of India: Himachal Pradesh
            "toolTipText" : qsTr("Himachal Pradesh"),
            "x" : "0.3133",
            "y" : "0.148"
        },
        {
            "pixmapfile" : "india/punjab.svgz",
            //: State of India: Punjab
            "toolTipText" : qsTr("Punjab"),
            "x" : "0.25",
            "y" : "0.1744"
        },
        {
            "pixmapfile" : "india/uttarakhand.svgz",
            //: State of India: Uttarakhand
            "toolTipText" : qsTr("Uttarakhand"),
            "x" : "0.3795",
            "y" : "0.2054"
        },
        {
            "pixmapfile" : "india/rajasthan.svgz",
            //: State of India: Rajasthan
            "toolTipText" : qsTr("Rajasthan"),
            "x" : "0.1992",
            "y" : "0.3203"
        },
        {
            "pixmapfile" : "india/uttar_pradesh.svgz",
            //: State of India: Uttar Pradesh
            "toolTipText" : qsTr("Uttar Pradesh"),
            "x" : "0.4313",
            "y" : "0.3036"
        },
        {
            "pixmapfile" : "india/bihar.svgz",
            //: State of India: Bihar
            "toolTipText" : qsTr("Bihar"),
            "x" : "0.5954",
            "y" : "0.3442"
        },
        {
            "pixmapfile" : "india/gujarat.svgz",
            //: State of India: Gujarat
            "toolTipText" : qsTr("Gujarat"),
            "x" : "0.1194",
            "y" : "0.4601"
        },
        {
            "pixmapfile" : "india/haryana.svgz",
            //: State of India: Haryana
            "toolTipText" : qsTr("Haryana"),
            "x" : "0.2708",
            "y" : "0.2317"
        },
        {
            "pixmapfile" : "india/madhya_pradesh.svgz",
            //: State of India: Madhya Pradesh
            "toolTipText" : qsTr("Madhya Pradesh"),
            "x" : "0.3501",
            "y" : "0.4085"
        },
        {
            "pixmapfile" : "india/jharkhand.svgz",
            //: State of India: Jharkhand
            "toolTipText" : qsTr("Jharkhand"),
            "x" : "0.5903",
            "y" : "0.4189"
        },
        {
            "pixmapfile" : "india/maharashtra.svgz",
            //: State of India: Maharashtra
            "toolTipText" : qsTr("Maharashtra"),
            "x" : "0.2956",
            "y" : "0.5794"
        },
        {
            "pixmapfile" : "india/chhattisgarh.svgz",
            //: State of India: Chhattisgarh
            "toolTipText" : qsTr("Chhattisgarh"),
            "x" : "0.4795",
            "y" : "0.509"
        },
        {
            "pixmapfile" : "india/goa.svgz",
            //: State of India: Goa
            "toolTipText" : qsTr("Goa"),
            "x" : "0.2033",
            "y" : "0.6951"
        },
        {
            "pixmapfile" : "india/karnataka.svgz",
            //: State of India: Karnataka
            "toolTipText" : qsTr("Karnataka"),
            "x" : "0.2807",
            "y" : "0.7056"
        },
        {
            "pixmapfile" : "india/telangana.svgz",
            //: State of India: Telangana
            "toolTipText" : qsTr("Telangana"),
            "x" : "0.3788",
            "y" : "0.611"
        },

        {
            "pixmapfile" : "india/andhra_pradesh.svgz",
            //: State of India: Andhra Pradesh
            "toolTipText" : qsTr("Andhra Pradesh"),
            "x" : "0.4275",
            "y" : "0.6766"
        },
        {
            "pixmapfile" : "india/kerala.svgz",
            //: State of India: Kerala
            "toolTipText" : qsTr("Kerala"),
            "x" : "0.2743",
            "y" : "0.8542"
        },
        {
            "pixmapfile" : "india/tamil_nadu.svgz",
            //: State of India: Tamil Nadu
            "toolTipText" : qsTr("Tamil Nadu"),
            "x" : "0.3456",
            "y" : "0.8455"
        },
        {
            "pixmapfile" : "india/west_bengal.svgz",
            //: State of India: West Bengal
            "toolTipText" : qsTr("West Bengal"),
            "x" : "0.6629",
            "y" : "0.3949"
        },
        {
            "pixmapfile" : "india/sikkim.svgz",
            //: State of India: Sikkim
            "toolTipText" : qsTr("Sikkim"),
            "x" : "0.6833",
            "y" : "0.2882"
        },
        {
            "pixmapfile" : "india/assam.svgz",
            //: State of India: Assam
            "toolTipText" : qsTr("Assam"),
            "x" : "0.829",
            "y" : "0.3392"
        },
        {
            "pixmapfile" : "india/arunachal_pradesh.svgz",
            //: State of India: Arunachal Pradesh
            "toolTipText" : qsTr("Arunachal Pradesh"),
            "x" : "0.8828",
            "y" : "0.2743"
        },
        {
            "pixmapfile" : "india/nagaland.svgz",
            //: State of India: Nagaland
            "toolTipText" : qsTr("Nagaland"),
            "x" : "0.8767",
            "y" : "0.3372"
        },
        {
            "pixmapfile" : "india/odisha.svgz",
            //: State of India: Odisha
            "toolTipText" : qsTr("Odisha"),
            "x" : "0.5496",
            "y" : "0.5342"
        },
        {
            "pixmapfile" : "india/manipur.svgz",
            //: State of India: Manipur
            "toolTipText" : qsTr("Manipur"),
            "x" : "0.8627",
            "y" : "0.382"
        },
        {
            "pixmapfile" : "india/mizoram.svgz",
            //: State of India: Mizoram
            "toolTipText" : qsTr("Mizoram"),
            "x" : "0.829",
            "y" : "0.4328"
        },
        {
            "pixmapfile" : "india/tripura.svgz",
            //: State of India: Tripura
            "toolTipText" : qsTr("Tripura"),
            "x" : "0.7923",
            "y" : "0.4161"
        },
        {
            "pixmapfile" : "india/meghalaya.svgz",
            //: State of India: Meghalaya
            "toolTipText" : qsTr("Meghalaya"),
            "x" : "0.7776",
            "y" : "0.3554"
        },
        {
            "pixmapfile" : "india/andaman_and_nicobar_islands.svgz",
            //: Union Territory of India: Andaman and Nicobar Islands
            "toolTipText" : qsTr("Andaman and Nicobar Islands"),
            "x" : "0.8419",
            "y" : "0.8669"
        },
        {
            "pixmapfile" : "india/delhi.svgz",
            //: Union Territory of India: Delhi
            "toolTipText" : qsTr("Delhi"),
            "x" : "0.3059",
            "y" : "0.2536"
        },
        {
            "pixmapfile" : "india/chandigarh.svgz",
            //: Union Territory of India: Chandigarh
            "toolTipText" : qsTr("Chandigarh"),
            "type": "SHAPE_BACKGROUND",
            "x" : "0.2955",
            "y" : "0.1843"
        },
        {
            "pixmapfile" : "india/dadra_nagar_haveli_daman_diu.svgz",
            //: Union Territory of India: Dadra and Nagar Haveli and Daman and Diu
            "toolTipText" : qsTr("Dadra and Nagar Haveli and Daman and Diu"),
            "type": "SHAPE_BACKGROUND",
            "x" : "0.1381",
            "y" : "0.5271"
        },
        {
            "pixmapfile" : "india/ladakh.svgz",
            //: Union Territory of India: Ladakh
            "toolTipText" : qsTr("Ladakh"),
            "x" : "0.3159",
            "y" : "0.0754"
        },
        {
            "pixmapfile" : "india/lakshadweep.svgz",
            //: Union Territory of India: Lakshadweep
            "toolTipText" : qsTr("Lakshadweep"),
            "x" : "0.1634",
            "y" : "0.8613"
        },
        {
            "pixmapfile" : "india/jammu_and_kashmir.svgz",
            //: Union Territory of India: Jammu and Kashmir
            "toolTipText" : qsTr("Jammu and Kashmir"),
            "x" : "0.2453",
            "y" : "0.0912"
        },
        {
            "pixmapfile" : "india/puducherry.svgz",
            //: Union Territory of India: Puducherry
            "toolTipText" : qsTr("Puducherry"),
            "type": "SHAPE_BACKGROUND",
            "x" : "0.3666",
            "y" : "0.7464"
        }
    ]
}
