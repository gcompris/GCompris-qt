/* GCompris
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (map update svg)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

QtObject {
    property string instruction: qsTr("Western Asia")
    property var levels: [
    {
        "pixmapfile": "asiawestern/western_asia.svgz",
        "type": "SHAPE_BACKGROUND_IMAGE"
    },
    {
        "pixmapfile": "asiawestern/turkey.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/turkey.$CA",
        "toolTipText": qsTr("Turkey"),
        "x": "0.2779",
        "y": "0.1567"
    },
    {
        "pixmapfile": "asiawestern/cyprus.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/cyprus.$CA",
        "toolTipText": qsTr("Cyprus"),
        "x": "0.2315",
        "y": "0.2767"
    },
    {
        "pixmapfile": "asiawestern/georgia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/georgia.$CA",
        //: Translators: Strip Asia| and translate only Georgia
        "toolTipText": qsTr("Asia|Georgia"),
        "x": "0.4847",
        "y": "0.0519"
    },
    {
        "pixmapfile": "asiawestern/azerbaijan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/azerbaijan.$CA",
        "toolTipText": qsTr("Azerbaijan"),
        "x": "0.5932",
        "y": "0.1199"
    },
    {
        "pixmapfile": "asiawestern/armenia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/armenia.$CA",
        "toolTipText": qsTr("Armenia"),
        "x": "0.5279",
        "y": "0.1218"
    },
    {
        "pixmapfile": "asiawestern/iran.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/iran.$CA",
        "toolTipText": qsTr("Iran"),
        "x": "0.7493",
        "y": "0.3604"
    },
    {
        "pixmapfile": "asiawestern/iraq.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/iraq.$CA",
        "toolTipText": qsTr("Iraq"),
        "x": "0.4932",
        "y": "0.3362"
    },
    {
        "pixmapfile": "asiawestern/syria.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/syria.$CA",
        "toolTipText": qsTr("Syria"),
        "x": "0.3756",
        "y": "0.2863"
    },
    {
        "pixmapfile": "asiawestern/jordan.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/jordan.$CA",
        "toolTipText": qsTr("Jordan"),
        "x": "0.326",
        "y": "0.3963"
    },
    {
        "pixmapfile": "asiawestern/israel.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/israel.$CA",
        "toolTipText": qsTr("Israel"),
        "x": "0.2737",
        "y": "0.3909"
    },
    {
        "pixmapfile": "asiawestern/palestine.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/palestine.$CA",
        "toolTipText": qsTr("Palestine"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.2688",
        "y": "0.3779"
    },
    {
        "pixmapfile": "asiawestern/lebanon.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/lebanon.$CA",
        "toolTipText": qsTr("Lebanon"),
        "x": "0.2934",
        "y": "0.3153"
    },
    {
        "pixmapfile": "asiawestern/saudi_arabia.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/saudi_arabia.$CA",
        "toolTipText": qsTr("Saudi Arabia"),
        "x": "0.5308",
        "y": "0.6161"
    },
    {
        "pixmapfile": "asiawestern/kuwait.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/kuwait.$CA",
        "toolTipText": qsTr("Kuwait"),
        "x": "0.5911",
        "y": "0.4574"
    },
    {
        "pixmapfile": "asiawestern/qatar.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/qatar.$CA",
        "toolTipText": qsTr("Qatar"),
        "x": "0.6857",
        "y": "0.5811"
    },
    {
        "pixmapfile": "asiawestern/united_arab_emirates.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/united_arab_emirates.$CA",
        "toolTipText": qsTr("United Arab Emirates"),
        "x": "0.7572",
        "y": "0.6132"
    },
    {
        "pixmapfile": "asiawestern/oman.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/oman.$CA",
        "toolTipText": qsTr("Oman"),
        "x": "0.8066",
        "y": "0.7014"
    },
    {
        "pixmapfile": "asiawestern/yemen.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/yemen.$CA",
        "toolTipText": qsTr("Yemen"),
        "x": "0.6178",
        "y": "0.8838"
    },
    {
        "pixmapfile": "asiawestern/egypt.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/egypt.$CA",
        "toolTipText": qsTr("Egypt"),
        "x": "0.164",
        "y": "0.5354"
    },
    {
        "pixmapfile": "asiawestern/bahrain.svgz",
        "soundFile": "voices-$CA/$LOCALE/geography/bahrain.$CA",
        "toolTipText": qsTr("Bahrain"),
        "type": "SHAPE_BACKGROUND",
        "x": "0.669",
        "y": "0.5571"
    }
    ]
}
