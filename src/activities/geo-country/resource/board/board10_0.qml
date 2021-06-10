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
         "x" : "0.0857",
         "y" : "0.1256"
      },
      {
         "pixmapfile" : "usa/oregon.svgz",
         //: State of America: Oregon
         "toolTipText" : qsTr("Oregon"),
         "x" : "0.0906",
         "y" : "0.2401"
      },
      {
         "pixmapfile" : "usa/idaho.svgz",
         //: State of America: Idaho
         "toolTipText" : qsTr("Idaho"),
         "x" : "0.1972",
         "y" : "0.1898"
      },
      {
         "pixmapfile" : "usa/montana.svgz",
         //: State of America: Montana
         "toolTipText" : qsTr("Montana"),
         "x" : "0.2649",
         "y" : "0.1476"
      },
      {
         "pixmapfile" : "usa/north_dakota.svgz",
         //: State of America: North Dakota
         "toolTipText" : qsTr("North Dakota"),
         "x" : "0.426",
         "y" : "0.1191"
      },
      {
         "pixmapfile" : "usa/south_dakota.svgz",
         //: State of America: South Dakota
         "toolTipText" : qsTr("South Dakota"),
         "x" : "0.4271",
         "y" : "0.2358"
      },
      {
         "pixmapfile" : "usa/nebraska.svgz",
         //: State of America: Nebraska
         "toolTipText" : qsTr("Nebraska"),
         "x" : "0.4364",
         "y" : "0.3343"
      },
      {
         "pixmapfile" : "usa/kansas.svgz",
         //: State of America: Kansas
         "toolTipText" : qsTr("Kansas"),
         "x" : "0.4595",
         "y" : "0.4427"
      },
      {
         "pixmapfile" : "usa/colorado.svgz",
         //: State of America: Colorado
         "toolTipText" : qsTr("Colorado"),
         "x" : "0.3397",
         "y" : "0.425"
      },
      {
         "pixmapfile" : "usa/new_mexico.svgz",
         //: State of America: New Mexico
         "toolTipText" : qsTr("New Mexico"),
         "x" : "0.3313",
         "y" : "0.5995"
      },
      {
         "pixmapfile" : "usa/arizona.svgz",
         //: State of America: Arizona
         "toolTipText" : qsTr("Arizona"),
         "x" : "0.2333",
         "y" : "0.5995"
      },
      {
         "pixmapfile" : "usa/alaska.svgz",
         //: State of America: Alaska
         "toolTipText" : qsTr("Alaska"),
         "x" : "0.2101",
         "y" : "0.8312"
      },
      {
         "pixmapfile" : "usa/hawaii.svgz",
         //: State of America: Hawaii
         "toolTipText" : qsTr("Hawaii"),
         "x" : "0.3688",
         "y" : "0.8725"
      },
      {
         "pixmapfile" : "usa/texas.svgz",
         //: State of America: Texas
         "toolTipText" : qsTr("Texas"),
         "x" : "0.4303",
         "y" : "0.7064"
      },
      {
         "pixmapfile" : "usa/oklahoma.svgz",
         //: State of America: Oklahoma
         "toolTipText" : qsTr("Oklahoma"),
         "x" : "0.4525",
         "y" : "0.5572"
      },
      {
         "pixmapfile" : "usa/minnesota.svgz",
         //: State of America: Minnesota
         "toolTipText" : qsTr("Minnesota"),
         "x" : "0.5412",
         "y" : "0.156"
      },
      {
         "pixmapfile" : "usa/iowa.svgz",
         //: State of America: Iowa
         "toolTipText" : qsTr("Iowa"),
         "x" : "0.5413",
         "y" : "0.3181"
      },
      {
         "pixmapfile" : "usa/missouri.svgz",
         //: State of America: Missouri
         "toolTipText" : qsTr("Missouri"),
         "x" : "0.5567",
         "y" : "0.4501"
      },
      {
         "pixmapfile" : "usa/arkansas.svgz",
         //: State of America: Arkansas
         "toolTipText" : qsTr("Arkansas"),
         "x" : "0.5617",
         "y" : "0.5789"
      },
      {
         "pixmapfile" : "usa/louisiana.svgz",
         //: State of America: Louisiana
         "toolTipText" : qsTr("Louisiana"),
         "x" : "0.5714",
         "y" : "0.7132"
      },
      {
         "pixmapfile" : "usa/mississippi.svgz",
         //: State of America: Mississippi
         "toolTipText" : qsTr("Mississippi"),
         "x" : "0.5991",
         "y" : "0.6556"
      },
      {
         "pixmapfile" : "usa/tennessee.svgz",
         //: State of America: Tennessee
         "toolTipText" : qsTr("Tennessee"),
         "x" : "0.6648",
         "y" : "0.5392"
      },
      {
         "pixmapfile" : "usa/kentucky.svgz",
         //: State of America: Kentucky
         "toolTipText" : qsTr("Kentucky"),
         "x" : "0.6689",
         "y" : "0.4678"
      },
      {
         "pixmapfile" : "usa/indiana.svgz",
         //: State of America: Indiana
         "toolTipText" : qsTr("Indiana"),
         "x" : "0.6559",
         "y" : "0.3968"
      },
      {
         "pixmapfile" : "usa/illinois.svgz",
         //: State of America: Illinois
         "toolTipText" : qsTr("Illinois"),
         "x" : "0.6095",
         "y" : "0.398"
      },
      {
         "pixmapfile" : "usa/wisconsin.svgz",
         //: State of America: Wisconsin
         "toolTipText" : qsTr("Wisconsin"),
         "x" : "0.6046",
         "y" : "0.2121"
      },
      {
         "pixmapfile" : "usa/michigan.svgz",
         //: State of America: Michigan
         "toolTipText" : qsTr("Michigan"),
         "x" : "0.6595",
         "y" : "0.2076"
      },
      {
         "pixmapfile" : "usa/ohio.svgz",
         //: State of America: Ohio
         "toolTipText" : qsTr("Ohio"),
         "x" : "0.7191",
         "y" : "0.3758"
      },
      {
         "pixmapfile" : "usa/west_virginia.svgz",
         //: State of America: West Virginia
         "toolTipText" : qsTr("West Virginia"),
         "x" : "0.7602",
         "y" : "0.4281"
      },
      {
         "pixmapfile" : "usa/virginia.svgz",
         //: State of America: Virginia
         "toolTipText" : qsTr("Virginia"),
         "x" : "0.7725",
         "y" : "0.4616"
      },
      {
         "pixmapfile" : "usa/north_carolina.svgz",
         //: State of America: North Carolina
         "toolTipText" : qsTr("North Carolina"),
         "x" : "0.765",
         "y" : "0.5617"
      },
      {
         "pixmapfile" : "usa/south_carolina.svgz",
         //: State of America: South Carolina
         "toolTipText" : qsTr("South Carolina"),
         "x" : "0.7478",
         "y" : "0.6178"
      },
      {
         "pixmapfile" : "usa/georgia.svgz",
         //: State of America: Georgia
         "toolTipText" : qsTr("Georgia"),
         "x" : "0.7099",
         "y" : "0.6532"
      },
      {
         "pixmapfile" : "usa/florida.svgz",
         //: State of America: Florida
         "toolTipText" : qsTr("Florida"),
         "x" : "0.6998",
         "y" : "0.8192"
      },
      {
         "pixmapfile" : "usa/alabama.svgz",
         //: State of America: Alabama
         "toolTipText" : qsTr("Alabama"),
         "x" : "0.6525",
         "y" : "0.6549"
      },
      {
         "pixmapfile" : "usa/maryland.svgz",
         //: State of America: Maryland
         "toolTipText" : qsTr("Maryland"),
         "x" : "0.808",
         "y" : "0.429"
      },
      {
         "pixmapfile" : "usa/new_jersey.svgz",
         //: State of America: New Jersey
         "toolTipText" : qsTr("New Jersey"),
         "x" : "0.8505",
         "y" : "0.3836"
      },
      {
         "pixmapfile" : "usa/delaware.svgz",
         //: State of America: Delaware
         "toolTipText" : qsTr("Delaware"),
         "x" : "0.8394",
         "y" : "0.4204"
      },
      {
         "pixmapfile" : "usa/pennsylvania.svgz",
         //: State of America: Pennsylvania
         "toolTipText" : qsTr("Pennsylvania"),
         "x" : "0.8031",
         "y" : "0.3492"
      },
      {
         "pixmapfile" : "usa/new_york.svgz",
         //: State of America: New York
         "toolTipText" : qsTr("New York"),
         "x" : "0.8288",
         "y" : "0.2872"
      },
      {
         "pixmapfile" : "usa/vermont.svgz",
         //: State of America: Vermont
         "toolTipText" : qsTr("Vermont"),
         "x" : "0.8886",
         "y" : "0.2489"
      },
      {
         "pixmapfile" : "usa/new_hampshire.svgz",
         //: State of America: New Hampshire
         "toolTipText" : qsTr("New Hampshire"),
         "x" : "0.9026",
         "y" : "0.2443"
      },
      {
         "pixmapfile" : "usa/maine.svgz",
         //: State of America: Maine
         "toolTipText" : qsTr("Maine"),
         "x" : "0.9453",
         "y" : "0.1983"
      },
      {
         "pixmapfile" : "usa/california.svgz",
         //: State of America: California
         "toolTipText" : qsTr("California"),
         "x" : "0.1113",
         "y" : "0.4866"
      },
      {
         "pixmapfile" : "usa/nevada.svgz",
         //: State of America: Nevada
         "toolTipText" : qsTr("Nevada"),
         "x" : "0.1489",
         "y" : "0.4416"
      },
      {
         "pixmapfile" : "usa/utah.svgz",
         //: State of America: Utah
         "toolTipText" : qsTr("Utah"),
         "x" : "0.2397",
         "y" : "0.4066"
      },
      {
         "pixmapfile" : "usa/wyoming.svgz",
         //: State of America: Wyoming
         "toolTipText" : qsTr("Wyoming"),
         "x" : "0.3064",
         "y" : "0.2805"
      },
      {
         "pixmapfile" : "usa/massachusetts.svgz",
         //: State of America: Massachusetts
         "toolTipText" : qsTr("Massachusetts"),
         "x" : "0.901",
         "y" : "0.3149"
      },
      {
         "pixmapfile" : "usa/rhode_island.svgz",
         //: State of America: Rhode Island
         "toolTipText" : qsTr("Rhode Island"),
         "x" : "0.9044",
         "y" : "0.3314"
      },
      {
         "pixmapfile" : "usa/connecticut.svgz",
         //: State of America: Connecticut
         "toolTipText" : qsTr("Connecticut"),
         "x" : "0.884",
         "y" : "0.3325"
      }
   ]
}
