/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

QtObject {
   property int numberOfSubLevel: 1
   property string instruction: qsTr("United States of America")
   property var levels: [
      {
         "pixmapfile" : "usa/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "usa/washington.png",
         "toolTipText" : "Washington",
         "x" : "0.13",
         "y" : "0.083"
      },
      {
         "pixmapfile" : "usa/oregon.png",
         "toolTipText" : "Oregon",
         "x" : "0.11",
         "y" : "0.199"
      },
      {
         "pixmapfile" : "usa/idaho.png",
         "toolTipText" : "Idaho",
         "x" : "0.209",
         "y" : "0.187"
      },
      {
         "pixmapfile" : "usa/montana.png",
         "toolTipText" : "Montana",
         "x" : "0.293",
         "y" : "0.147"
      },
      {
         "pixmapfile" : "usa/north_dakota.png",
         "toolTipText" : "North Dakota",
         "x" : "0.436",
         "y" : "0.156"
      },
      {
         "pixmapfile" : "usa/south_dakota.png",
         "toolTipText" : "South Dakota",
         "x" : "0.435",
         "y" : "0.273"
      },
      {
         "pixmapfile" : "usa/nebraska.png",
         "toolTipText" : "Nebraska",
         "x" : "0.441",
         "y" : "0.376"
      },
      {
         "pixmapfile" : "usa/kansas.png",
         "toolTipText" : "Kansas",
         "x" : "0.463",
         "y" : "0.49"
      },
      {
         "pixmapfile" : "usa/colorado.png",
         "toolTipText" : "Colorado",
         "x" : "0.336",
         "y" : "0.458"
      },
      {
         "pixmapfile" : "usa/new_mexico.png",
         "toolTipText" : "New Mexico",
         "x" : "0.316",
         "y" : "0.625"
      },
      {
         "pixmapfile" : "usa/arizona.png",
         "toolTipText" : "Arizona",
         "x" : "0.209",
         "y" : "0.613"
      },
      {
         "pixmapfile" : "usa/alaska.png",
         "toolTipText" : "Alaska",
         "x" : "0.115",
         "y" : "0.861"
      },
      {
         "pixmapfile" : "usa/hawaii.png",
         "toolTipText" : "Hawaii",
         "x" : "0.302",
         "y" : "0.921"
      },
      {
         "pixmapfile" : "usa/texas.png",
         "toolTipText" : "Texas",
         "x" : "0.427",
         "y" : "0.754"
      },
      {
         "pixmapfile" : "usa/oklahoma.png",
         "toolTipText" : "Oklahoma",
         "x" : "0.456",
         "y" : "0.605"
      },
      {
         "pixmapfile" : "usa/minnesota.png",
         "toolTipText" : "Minnesota",
         "x" : "0.544",
         "y" : "0.197"
      },
      {
         "pixmapfile" : "usa/iowa.png",
         "toolTipText" : "Iowa",
         "x" : "0.549",
         "y" : "0.36"
      },
      {
         "pixmapfile" : "usa/missouri.png",
         "toolTipText" : "Missouri",
         "x" : "0.569",
         "y" : "0.494"
      },
      {
         "pixmapfile" : "usa/arkansas.png",
         "toolTipText" : "Arkansas",
         "x" : "0.574",
         "y" : "0.622"
      },
      {
         "pixmapfile" : "usa/louisiana.png",
         "toolTipText" : "Louisiana",
         "x" : "0.596",
         "y" : "0.758"
      },
      {
         "pixmapfile" : "usa/mississippi.png",
         "toolTipText" : "Mississippi",
         "x" : "0.626",
         "y" : "0.694"
      },
      {
         "pixmapfile" : "usa/tennessee.png",
         "toolTipText" : "Tennessee",
         "x" : "0.69",
         "y" : "0.569"
      },
      {
         "pixmapfile" : "usa/kentucky.png",
         "toolTipText" : "Kentucky",
         "x" : "0.69",
         "y" : "0.503"
      },
      {
         "pixmapfile" : "usa/indiana.png",
         "toolTipText" : "Indiana",
         "x" : "0.673",
         "y" : "0.428"
      },
      {
         "pixmapfile" : "usa/illinois.png",
         "toolTipText" : "Illinois",
         "x" : "0.618",
         "y" : "0.436"
      },
      {
         "pixmapfile" : "usa/wisconsin.png",
         "toolTipText" : "Wisconsin",
         "x" : "0.6",
         "y" : "0.256"
      },
      {
         "pixmapfile" : "usa/michigan.png",
         "toolTipText" : "Michigan",
         "x" : "0.66",
         "y" : "0.254"
      },
      {
         "pixmapfile" : "usa/ohio.png",
         "toolTipText" : "Ohio",
         "x" : "0.733",
         "y" : "0.397"
      },
      {
         "pixmapfile" : "usa/west_virginia.png",
         "toolTipText" : "West Virginia",
         "x" : "0.785",
         "y" : "0.443"
      },
      {
         "pixmapfile" : "usa/virginia.png",
         "toolTipText" : "Virginia",
         "x" : "0.806",
         "y" : "0.47"
      },
      {
         "pixmapfile" : "usa/north_carolina.png",
         "toolTipText" : "North Carolina",
         "x" : "0.801",
         "y" : "0.553"
      },
      {
         "pixmapfile" : "usa/south_carolina.png",
         "toolTipText" : "South Carolina",
         "x" : "0.788",
         "y" : "0.634"
      },
      {
         "pixmapfile" : "usa/georgia.png",
         //: Translators: Strip USA| and translate only Georgia
         "toolTipText" : "USA|Georgia",
         "x" : "0.75",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "usa/florida.png",
         "toolTipText" : "Florida",
         "x" : "0.754",
         "y" : "0.841"
      },
      {
         "pixmapfile" : "usa/alabama.png",
         "toolTipText" : "Alabama",
         "x" : "0.688",
         "y" : "0.689"
      },
      {
         "pixmapfile" : "usa/maryland.png",
         "toolTipText" : "Maryland",
         "x" : "0.841",
         "y" : "0.415"
      },
      {
         "pixmapfile" : "usa/new_jersey.png",
         "toolTipText" : "New Jersey",
         "x" : "0.872",
         "y" : "0.361"
      },
      {
         "pixmapfile" : "usa/delaware.png",
         "toolTipText" : "Delaware",
         "x" : "0.867",
         "y" : "0.41"
      },
      {
         "pixmapfile" : "usa/pennsylvania.png",
         "toolTipText" : "Pennsylvania",
         "x" : "0.819",
         "y" : "0.352"
      },
      {
         "pixmapfile" : "usa/new_york.png",
         "toolTipText" : "New York",
         "x" : "0.844",
         "y" : "0.261"
      },
      {
         "pixmapfile" : "usa/vermont.png",
         "toolTipText" : "Vermont",
         "x" : "0.884",
         "y" : "0.215"
      },
      {
         "pixmapfile" : "usa/new_hampshire.png",
         "toolTipText" : "New Hampshire",
         "x" : "0.906",
         "y" : "0.207"
      },
      {
         "pixmapfile" : "usa/maine.png",
         "toolTipText" : "Maine",
         "x" : "0.934",
         "y" : "0.149"
      },
      {
         "pixmapfile" : "usa/washington_dc.png",
         "toolTipText" : "Washington D.C.",
         "x" : "0.943",
         "y" : "0.575"
      },
      {
         "pixmapfile" : "usa/california.png",
         "toolTipText" : "California",
         "x" : "0.096",
         "y" : "0.448"
      },
      {
         "pixmapfile" : "usa/nevada.png",
         "toolTipText" : "Nevada",
         "x" : "0.146",
         "y" : "0.424"
      },
      {
         "pixmapfile" : "usa/utah.png",
         "toolTipText" : "Utah",
         "x" : "0.233",
         "y" : "0.418"
      },
      {
         "pixmapfile" : "usa/wyoming.png",
         "toolTipText" : "Wyoming",
         "x" : "0.313",
         "y" : "0.305"
      },
      {
         "pixmapfile" : "usa/massachusetts.png",
         "toolTipText" : "Massachusetts",
         "x" : "0.909",
         "y" : "0.266"
      },
      {
         "pixmapfile" : "usa/rhode_island.png",
         "toolTipText" : "Rhode Island",
         "x" : "0.915",
         "y" : "0.288"
      },
      {
         "pixmapfile" : "usa/connecticut.png",
         "toolTipText" : "Connecticut",
         "x" : "0.896",
         "y" : "0.301"
      }
   ]
}
