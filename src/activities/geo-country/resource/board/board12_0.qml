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
import QtQuick 2.12

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
            "x" : "0.3407",
            "y" : "0.1515"
        },
        {
            "pixmapfile" : "india/punjab.svgz",
            //: State of India: Punjab
            "toolTipText" : qsTr("Punjab"),
            "x" : "0.2837",
            "y" : "0.1777"
        },
        {
            "pixmapfile" : "india/uttarakhand.svgz",
            //: State of India: Uttarakhand
            "toolTipText" : qsTr("Uttarakhand"),
            "x" : "0.3984",
            "y" : "0.211"
        },
        {
            "pixmapfile" : "india/rajasthan.svgz",
            //: State of India: Rajasthan
            "toolTipText" : qsTr("Rajasthan"),
            "x" : "0.2336",
            "y" : "0.3241"
        },
        {
            "pixmapfile" : "india/uttar_pradesh.svgz",
            //: State of India: Uttar Pradesh
            "toolTipText" : qsTr("Uttar Pradesh"),
            "x" : "0.4462",
            "y" : "0.31"
        },
        {
            "pixmapfile" : "india/bihar.svgz",
            //: State of India: Bihar
            "toolTipText" : qsTr("Bihar"),
            "x" : "0.5955",
            "y" : "0.3498"
        },
        {
            "pixmapfile" : "india/gujarat.svgz",
            //: State of India: Gujarat
            "toolTipText" : qsTr("Gujarat"),
            "x" : "0.1545",
            "y" : "0.4633"
        },
        {
            "pixmapfile" : "india/haryana.svgz",
            //: State of India: Haryana
            "toolTipText" : qsTr("Haryana"),
            "x" : "0.3016",
            "y" : "0.2372"
        },
        {
            "pixmapfile" : "india/madhya_pradesh.svgz",
            //: State of India: Madhya Pradesh
            "toolTipText" : qsTr("Madhya Pradesh"),
            "x" : "0.3692",
            "y" : "0.4166"
        },
        {
            "pixmapfile" : "india/jharkhand.svgz",
            //: State of India: Jharkhand
            "toolTipText" : qsTr("Jharkhand"),
            "x" : "0.5923",
            "y" : "0.4232"
        },
        {
            "pixmapfile" : "india/maharashtra.svgz",
            //: State of India: Maharashtra
            "toolTipText" : qsTr("Maharashtra"),
            "x" : "0.3162",
            "y" : "0.5875"
        },
        {
            "pixmapfile" : "india/chhattisgarh.svgz",
            //: State of India: Chhattisgarh
            "toolTipText" : qsTr("Chhattisgarh"),
            "x" : "0.491",
            "y" : "0.5182"
        },
        {
            "pixmapfile" : "india/goa.svgz",
            //: State of India: Goa
            "toolTipText" : qsTr("Goa"),
            "x" : "0.2215",
            "y" : "0.7038"
        },
        {
            "pixmapfile" : "india/karnataka.svgz",
            //: State of India: Karnataka
            "toolTipText" : qsTr("Karnataka"),
            "x" : "0.2975",
            "y" : "0.7182"
        },
        {
            "pixmapfile" : "india/telangana.svgz",
            //: State of India: Telangana
            "toolTipText" : qsTr("Telangana"),
            "x" : "0.3945",
            "y" : "0.6224"
        },

        {
            "pixmapfile" : "india/andhra_pradesh.svgz",
            //: State of India: Andhra Pradesh
            "toolTipText" : qsTr("Andhra Pradesh"),
            "x" : "0.4411",
            "y" : "0.6889"
        },
        {
            "pixmapfile" : "india/kerala.svgz",
            //: State of India: Kerala
            "toolTipText" : qsTr("Kerala"),
            "x" : "0.2881",
            "y" : "0.8705"
        },
        {
            "pixmapfile" : "india/tamil_nadu.svgz",
            //: State of India: Tamil Nadu
            "toolTipText" : qsTr("Tamil Nadu"),
            "x" : "0.3608",
            "y" : "0.8632"
        },
        {
            "pixmapfile" : "india/west_bengal.svgz",
            //: State of India: West Bengal
            "toolTipText" : qsTr("West Bengal"),
            "x" : "0.6584",
            "y" : "0.3961"
        },
        {
            "pixmapfile" : "india/sikkim.svgz",
            //: State of India: Sikkim
            "toolTipText" : qsTr("Sikkim"),
            "x" : "0.6738",
            "y" : "0.2875"
        },
        {
            "pixmapfile" : "india/assam.svgz",
            //: State of India: Assam
            "toolTipText" : qsTr("Assam"),
            "x" : "0.8059",
            "y" : "0.3251"
        },
        {
            "pixmapfile" : "india/arunachal_pradesh.svgz",
            //: State of India: Arunachal Pradesh
            "toolTipText" : qsTr("Arunachal Pradesh"),
            "x" : "0.8514",
            "y" : "0.2559"
        },
        {
            "pixmapfile" : "india/nagaland.svgz",
            //: State of India: Nagaland
            "toolTipText" : qsTr("Nagaland"),
            "x" : "0.8518",
            "y" : "0.3227"
        },
        {
            "pixmapfile" : "india/odisha.svgz",
            //: State of India: Odisha
            "toolTipText" : qsTr("Odisha"),
            "x" : "0.5585",
            "y" : "0.5425"
        },
        {
            "pixmapfile" : "india/manipur.svgz",
            //: State of India: Manipur
            "toolTipText" : qsTr("Manipur"),
            "x" : "0.8439",
            "y" : "0.3682"
        },
        {
            "pixmapfile" : "india/mizoram.svgz",
            //: State of India: Mizoram
            "toolTipText" : qsTr("Mizoram"),
            "x" : "0.8154",
            "y" : "0.4242"
        },
        {
            "pixmapfile" : "india/tripura.svgz",
            //: State of India: Tripura
            "toolTipText" : qsTr("Tripura"),
            "x" : "0.781",
            "y" : "0.4098"
        },
        {
            "pixmapfile" : "india/meghalaya.svgz",
            //: State of India: Meghalaya
            "toolTipText" : qsTr("Meghalaya"),
            "x" : "0.7636",
            "y" : "0.3479"
        },
        {
            "pixmapfile" : "india/andaman_and_nicobar_islands.svgz",
            //: Union Territory of India: Andaman and Nicobar Islands
            "toolTipText" : qsTr("Andaman and Nicobar Islands"),
            "x" : "0.868",
            "y" : "0.8636"
        },
        {
            "pixmapfile" : "india/delhi.svgz",
            //: Union Territory of India: Delhi
            "toolTipText" : qsTr("Delhi"),
            "x" : "0.332",
            "y" : "0.2597"
        },
        {
            "pixmapfile" : "india/chandigarh.svgz",
            //: Union Territory of India: Chandigarh
            "toolTipText" : qsTr("Chandigarh"),
            "type": "SHAPE_BACKGROUND",
            "x" : "0.3244",
            "y" : "0.1886"
        },
        {
            "pixmapfile" : "india/dadra_nagar_haveli_daman_diu.svgz",
            //: Union Territory of India: Dadra and Nagar Haveli and Daman and Diu
            "toolTipText" : qsTr("Dadra and Nagar Haveli and Daman and Diu"),
            "type": "SHAPE_BACKGROUND",
            "x" : "0.1664",
            "y" : "0.5304"
        },
        {
            "pixmapfile" : "india/ladakh.svgz",
            //: Union Territory of India: Ladakh
            "toolTipText" : qsTr("Ladakh"),
            "x" : "0.3444",
            "y" : "0.0773"
        },
        {
            "pixmapfile" : "india/lakshadweep.svgz",
            //: Union Territory of India: Lakshadweep
            "toolTipText" : qsTr("Lakshadweep"),
            "x" : "0.1353",
            "y" : "0.8729"
        },
        {
            "pixmapfile" : "india/jammu_and_kashmir.svgz",
            //: Union Territory of India: Jammu and Kashmir
            "toolTipText" : qsTr("Jammu and Kashmir"),
            "x" : "0.2838",
            "y" : "0.0911"
        },
        {
            "pixmapfile" : "india/puducherry.svgz",
            //: Union Territory of India: Puducherry
            "toolTipText" : qsTr("Puducherry"),
            "type": "SHAPE_BACKGROUND",
            "x" : "0.3807",
            "y" : "0.7613"
        }
    ]
}
