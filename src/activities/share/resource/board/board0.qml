/* GCompris
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu@cti.pub.ro>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0

QtObject {
   property variant levels : [
      {
          "instruction" : qsTr("Paul wants to equally share 2 candies between his friends. They are 2. One girl and one boy. Can you help him? Place first the children in center, then drag the candies to each of them."),
          "nBoys" : 1,
          "nGirls" : 1,
          "nCandies" : 2
      },
      {
          "instruction" : qsTr("Now he wants to give 4 candies to his friends."),
          "nBoys" : 1,
          "nGirls" : 1,
          "nCandies" : 4
      },
      {
          "instruction" : qsTr("Can you now give 6 of Paul's candies to his friends?"),
          "nBoys" : 1,
          "nGirls" : 1,
          "nCandies" : 6
      },
      {
          "instruction" : qsTr("Paul has only 10 candies left. He eats 2 candies and he gives the rest to his friends. Can you help him equally split the 8 remaining candies?"),
          "nBoys" : 1,
          "nGirls" : 1,
          "nCandies" : 8
      }
   ]
}
