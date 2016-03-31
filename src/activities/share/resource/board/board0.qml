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
import QtQuick 2.0

QtObject {
   property string instruction: qsTr("Paul wants to share equally his 9 candies between his friends. They are 3. One girl and two boys. Can you help him? Place first the boys and the girl in the class, then share the candies among them.")

   property variant levels : [
      {
          "instruction" : "Paul wants to share equally his 9 candies between his friends. They are 3. One girl and two boys. Can you help him? Place first the boys and the girl in the class, then share the candies among them.",
          "nBoys" : 1,
          "nGirls" : 1,
          "nCandies" : 2
      },
      {
          "instruction" : "Now he wants give 4 candies to his friends.",
          "nBoys" : 1,
          "nGirls" : 1,
          "nCandies" : 4
      },
      {
          "instruction" : "Paul has 6 candies, he wants to share them to his two friends: a boy and a girl",
          "nBoys" : 1,
          "nGirls" : 1,
          "nCandies" : 6
      },
      {
          "instruction" : "Paul has 3 candies, he wants to share them to his two friends: a boy and a girl",
          "nBoys" : 1,
          "nGirls" : 1,
          "nCandies" : 6
      }
   ]
}
