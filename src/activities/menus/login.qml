import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
  name: "login"
  dir: "src/activities/login"
  difficulty: 0
  icon: "menus/"
  author: ""
  demo: true
  title: qsTr("GCompris login screen")
  description: qsTr("Select or enter your name to log in to GCompris")
  goal: qsTr("GCompris identifies each child, so we can provide child-specific reports.")
  prerequisite: ""
  manual: qsTr("In order to activate the login screen, you must
first add users in the administration part of GCompris.
You access Administration by running 'gcompris -a'.
In Administration, you can create different profiles. In each profile,
you can have a different set of users and select which activities are available to them.
To run GCompris for a specific profile, you use 'gcompris -p profile' where 'profile'
is the name of a profile as you created it in Administration.")
  credit: ""
}
