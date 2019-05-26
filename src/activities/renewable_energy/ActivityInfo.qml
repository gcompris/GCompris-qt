/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
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
 * along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
    name: "renewable_energy/RenewableEnergy.qml"
    difficulty: 4
    icon: "renewable_energy/renewable_energy.svg"
    author: "Sagar Chand Agarwal &lt;atomsagar@gmail.com&gt;"
    demo: true
    //: Activity title
    title: qsTr("Renewable Energy")
    //: Help title
    description: qsTr("Tux has come back from fishing on his boat. Bring the electrical system back up so he can have light in his home. ")
    //intro: "Click on the different stages that go to make up the power supply."
    //: Help goal
    goal: qsTr("Learn about an electrical system based on renewable energy")
    //: Help manual
    manual: qsTr("Click on different active elements: sun, cloud, dam, solar array, wind farm and transformers, in order to reactivate the entire electrical system. When the system is back up and Tux is in his home, push the light button for him. To win you must switch on all the consumers while all the producers are up. ")
    //: Help prerequisite
    prerequisite: ""
    credit: qsTr("Drawing by Stephane Cabaraux")
    section: "sciences experiment"
    createdInVersion: 5000
}
