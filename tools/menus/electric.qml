import GCompris 1.0

ActivityInfo {
  name: "electric/Electric.qml"
  difficulty: 5
  icon: "electric/electric.svg"
  author: "Bruno Coudoin <bruno.coudoin@gcompris.net>"
  demo: false
  title: qsTr("Electricity")
  description: qsTr("Create and simulate an electric schema")
  goal: qsTr("Freely create an electric schema with a real time simulation of it.")
  prerequisite: qsTr("Requires some basic understanding of the concept of electricity.")
  manual: qsTr("Drag electrical components from the selector and drop them in the working area. Create wires by clicking on a connection spot, dragging the mouse to the next connection spot, and letting go. You can also move components by dragging them. You can delete wires by clicking on them. To delete a component, select the deletion tool on top of the component selector. You can click on the switch to open and close it. You can change the rheostat value by dragging its wiper. In order to simulate what happens when a bulb is blown, you can blown it by right-clicking on it. The simulation is updated in real time by any user action.")
  credit: qsTr("GCompris uses the Gnucap electric simulator as a backend. You can get more information on gnucap at &lt;http://www.gnu.org/software/gnucap/&gt;.")
  section: "/experience"
}
