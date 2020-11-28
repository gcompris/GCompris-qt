/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Your Name <yy@zz.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "chat/Chat.qml"
  difficulty: 3
  icon: "chat/chat.svg"
  author: "Bruno coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("Chat and draw with your friends")
  description: qsTr("This chat activity only works on the local network")
  goal: ""
  prerequisite: ""
  manual: qsTr("This chat activity will only work with other GCompris users on your local network, not on the Internet. To use it, just type in your message and hit Enter. Your message is then broadcast on the local network, and any GCompris program running the chat activity on that local network will receive and display your message.")
  credit: ""
  section: "/fun"
}
