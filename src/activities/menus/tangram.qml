import GCompris 1.0

ActivityInfo {
  name: "tangram/Tangram.qml"
  difficulty: 1
  icon: "tangram/tangram.svg"
  author: "Yves Combe /  Philippe Banwarth"
  demo: true
  title: qsTr("The tangram puzzle game")
  description: qsTr("The objective is to form a given shape with seven pieces")
  goal: qsTr("From Wikipedia, the free encyclopedia. Tangram (Chinese: literally 'seven boards of cunning') is a Chinese puzzle. While the tangram is often said to be ancient, its existence has only been verified as far back as 1800. It consists of 7 pieces, called tans, which fit together to form a square; taking the square as the unit:
	* 5 right isosceles triangles
		o 2 small (legs of 1)
		o 1 medium size (legs of square root of 2)
		o 2 large size (legs of 2)
	* 1 square (side of 1)
	* 1 parallelogram (sides of 1 and square root of 2)")
  prerequisite: qsTr("Mouse-manipulation")
  manual: qsTr("Select the tangram to form. Move a piece by dragging it. Right-click on it to create a symmetrical item. Select an item and drag around it to show the rotation you want. Once you've shown what shape you want, the computer will create it. If you need help, click on the shape button, and the border of the shape will be drawn.")
  credit: qsTr("The original code was written by Philippe Banwarth in 1999. It was ported to GCompris by Yves Combe in 2005.")
}
