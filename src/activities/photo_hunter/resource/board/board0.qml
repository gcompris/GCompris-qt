/* GCompris
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
 *
 * Authors:
 *   Stefan Toncu <stefan.toncu@cti.pub.ro> (Qt Quick version)
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
          "imageName1": "images/photo1.svg",
          "imageName2": "images/photo2.svg",
          "coordinates": [[27,25],[37,1120],[325,1360]]
      },
      {
          "imageName1": "images/photo4.svg",
          "imageName2": "images/photo5.svg",
          "coordinates": [[930,255],[915,1515],[500,1360]]
      },
      {
          "imageName1": "images/photo1.svg",
          "imageName2": "images/photo3.svg",
          "coordinates": [[30,840],[505,1030],[470,1360]]
      }
   ]
}
