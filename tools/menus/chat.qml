/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Your Name <yy@zz.org>
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
