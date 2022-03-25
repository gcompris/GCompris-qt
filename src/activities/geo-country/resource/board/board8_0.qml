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
   property string instruction: qsTr("Provinces and territories of Canada")
   property var levels: [
      {
         "pixmapfile" : "canada/canada.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "canada/yukon.svgz",
         //: Provinces and territories of Canada: Yukon
         "toolTipText" : qsTr("Yukon"),
         "x" : "0.1024",
         "y" : "0.3652"
      },
      {
         "pixmapfile" : "canada/british_columbia.svgz",
         //: Provinces and territories of Canada: British Columbia
         "toolTipText" : qsTr("British Columbia"),
         "x" : "0.1117",
         "y" : "0.5944"
      },
      {
         "pixmapfile" : "canada/northwest_territories.svgz",
         //: Provinces and territories of Canada: Northwest Territories
         "toolTipText" : qsTr("Northwest Territories"),
         "x" : "0.2626",
         "y" : "0.3526"
      },
      {
         "pixmapfile" : "canada/nunavut.svgz",
         //: Provinces and territories of Canada: Nunavut
         "toolTipText" : qsTr("Nunavut"),
         "x" : "0.4902",
         "y" : "0.3708"
      },
      {
         "pixmapfile" : "canada/alberta.svgz",
         //: Provinces and territories of Canada: Alberta
         "toolTipText" : qsTr("Alberta"),
         "x" : "0.2256",
         "y" : "0.658"
      },
      {
         "pixmapfile" : "canada/saskatchewan.svgz",
         //: Provinces and territories of Canada: Saskatchewan
         "toolTipText" : qsTr("Saskatchewan"),
         "x" : "0.3081",
         "y" : "0.6866"
      },
      {
         "pixmapfile" : "canada/manitoba.svgz",
         //: Provinces and territories of Canada: Manitoba
         "toolTipText" : qsTr("Manitoba"),
         "x" : "0.4303",
         "y" : "0.6965"
      },
      {
         "pixmapfile" : "canada/ontario.svgz",
         //: Provinces and territories of Canada: Ontario
         "toolTipText" : qsTr("Ontario"),
         "x" : "0.5843",
         "y" : "0.8082"
      },
      {
         "pixmapfile" : "canada/quebec.svgz",
         //: Provinces and territories of Canada: Quebec
         "toolTipText" : qsTr("Quebec"),
         "x" : "0.7357",
         "y" : "0.6721"
      },
      {
         "pixmapfile" : "canada/newfoundland_and_labrador.svgz",
         //: Provinces and territories of Canada: Newfoundland and Labrador
         "toolTipText" : qsTr("Newfoundland and Labrador"),
         "x" : "0.8501",
         "y" : "0.5937"
      },
      {
         "pixmapfile" : "canada/new_brunswick.svgz",
         //: Provinces and territories of Canada: New Brunswick
         "toolTipText" : qsTr("New Brunswick"),
         "x" : "0.8228",
         "y" : "0.7811"
      },
      {
         "pixmapfile" : "canada/nova_scotia.svgz",
         //: Provinces and territories of Canada: Nova Scotia
         "toolTipText" : qsTr("Nova Scotia"),
         "x" : "0.8901",
         "y" : "0.7816"
      },
      {
         "pixmapfile" : "canada/prince_edward_island.svgz",
         //: Provinces and territories of Canada: Prince Edward Island
         "toolTipText" : qsTr("Prince Edward Island"),
         "x" : "0.8635",
         "y" : "0.7568"
      }
   ]
}
