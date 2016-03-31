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
	      "imageName1": "images/photo8.svg",
	      "imageName2": "images/photo9.svg",
	      "coordinates": [[800,40],[570,1370]]
      },
      {
          "imageName1": "images/photo10.svg",
          "imageName2": "images/photo11.svg",
          "coordinates": [[965,93],[633,655],[585,1560]]
      },
      {
          "imageName1": "images/photo12.svg",
          "imageName2": "images/photo13.svg",
          "coordinates": [[525,145],[280,1160],[600,1052]]
      },
      {
	      "imageName1": "images/photo14.svg",
	      "imageName2": "images/photo15.svg",
	      "coordinates": [[183,500],[795,215],[950,1450]]
      }
   ]
}
