/* gcompris - AlphabetSequence.qml

 Copyright (C)
 2014 Bruno Coudoin: initial version

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import "qrc:/gcompris/src/activities/planegame"

Planegame {

    dataset: [
        qsTr("a b c d e f g h i j k l m n o p q r s t u v w x y z").split(" "),
        qsTr("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z").split(" ")
    ]
}
