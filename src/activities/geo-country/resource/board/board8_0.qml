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
         "x" : "0.1125",
         "y" : "0.4495"
      },
      {
         "pixmapfile" : "canada/british_columbia.svgz",
         //: Provinces and territories of Canada: British Columbia
         "toolTipText" : qsTr("British Columbia"),
         "x" : "0.1784",
         "y" : "0.6718"
      },
      {
         "pixmapfile" : "canada/northwest_territories.svgz",
         //: Provinces and territories of Canada: Northwest Territories
         "toolTipText" : qsTr("Northwest Territories"),
         "x" : "0.2565",
         "y" : "0.3542"
      },
      {
         "pixmapfile" : "canada/nunavut.svgz",
         //: Provinces and territories of Canada: Nunavut
         "toolTipText" : qsTr("Nunavut"),
         "x" : "0.564",
         "y" : "0.3852"
      },
      {
         "pixmapfile" : "canada/alberta.svgz",
         //: Provinces and territories of Canada: Alberta
         "toolTipText" : qsTr("Alberta"),
         "x" : "0.3025",
         "y" : "0.6647"
      },
      {
         "pixmapfile" : "canada/saskatchewan.svgz",
         //: Provinces and territories of Canada: Saskatchewan
         "toolTipText" : qsTr("Saskatchewan"),
         "x" : "0.4037",
         "y" : "0.6647"
      },
      {
         "pixmapfile" : "canada/manitoba.svgz",
         //: Provinces and territories of Canada: Manitoba
         "toolTipText" : qsTr("Manitoba"),
         "x" : "0.5135",
         "y" : "0.6647"
      },
      {
         "pixmapfile" : "canada/ontario.svgz",
         //: Provinces and territories of Canada: Ontario
         "toolTipText" : qsTr("Ontario"),
         "x" : "0.6306",
         "y" : "0.7742"
      },
      {
         "pixmapfile" : "canada/quebec.svgz",
         //: Provinces and territories of Canada: Quebec
         "toolTipText" : qsTr("Quebec"),
         "x" : "0.8091",
         "y" : "0.6802"
      },
      {
         "pixmapfile" : "canada/newfoundland_and_labrador.svgz",
         //: Provinces and territories of Canada: Newfoundland and Labrador
         "toolTipText" : qsTr("Newfoundland and Labrador"),
         "x" : "0.8976",
         "y" : "0.6867"
      },
      {
         "pixmapfile" : "canada/new_brunswick.svgz",
         //: Provinces and territories of Canada: New Brunswick
         "toolTipText" : qsTr("New Brunswick"),
         "x" : "0.8309",
         "y" : "0.8304"
      },
      {
         "pixmapfile" : "canada/nova_scotia.svgz",
         //: Provinces and territories of Canada: Nova Scotia
         "toolTipText" : qsTr("Nova Scotia"),
         "x" : "0.8682",
         "y" : "0.8579"
      },
      {
         "pixmapfile" : "canada/prince_edward_island.svgz",
         //: Provinces and territories of Canada: Prince Edward Island
         "toolTipText" : qsTr("Prince Edward Island"),
         "x" : "0.8644",
         "y" : "0.8325"
      }
   ]
}
