/* GCompris - photo_hunter.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
 *
 * Authors:
 *   Stefan Toncu <stefan.toncu@cti.pub.ro> (Qt Quick port)
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
import QtQuick 2.0

QtObject {
   property variant levels : [
      {
          "imageName1": "images/photo16.svg",
          "imageName2": "images/photo17.svg",
          "coordinates": [[70,600],[950,1120],[325,760]]
      },
      {
          "imageName1": "images/photo18.svg",
          "imageName2": "images/photo19.svg",
          "coordinates": [[435,1075],[17,1195],[782,670],[90,945],[490,400],[300,620]]
      },
      {
          "imageName1": "images/photo20.svg",
          "imageName2": "images/photo21.svg",
          "coordinates": [[275,345],[1013,1232],[595,1460]]
      },
      {
          "imageName1": "images/photo22.svg",
          "imageName2": "images/photo23.svg",
          "coordinates": [[668,403],[727,930],[565,1120],[595,1500]]
      }
   ]
}
