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
   property string instruction: qsTr("Districts of Canada")
   property var levels: [
      {
         "pixmapfile" : "canada/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "canada/yukon.png",
         //: District of Canada: Yukon
         "toolTipText" : qsTr("Yukon"),
         "x" : "0.074",
         "y" : "0.372"
      },
      {
         "pixmapfile" : "canada/british_columbia.png",
         //: District of Canada: British Columbia
         "toolTipText" : qsTr("British Columbia"),
         "x" : "0.083",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "canada/northwest_territories.png",
         //: District of Canada: Northwest Territories
         "toolTipText" : qsTr("Northwest Territories"),
         "x" : "0.243",
         "y" : "0.365"
      },
      {
         "pixmapfile" : "canada/nunavut.png",
         //: District of Canada: Nunavut
         "toolTipText" : qsTr("Nunavut"),
         "x" : "0.469",
         "y" : "0.306"
      },
      {
         "pixmapfile" : "canada/alberta.png",
         //: District of Canada: Alberta
         "toolTipText" : qsTr("Alberta"),
         "x" : "0.204",
         "y" : "0.661"
      },
      {
         "pixmapfile" : "canada/saskatchewan.png",
         //: District of Canada: Saskatchewan
         "toolTipText" : qsTr("Saskatchewan"),
         "x" : "0.291",
         "y" : "0.688"
      },
      {
         "pixmapfile" : "canada/manitoba.png",
         //: District of Canada: Manitoba
         "toolTipText" : qsTr("Manitoba"),
         "x" : "0.417",
         "y" : "0.698"
      },
      {
         "pixmapfile" : "canada/ontario.png",
         //: District of Canada: Ontario
         "toolTipText" : qsTr("Ontario"),
         "x" : "0.582",
         "y" : "0.805"
      },
      {
         "pixmapfile" : "canada/quebec.png",
         //: District of Canada: Quebec
         "toolTipText" : qsTr("Quebec"),
         "x" : "0.742",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "canada/newfoundland_labrador.png",
         //: District of Canada: Newfoundland and Labrador
         "toolTipText" : qsTr("Newfoundland and Labrador"),
         "x" : "0.87",
         "y" : "0.603"
      },
      {
         "pixmapfile" : "canada/new_brunswick.png",
         //: District of Canada: New Brunswick
         "toolTipText" : qsTr("New Brunswick"),
         "x" : "0.834",
         "y" : "0.779"
      },
      {
         "pixmapfile" : "canada/nova_scotia.png",
         //: District of Canada: Nova Scotia
         "toolTipText" : qsTr("Nova Scotia"),
         "x" : "0.894",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "canada/prince_edward_island.png",
         //: District of Canada: Prince Edward Island
         "toolTipText" : qsTr("Prince Edward Island"),
         "x" : "0.878",
         "y" : "0.757"
      }
   ]
}
