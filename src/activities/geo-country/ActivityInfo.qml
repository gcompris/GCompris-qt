/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
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

import GCompris 1.0

ActivityInfo {
  name: "geo-country/GeoCountry.qml"
  difficulty: 2
  icon: "geo-country/geo-country.svg"
  author: "Pulkit Gupta &lt;pulkitgenius@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Locate the region")
  //: Help title
  description: qsTr("Drag and Drop the regions to redraw the whole country")
//  intro: "Drag and drop the regions to complete the country maps."
  //: Help goal
  goal: ""
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: ""
  credit: ""
  section: "discovery"
  createdInVersion: 4000
}
