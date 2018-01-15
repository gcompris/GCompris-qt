
/* GCompris
 *
 * Copyright (C) 2016 Divyam Madaan <divyam3897@gmail.com>
 *
 * Authors:
 *   Divyam Madaan <divyam3897@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0

QtObject {
    property bool isEmbedded: true
    property bool allowExpertMode: true
    property string imagesPrefix: "qrc:/gcompris/src/activities/categorization/resource/images/alphabets/"
    property variant levels: [
        {
            "name": qsTr("Verbs"),
            "categoryLesson": qsTr("A <b>verb</b> is a word which conveys action, an occurrence, or a state of being.<br>
<b>1. Transitive verbs:</b> A A transitive verb is a verb followed by a noun or noun phrase.<br>
The <font color=\"#3bb0de\">blue</font> word is transitive verb in these cases:<br>I <font color=\"#3bb0de\">read </font> a newspaper.<br>
She <font color=\"#3bb0de\">listens</font> music.
<br>I <font color=\"#3bb0de\">washed </font>the car.<br><br>
<b>2. Instransitive verbs:</b> An intransitive verb is a verb that does not have a direct object.
<br>The <font color=\"#3bb0de\">blue</font> word is intransitive verb in these cases: <br>They <font color=\"#3bb0de\"> cooked</font>.<br>
The bus <font color=\"#3bb0de\"> stopped</font>.<br>
That <font color=\"#3bb0de\"> smells</font>.<br><br>"
            ),
            "image": imagesPrefix + "alphabets.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the TRANSITIVE VERBS to the right and others to the left"),
                    "image": "Personal Pronouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["I<font color=\"#3bb0de\">admire you</font>.","He <font color=\"#3bb0de\">loves</font> music.","Everyone <font color=\"#3bb0de\">wished</font> him.","They<font color=\"#3bb0de\">gave</font> me this book.","He<font color=\"#3bb0de\">eats</font> cookies.","John<font color=\"#3bb0de\">saw</font> an eagle."],
                    "bad": ["<font color=\"#3bb0de\">Who</font> was reading?","<font color=\"#3bb0de\">Daniel</font> was playing.","<font color=\"#3bb0de\">George</font> went outside.","Do it <font color=\"#3bb0de\">yourself</font>.","The <font color=\"#3bb0de\">blue</font> car.","Some <font color=\"#3bb0de\">milk</font> is left."]
                },
                {
                    "instructions": qsTr("Place the TRANSITIVE VERBS to the right and others to the left"),
                    "image": "Personal Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">baked</font> the cake.","He<font color=\"#3bb0de\">drove</font> the car.","They<font color=\"#3bb0de\">moved</font> the table.","John<font color=\"#3bb0de\"> wrote</font> a poem.","She<font color=\"#3bb0de\"> painted</font> the canvas."],
                    "bad": ["<font color=\"#3bb0de\">Whose</font> pen is it?","<font color=\"#3bb0de\">John</font> went.","The <font color=\"#3bb0de\">door</font> was open.","Who <font color=\"#3bb0de\">went</font> to school yesterday?"]
                },
                {
                    "instructions": qsTr("Place the TRANSITIVE VERBS to the right and others to the left"),
                    "image": "Personal Pronouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">want </font> a chocolate.","They <font color=\"#3bb0de\">sang</font> a song.","He <font color=\"#3bb0de\">drove</font> the car."],
                    "bad": ["<font color=\"#3bb0de\">When</font> is the meeting?","His <font color=\"#3bb0de\">work</font> was complete.","<font color=\"#3bb0de\">Where's</font> the pencil"]
                },
                {
                    "instructions": qsTr("Place the INTRANSITIVE VERBS to the right and others to the left"),
                    "image": "Reflexive Pronouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["She <font color=\"#3bb0de\">cried</font>","I <font color=\"#3bb0de\">laughed</font>.","The book <font color=\"#3bb0de\">fell</font>.","The sun <font color=\"#3bb0de\">set</font>.","He <font color=\"#3bb0de\">sang.</font>","He <font color=\"#3bb0de\">ran</font>."],
                    "bad": ["<font color=\"#3bb0de\">Who</font> cooked the food?","<font color=\"#3bb0de\">They</font> were laughing.","<font color=\"#3bb0de\">John</font> played.","I read a <font color=\"#3bb0de\">book</font>.","She bought <font color=\"#3bb0de\">fruits</font>.","A <font color=\"#3bb0de\">wonderful</font> old clock."]
                },
                {
                    "instructions": qsTr("Place the INTRANSITIVE VERBS to the right and others to the left"),
                    "image": "Reflexive Pronouns",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["They <font color=\"#3bb0de\">drove</font>.","I <font color=\"#3bb0de\">make</font>.","They <font color=\"#3bb0de\">draw</font>.","The stars <font color=\"#3bb0de\">twinkled</font>."],
                    "bad": ["I have <font color=\"#3bb0de\">some</font> friends.","Would <font color=\"#3bb0de\">you</font> like some bread.","She <font color=\"#3bb0de\">ate</font> all apples.","<font color=\"#3bb0de\">He</font> did his job."]
                },
                {
                    "instructions": qsTr("Place the INTRANSITIVE VERBS to the right and others to the left"),
                    "image": "Reflexive Pronouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["The bus <font color=\"#3bb0de\">stopped.</font>.","He <font color=\"#3bb0de\">died</font>."],
                    "bad": ["He <font color=\"#3bb0de\">writes</font> properly.","He didn't drink <font color=\"#3bb0de\">milk</font>.","<font color=\"#3bb0de\">We</font> studied maths."]
                }
            ]
        }
    ]
}

