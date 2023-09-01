/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
    name: "renewable_energy/RenewableEnergy.qml"
    difficulty: 4
    icon: "renewable_energy/renewable_energy.svg"
    author: "Sagar Chand Agarwal &lt;atomsagar@gmail.com&gt;"
    //: Activity title
    title: qsTr("Renewable energy")
    //: Help title
    description: qsTr("Tux has come back from fishing on his boat. Bring the electrical system back up so he can have light in his home.")
    //intro: "Click on the different stages that go to make up the power supply."
    //: Help goal
    goal: qsTr("Learn about an electrical system based on renewable energy.")
    //: Help manual
    manual: qsTr("Click on different active elements: sun, cloud, dam, solar array, wind farm and transformers, in order to reactivate the entire electrical system. When the system is back up and Tux is in his home, push the light button for him. To win you must switch on all the consumers while all the producers are up.")
    prerequisite: ""
    credit: ""
    section: "sciences experiment"
    createdInVersion: 5000
}
