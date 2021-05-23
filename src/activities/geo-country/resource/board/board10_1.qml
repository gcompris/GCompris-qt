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
   property string instruction: qsTr("United States of America")
   property var levels: [
      {
         "pixmapfile" : "usa/background1.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "usa/washington.png",
         //: State of America: Washington
         "toolTipText" : qsTr("Washington"),
         "x" : "0.13",
         "y" : "0.083"
      },
      {
         "pixmapfile" : "usa/oregon.png",
         //: State of America: Oregon
         "toolTipText" : qsTr("Oregon"),
         "x" : "0.11",
         "y" : "0.199"
      },
      {
         "pixmapfile" : "usa/idaho.png",
         //: State of America: Idaho
         "toolTipText" : qsTr("Idaho"),
         "x" : "0.209",
         "y" : "0.187"
      },
      {
         "pixmapfile" : "usa/montana.png",
         //: State of America: Montana
         "toolTipText" : qsTr("Montana"),
         "x" : "0.293",
         "y" : "0.147"
      },
      {
         "pixmapfile" : "usa/north_dakota.png",
         //: State of America: North Dakota
         "toolTipText" : qsTr("North Dakota"),
         "x" : "0.436",
         "y" : "0.156"
      },
      {
         "pixmapfile" : "usa/south_dakota.png",
         //: State of America: South Dakota
         "toolTipText" : qsTr("South Dakota"),
         "x" : "0.435",
         "y" : "0.273"
      },
      {
         "pixmapfile" : "usa/nebraska.png",
         //: State of America: Nebraska
         "toolTipText" : qsTr("Nebraska"),
         "x" : "0.441",
         "y" : "0.376"
      },
      {
         "pixmapfile" : "usa/kansas.png",
         //: State of America: Kansas
         "toolTipText" : qsTr("Kansas"),
         "x" : "0.463",
         "y" : "0.49"
      },
      {
         "pixmapfile" : "usa/colorado.png",
         //: State of America: Colorado
         "toolTipText" : qsTr("Colorado"),
         "x" : "0.336",
         "y" : "0.458"
      },
      {
         "pixmapfile" : "usa/new_mexico.png",
         //: State of America: New Mexico
         "toolTipText" : qsTr("New Mexico"),
         "x" : "0.316",
         "y" : "0.625"
      },
      {
         "pixmapfile" : "usa/arizona.png",
         //: State of America: Arizona
         "toolTipText" : qsTr("Arizona"),
         "x" : "0.209",
         "y" : "0.613"
      },
      {
         "pixmapfile" : "usa/alaska.png",
         //: State of America: Alaska
         "toolTipText" : qsTr("Alaska"),
         "x" : "0.115",
         "y" : "0.861"
      },
      {
         "pixmapfile" : "usa/hawaii.png",
         //: State of America: Hawaii
         "toolTipText" : qsTr("Hawaii"),
         "x" : "0.302",
         "y" : "0.921"
      },
      {
         "pixmapfile" : "usa/texas.png",
         //: State of America: Texas
         "toolTipText" : qsTr("Texas"),
         "x" : "0.427",
         "y" : "0.754"
      },
      {
         "pixmapfile" : "usa/oklahoma.png",
         //: State of America: Oklahoma
         "toolTipText" : qsTr("Oklahoma"),
         "x" : "0.456",
         "y" : "0.605"
      },
      {
         "pixmapfile" : "usa/minnesota.png",
         //: State of America: Minnesota
         "toolTipText" : qsTr("Minnesota"),
         "x" : "0.544",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "usa/iowa.png",
         //: State of America: Iowa
         "toolTipText" : qsTr("Iowa"),
         "x" : "0.549",
         "y" : "0.36"
      },
      {
         "pixmapfile" : "usa/missouri.png",
         //: State of America: Missouri
         "toolTipText" : qsTr("Missouri"),
         "x" : "0.569",
         "y" : "0.494"
      },
      {
         "pixmapfile" : "usa/arkansas.png",
         //: State of America: Arkansas
         "toolTipText" : qsTr("Arkansas"),
         "x" : "0.574",
         "y" : "0.622"
      },
      {
         "pixmapfile" : "usa/louisiana.png",
         //: State of America: Louisiana
         "toolTipText" : qsTr("Louisiana"),
         "x" : "0.596",
         "y" : "0.758"
      },
      {
         "pixmapfile" : "usa/mississippi.png",
         //: State of America: Mississippi
         "toolTipText" : qsTr("Mississippi"),
         "x" : "0.626",
         "y" : "0.694"
      },
      {
         "pixmapfile" : "usa/tennessee.png",
         //: State of America: Tennessee
         "toolTipText" : qsTr("Tennessee"),
         "x" : "0.69",
         "y" : "0.569"
      },
      {
         "pixmapfile" : "usa/kentucky.png",
         //: State of America: Kentucky
         "toolTipText" : qsTr("Kentucky"),
         "x" : "0.69",
         "y" : "0.503"
      },
      {
         "pixmapfile" : "usa/indiana.png",
         //: State of America: Indiana
         "toolTipText" : qsTr("Indiana"),
         "x" : "0.673",
         "y" : "0.428"
      },
      {
         "pixmapfile" : "usa/illinois.png",
         //: State of America: Illinois
         "toolTipText" : qsTr("Illinois"),
         "x" : "0.618",
         "y" : "0.436"
      },
      {
         "pixmapfile" : "usa/wisconsin.png",
         //: State of America: Wisconsin
         "toolTipText" : qsTr("Wisconsin"),
         "x" : "0.6",
         "y" : "0.256"
      },
      {
         "pixmapfile" : "usa/michigan.png",
         //: State of America: Michigan
         "toolTipText" : qsTr("Michigan"),
         "x" : "0.66",
         "y" : "0.254"
      },
      {
         "pixmapfile" : "usa/ohio.png",
         //: State of America: Ohio
         "toolTipText" : qsTr("Ohio"),
         "x" : "0.733",
         "y" : "0.397"
      },
      {
         "pixmapfile" : "usa/west_virginia.png",
         //: State of America: West Virginia
         "toolTipText" : qsTr("West Virginia"),
         "x" : "0.785",
         "y" : "0.443"
      },
      {
         "pixmapfile" : "usa/virginia.png",
         //: State of America: Virginia
         "toolTipText" : qsTr("Virginia"),
         "x" : "0.806",
         "y" : "0.47"
      },
      {
         "pixmapfile" : "usa/north_carolina.png",
         //: State of America: North Carolina
         "toolTipText" : qsTr("North Carolina"),
         "x" : "0.801",
         "y" : "0.553"
      },
      {
         "pixmapfile" : "usa/south_carolina.png",
         //: State of America: South Carolina
         "toolTipText" : qsTr("South Carolina"),
         "x" : "0.788",
         "y" : "0.634"
      },
      {
         "pixmapfile" : "usa/georgia.png",
         //: State of America: Georgia
         "toolTipText" : qsTr("Georgia"),
         "x" : "0.75",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "usa/florida.png",
         //: State of America: Florida
         "toolTipText" : qsTr("Florida"),
         "x" : "0.754",
         "y" : "0.841"
      },
      {
         "pixmapfile" : "usa/alabama.png",
         //: State of America: Alabama
         "toolTipText" : qsTr("Alabama"),
         "x" : "0.688",
         "y" : "0.689"
      },
      {
         "pixmapfile" : "usa/maryland.png",
         //: State of America: Maryland
         "toolTipText" : qsTr("Maryland"),
         "x" : "0.841",
         "y" : "0.415"
      },
      {
         "pixmapfile" : "usa/new_jersey.png",
         //: State of America: New Jersey
         "toolTipText" : qsTr("New Jersey"),
         "x" : "0.872",
         "y" : "0.361"
      },
      {
         "pixmapfile" : "usa/delaware.png",
         //: State of America: Delaware
         "toolTipText" : qsTr("Delaware"),
         "x" : "0.867",
         "y" : "0.41"
      },
      {
         "pixmapfile" : "usa/pennsylvania.png",
         //: State of America: Pennsylvania
         "toolTipText" : qsTr("Pennsylvania"),
         "x" : "0.819",
         "y" : "0.352"
      },
      {
         "pixmapfile" : "usa/new_york.png",
         //: State of America: New York
         "toolTipText" : qsTr("New York"),
         "x" : "0.844",
         "y" : "0.261"
      },
      {
         "pixmapfile" : "usa/vermont.png",
         //: State of America: Vermont
         "toolTipText" : qsTr("Vermont"),
         "x" : "0.884",
         "y" : "0.215"
      },
      {
         "pixmapfile" : "usa/new_hampshire.png",
         //: State of America: New Hampshire
         "toolTipText" : qsTr("New Hampshire"),
         "x" : "0.906",
         "y" : "0.207"
      },
      {
         "pixmapfile" : "usa/maine.png",
         //: State of America: Maine
         "toolTipText" : qsTr("Maine"),
         "x" : "0.934",
         "y" : "0.149"
      },
      {
         "pixmapfile" : "usa/washington_dc.png",
         //: State of America: Washington D.C.
         "toolTipText" : qsTr("Washington D.C."),
         "x" : "0.943",
         "y" : "0.575"
      },
      {
         "pixmapfile" : "usa/california.png",
         //: State of America: California
         "toolTipText" : qsTr("California"),
         "x" : "0.096",
         "y" : "0.448"
      },
      {
         "pixmapfile" : "usa/nevada.png",
         //: State of America: Nevada
         "toolTipText" : qsTr("Nevada"),
         "x" : "0.146",
         "y" : "0.424"
      },
      {
         "pixmapfile" : "usa/utah.png",
         //: State of America: Utah
         "toolTipText" : qsTr("Utah"),
         "x" : "0.233",
         "y" : "0.418"
      },
      {
         "pixmapfile" : "usa/wyoming.png",
         //: State of America: Wyoming
         "toolTipText" : qsTr("Wyoming"),
         "x" : "0.313",
         "y" : "0.305"
      },
      {
         "pixmapfile" : "usa/massachusetts.png",
         //: State of America: Massachusetts
         "toolTipText" : qsTr("Massachusetts"),
         "x" : "0.909",
         "y" : "0.266"
      },
      {
         "pixmapfile" : "usa/rhode_island.png",
         //: State of America: Rhode Island
         "toolTipText" : qsTr("Rhode Island"),
         "x" : "0.915",
         "y" : "0.288"
      },
      {
         "pixmapfile" : "usa/connecticut.png",
         //: State of America: Connecticut
         "toolTipText" : qsTr("Connecticut"),
         "x" : "0.896",
         "y" : "0.301"
      }
   ]
}
