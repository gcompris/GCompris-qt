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
   property string instruction: qsTr("United States of America")
   property var levels: [
      {
         "pixmapfile" : "usa/usa.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "usa/washington.svgz",
         //: State of America: Washington
         "toolTipText" : qsTr("Washington"),
         "x" : "0.1274",
         "y" : "0.112"
      },
      {
         "pixmapfile" : "usa/oregon.svgz",
         //: State of America: Oregon
         "toolTipText" : qsTr("Oregon"),
         "x" : "0.1066",
         "y" : "0.2227"
      },
      {
         "pixmapfile" : "usa/idaho.svgz",
         //: State of America: Idaho
         "toolTipText" : qsTr("Idaho"),
         "x" : "0.2078",
         "y" : "0.2108"
      },
      {
         "pixmapfile" : "usa/montana.svgz",
         //: State of America: Montana
         "toolTipText" : qsTr("Montana"),
         "x" : "0.2924",
         "y" : "0.1723"
      },
      {
         "pixmapfile" : "usa/north_dakota.svgz",
         //: State of America: North Dakota
         "toolTipText" : qsTr("North Dakota"),
         "x" : "0.4409",
         "y" : "0.1808"
      },
      {
         "pixmapfile" : "usa/south_dakota.svgz",
         //: State of America: South Dakota
         "toolTipText" : qsTr("South Dakota"),
         "x" : "0.4387",
         "y" : "0.2943"
      },
      {
         "pixmapfile" : "usa/nebraska.svgz",
         //: State of America: Nebraska
         "toolTipText" : qsTr("Nebraska"),
         "x" : "0.4461",
         "y" : "0.3897"
      },
      {
         "pixmapfile" : "usa/kansas.svgz",
         //: State of America: Kansas
         "toolTipText" : qsTr("Kansas"),
         "x" : "0.4676",
         "y" : "0.4972"
      },
      {
         "pixmapfile" : "usa/colorado.svgz",
         //: State of America: Colorado
         "toolTipText" : qsTr("Colorado"),
         "x" : "0.3387",
         "y" : "0.4677"
      },
      {
         "pixmapfile" : "usa/new_mexico.svgz",
         //: State of America: New Mexico
         "toolTipText" : qsTr("New Mexico"),
         "x" : "0.3176",
         "y" : "0.6288"
      },
      {
         "pixmapfile" : "usa/arizona.svgz",
         //: State of America: Arizona
         "toolTipText" : qsTr("Arizona"),
         "x" : "0.2094",
         "y" : "0.6157"
      },
      {
         "pixmapfile" : "usa/alaska.svgz",
         //: State of America: Alaska
         "toolTipText" : qsTr("Alaska"),
         "x" : "0.1325",
         "y" : "0.8467"
      },
      {
         "pixmapfile" : "usa/hawaii.svgz",
         //: State of America: Hawaii
         "toolTipText" : qsTr("Hawaii"),
         "x" : "0.3047",
         "y" : "0.8796"
      },
      {
         "pixmapfile" : "usa/texas.svgz",
         //: State of America: Texas
         "toolTipText" : qsTr("Texas"),
         "x" : "0.4306",
         "y" : "0.7537"
      },
      {
         "pixmapfile" : "usa/oklahoma.svgz",
         //: State of America: Oklahoma
         "toolTipText" : qsTr("Oklahoma"),
         "x" : "0.4603",
         "y" : "0.6083"
      },
      {
         "pixmapfile" : "usa/minnesota.svgz",
         //: State of America: Minnesota
         "toolTipText" : qsTr("Minnesota"),
         "x" : "0.5518",
         "y" : "0.2211"
      },
      {
         "pixmapfile" : "usa/iowa.svgz",
         //: State of America: Iowa
         "toolTipText" : qsTr("Iowa"),
         "x" : "0.5554",
         "y" : "0.3753"
      },
      {
         "pixmapfile" : "usa/missouri.svgz",
         //: State of America: Missouri
         "toolTipText" : qsTr("Missouri"),
         "x" : "0.5755",
         "y" : "0.5031"
      },
      {
         "pixmapfile" : "usa/arkansas.svgz",
         //: State of America: Arkansas
         "toolTipText" : qsTr("Arkansas"),
         "x" : "0.582",
         "y" : "0.6293"
      },
      {
         "pixmapfile" : "usa/louisiana.svgz",
         //: State of America: Louisiana
         "toolTipText" : qsTr("Louisiana"),
         "x" : "0.5986",
         "y" : "0.7578"
      },
      {
         "pixmapfile" : "usa/mississippi.svgz",
         //: State of America: Mississippi
         "toolTipText" : qsTr("Mississippi"),
         "x" : "0.629",
         "y" : "0.7006"
      },
      {
         "pixmapfile" : "usa/tennessee.svgz",
         //: State of America: Tennessee
         "toolTipText" : qsTr("Tennessee"),
         "x" : "0.6957",
         "y" : "0.5776"
      },
      {
         "pixmapfile" : "usa/kentucky.svgz",
         //: State of America: Kentucky
         "toolTipText" : qsTr("Kentucky"),
         "x" : "0.6966",
         "y" : "0.5119"
      },
      {
         "pixmapfile" : "usa/indiana.svgz",
         //: State of America: Indiana
         "toolTipText" : qsTr("Indiana"),
         "x" : "0.682",
         "y" : "0.4418"
      },
      {
         "pixmapfile" : "usa/illinois.svgz",
         //: State of America: Illinois
         "toolTipText" : qsTr("Illinois"),
         "x" : "0.6258",
         "y" : "0.4473"
      },
      {
         "pixmapfile" : "usa/wisconsin.svgz",
         //: State of America: Wisconsin
         "toolTipText" : qsTr("Wisconsin"),
         "x" : "0.6148",
         "y" : "0.2703"
      },
      {
         "pixmapfile" : "usa/michigan.svgz",
         //: State of America: Michigan
         "toolTipText" : qsTr("Michigan"),
         "x" : "0.6707",
         "y" : "0.2614"
      },
      {
         "pixmapfile" : "usa/ohio.svgz",
         //: State of America: Ohio
         "toolTipText" : qsTr("Ohio"),
         "x" : "0.7407",
         "y" : "0.4051"
      },
      {
         "pixmapfile" : "usa/west_virginia.svgz",
         //: State of America: West Virginia
         "toolTipText" : qsTr("West Virginia"),
         "x" : "0.7917",
         "y" : "0.4538"
      },
      {
         "pixmapfile" : "usa/virginia.svgz",
         //: State of America: Virginia
         "toolTipText" : qsTr("Virginia"),
         "x" : "0.8089",
         "y" : "0.4835"
      },
      {
         "pixmapfile" : "usa/north_carolina.svgz",
         //: State of America: North Carolina
         "toolTipText" : qsTr("North Carolina"),
         "x" : "0.8104",
         "y" : "0.5636"
      },
      {
         "pixmapfile" : "usa/south_carolina.svgz",
         //: State of America: South Carolina
         "toolTipText" : qsTr("South Carolina"),
         "x" : "0.7953",
         "y" : "0.6389"
      },
      {
         "pixmapfile" : "usa/georgia.svgz",
         //: State of America: Georgia
         "toolTipText" : qsTr("Georgia"),
         "x" : "0.7558",
         "y" : "0.6773"
      },
      {
         "pixmapfile" : "usa/florida.svgz",
         //: State of America: Florida
         "toolTipText" : qsTr("Florida"),
         "x" : "0.7591",
         "y" : "0.8354"
      },
      {
         "pixmapfile" : "usa/alabama.svgz",
         //: State of America: Alabama
         "toolTipText" : qsTr("Alabama"),
         "x" : "0.6921",
         "y" : "0.6942"
      },
      {
         "pixmapfile" : "usa/maryland.svgz",
         //: State of America: Maryland
         "toolTipText" : qsTr("Maryland"),
         "x" : "0.8426",
         "y" : "0.4305"
      },
      {
         "pixmapfile" : "usa/new_jersey.svgz",
         //: State of America: New Jersey
         "toolTipText" : qsTr("New Jersey"),
         "x" : "0.8811",
         "y" : "0.3791"
      },
      {
         "pixmapfile" : "usa/delaware.svgz",
         //: State of America: Delaware
         "toolTipText" : qsTr("Delaware"),
         "x" : "0.8747",
         "y" : "0.4182"
      },
      {
         "pixmapfile" : "usa/pennsylvania.svgz",
         //: State of America: Pennsylvania
         "toolTipText" : qsTr("Pennsylvania"),
         "x" : "0.827",
         "y" : "0.371"
      },
      {
         "pixmapfile" : "usa/new_york.svgz",
         //: State of America: New York
         "toolTipText" : qsTr("New York"),
         "x" : "0.85",
         "y" : "0.2821"
      },
      {
         "pixmapfile" : "usa/vermont.svgz",
         //: State of America: Vermont
         "toolTipText" : qsTr("Vermont"),
         "x" : "0.8934",
         "y" : "0.2371"
      },
      {
         "pixmapfile" : "usa/new_hampshire.svgz",
         //: State of America: New Hampshire
         "toolTipText" : qsTr("New Hampshire"),
         "x" : "0.9167",
         "y" : "0.2286"
      },
      {
         "pixmapfile" : "usa/maine.svgz",
         //: State of America: Maine
         "toolTipText" : qsTr("Maine"),
         "x" : "0.9459",
         "y" : "0.1725"
      },
      {
         "pixmapfile" : "usa/california.svgz",
         //: State of America: California
         "toolTipText" : qsTr("California"),
         "x" : "0.0941",
         "y" : "0.4592"
      },
      {
         "pixmapfile" : "usa/nevada.svgz",
         //: State of America: Nevada
         "toolTipText" : qsTr("Nevada"),
         "x" : "0.1447",
         "y" : "0.4349"
      },
      {
         "pixmapfile" : "usa/utah.svgz",
         //: State of America: Utah
         "toolTipText" : qsTr("Utah"),
         "x" : "0.2328",
         "y" : "0.4303"
      },
      {
         "pixmapfile" : "usa/wyoming.svgz",
         //: State of America: Wyoming
         "toolTipText" : qsTr("Wyoming"),
         "x" : "0.3144",
         "y" : "0.3223"
      },
      {
         "pixmapfile" : "usa/massachusetts.svgz",
         //: State of America: Massachusetts
         "toolTipText" : qsTr("Massachusetts"),
         "x" : "0.9228",
         "y" : "0.2873"
      },
      {
         "pixmapfile" : "usa/rhode_island.svgz",
         //: State of America: Rhode Island
         "toolTipText" : qsTr("Rhode Island"),
         "x" : "0.9271",
         "y" : "0.3073"
      },
      {
         "pixmapfile" : "usa/connecticut.svgz",
         //: State of America: Connecticut
         "toolTipText" : qsTr("Connecticut"),
         "x" : "0.9078",
         "y" : "0.3196"
      }
   ]
}
