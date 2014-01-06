import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "administration"
  dir: "src/activities/administration"
  difficulty: 0
  icon: "menus/"
  author: ""
  demo: false
  title: qsTr("GCompris Administration Menu")
  description: qsTr("Left-Click with the mouse to select an activity")
  goal: qsTr("If you want to fine tune GCompris to your needs, you can use the administration module here. The ultimate goal is to provide child-specific reporting for parents and teacher who want to monitor the progress, strengths and needs of their children.")
  prerequisite: ""
  manual: qsTr("- In the 'Boards' section you can change the list of activities. Just untoggle them in the treeview. You can change the language used for reading, for example, then the language used for saying the names of colors.
- You can save multiple configurations, and switch between them easily. In the 'Profile' section add a profile, then in the 'Board' section select the profile in the combobox, then select the boards you want to be active. You can add multiple profiles, with different lists of boards, and different languages. You set the default profile in the 'Profile' section, by choosing the profile you want, then clicking on the 'Default' button. You can also choose a profile from the command line.
- You can add users, classes and for each class, you can create groups of users. Note that you can import users from a comma-separated file. Assign one or more groups to a profile, after which those new logins will appear after restarting GCompris. Being able to identify individual children in GCompris means we can provide individual reports. It also recognizes the children as individuals; they can learn to type in and recognize their own usernames (login is configurable).")
  credit: ""
}
