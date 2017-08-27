/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import GCompris 1.0

ActivityInfo {
  name: "money_cents/MoneyCents.qml"
  difficulty: 5
  icon: "money_cents/money_cents.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  //: Activity title
  title: qsTr("Money with cents")
  //: Help title
  description: qsTr("Practice money usage including cents")
//  intro: "Click on the money to pay."
  //: Help goal
  goal: qsTr("You must buy the different items and give the exact price. At higher levels, several items are displayed, and you must first calculate the total price.")
  //: Help prerequisite
  prerequisite: qsTr("Can count")
  //: Help manual
  manual: qsTr("Click on the coins or paper money at the bottom of the screen to pay. If you want to remove a coin or note, click on it on the upper screen area.")
  credit: ""
  section: "math numeration money"
}
