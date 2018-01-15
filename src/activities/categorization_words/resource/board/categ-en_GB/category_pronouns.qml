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
            "name": qsTr("Pronouns"),
            "categoryLesson": qsTr("A <b>pronoun</b> is a word which replaces other words to avoid repetition.
We can class them in different categories.<br>
<b>1. Personal pronouns:</b> A personal pronoun is a word which replaces a person or an object.<br>
The <font color=\"#3bb0de\">blue</font> word is personal pronoun in these cases:<br><font color=\"#3bb0de\"> I</font> go to swim.<br>
<font color=\"#3bb0de\">He</font> is intelligent.
<br><font color=\"#3bb0de\">They</font> are tired.<br><br>
<b>2. Reflexive Pronouns:</b> A reflexive pronoun is used when the object of a sentence is the same as the subject.
<br>The <font color=\"#3bb0de\">blue</font> word is reflexive pronoun in these cases: <br>They cooked <font color=\"#3bb0de\"> themselves</font>.<br>
We did the job <font color=\"#3bb0de\"> ourselves</font>.<br>
I bought the fruits <font color=\"#3bb0de\"> myself</font>.<br><br>
<b>3. Possessive pronouns: </b>A possessive pronoun is a little word used to indicate possesion.<br>
The <font color=\"#3bb0de\">blue</font> word is possesive pronoun in these cases: <br>This book is <font color=\"#3bb0de\"> mine</font><br>
Is this ball <font color=\"#3bb0de\"> yours</font>?<br>
He lost <font color=\"#3bb0de\"> his</font> pen.<br><br>
<b>4. Demonstrative pronouns: </b>A demonstrative pronoun points somebody or something in a phrase and replaces it.<br>
The <font color=\"#3bb0de\">blue</font> word is demonstrative pronoun in these cases:<br><font color=\"#3bb0de\"> This</font> is my book.<br>
I ate <font color=\"#3bb0de\"> those</font> apples.<br>
<font color=\"#3bb0de\"> That</font> place is far away.<br><br>
<b>5. Indefinite Pronouns: </b>A indefinite pronoun refers to non-specific beings, objects, or places.<br>
The <font color=\"#3bb0de\">blue</font> word is indefinite pronoun in these cases: <br><font color=\"#3bb0de\"> Everyone</font> was late.<br>
<font color=\"#3bb0de\">Someone</font> stole my pen.<br>
<font color=\"#3bb0de\">Either</font> will do.<br><br>
<b>6. Relative pronouns: </b>A relative pronoun is used to connect a relative clause to the main clause in a sentence.<br>
The <font color=\"#3bb0de\">blue</font> word is relative pronoun in these cases:<br>I ate the fruits <font color=\"#3bb0de\">that</font> I bought yesterday.<br>
I am looking for someone <font color=\"#3bb0de\">who</font> can help me.<br>
This is the park <font color=\"#3bb0de\">where</font> they will come.<br><br>
<b>7.Interrogative pronoun:</b> A interrogative pronoun is a word which is used to ask a question.<br>
The <font color=\"#3bb0de\">blue</font> word is interrogative pronoun in these cases: <br><font color=\"#3bb0de\">Whose</font> eraser is this?<br>
<font color=\"#3bb0de\">Which</font> your favorite team?<br>
<font color=\"#3bb0de\">Where</font> were you?"
            ),
            "image": imagesPrefix + "alphabets.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the PERSONAL PRONOUNS to the right and others to the left"),
                    "image": "Personal Pronouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">I</font> study maths.","<font color=\"#3bb0de\">We</font> play football","<font color=\"#3bb0de\">It</font> is raining.","<font color=\"#3bb0de\">They</font> speak English.","<font color=\"#3bb0de\">She</font> is eating.","<font color=\"#3bb0de\">You</font> were sleeping."],
                    "bad": ["<font color=\"#3bb0de\">Who</font> was reading?","<font color=\"#3bb0de\">Daniel</font> was playing.","<font color=\"#3bb0de\">George</font> went outside.","Do it <font color=\"#3bb0de\">yourself</font>.","The <font color=\"#3bb0de\">blue</font> car.","Some <font color=\"#3bb0de\">milk</font> is left."]
                },
                {
                    "instructions": qsTr("Place the PERSONAL PRONOUNS to the right and others to the left"),
                    "image": "Personal Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">It's</font> getting late.","<font color=\"#3bb0de\">He</font> loves football","<font color=\"#3bb0de\">I</font> am writing.","<font color=\"#3bb0de\">We</font> were laughing.","<font color=\"#3bb0de\">They</font> didn't play."],
                    "bad": ["<font color=\"#3bb0de\">Whose</font> pen is it?","<font color=\"#3bb0de\">John</font> went.","The <font color=\"#3bb0de\">door</font> was open.","Who <font color=\"#3bb0de\">went</font> to school yesterday?"]
                },
                {
                    "instructions": qsTr("Place the PERSONAL PRONOUNS to the right and others to the left"),
                    "image": "Personal Pronouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">It's</font> snowing","Do <font color=\"#3bb0de\">you</font> need help?","Have <font color=\"#3bb0de\">you</font> seen him today?"],
                    "bad": ["<font color=\"#3bb0de\">When</font> is the meeting?","His <font color=\"#3bb0de\">work</font> was complete.","<font color=\"#3bb0de\">Where's</font> the pencil"]
                },
                {
                    "instructions": qsTr("Place the REFLEXIVE PRONOUNS to the right and others to the left"),
                    "image": "Reflexive Pronouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["She did the work <font color=\"#3bb0de\">herself</font>","Can you talk to him <font color=\"#3bb0de\">yourself</font>?","The door opened <font color=\"#3bb0de\">itself</font>","I made the food <font color=\"#3bb0de\">myself</font>","You should do your work <font color=\"#3bb0de\">yourself</font>","I saw <font color=\"#3bb0de\">myself</font> in the mirror."],
                    "bad": ["<font color=\"#3bb0de\">Who</font> cooked the food?","<font color=\"#3bb0de\">They</font> were laughing.","<font color=\"#3bb0de\">John</font> played.","I read a <font color=\"#3bb0de\">book</font>.","She bought <font color=\"#3bb0de\">fruits</font>.","A <font color=\"#3bb0de\">wonderful</font> old clock."]
                },
                {
                    "instructions": qsTr("Place the REFLEXIVE PRONOUNS to the right and others to the left"),
                    "image": "Reflexive Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["We painted the wall <font color=\"#3bb0de\">ourselves</font>","Do your work <font color=\"#3bb0de\">yourself</font>.","The door opened <font color=\"#3bb0de\">itself</font>.","She saved <font color=\"#3bb0de\">herself</font>.","They looked after <font color=\"#3bb0de\">themselves</font>."],
                    "bad": ["I have <font color=\"#3bb0de\">some</font> friends.","Would <font color=\"#3bb0de\">you</font> like some bread.","She <font color=\"#3bb0de\">ate</font> all apples.","<font color=\"#3bb0de\">He</font> did his job."]
                },
                {
                    "instructions": qsTr("Place the REFLEXIVE PRONOUNS to the right and others to the left"),
                    "image": "Reflexive Pronouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["We blamed <font color=\"#3bb0de\">ourselves</font>.","Did you hurt <font color=\"#3bb0de\">yourself?</font>","They looked after <font color=\"#3bb0de\">themselves</font>."],
                    "bad": ["He <font color=\"#3bb0de\">writes</font> properly.","He didn't drink <font color=\"#3bb0de\">milk</font>.","<font color=\"#3bb0de\">We</font> studied maths."]
                },
                {
                    "instructions": qsTr("Place the POSSESSIVE PRONOUNS to the right and others to the left"),
                    "image": "Possessive Pronouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["This is <font color=\"#3bb0de\">her</font> birthday.","Its <font color=\"#3bb0de\">your</font> ball.","This is <font color=\"#3bb0de\">my</font> cat.","She bought <font color=\"#3bb0de\">her</font> a dress.","He lost <font color=\"#3bb0de\">his</font> watch.","The black dress is <font color=\"#3bb0de\">mine</font>."],
                    "bad": ["<font color=\"#3bb0de\">He</font> writes properly.","She <font color=\"#3bb0de\">cooks</font> well","I am a <font color=\"#3bb0de\">singer</font>","I <font color=\"#3bb0de\">lost</font> my book","<font color=\"#3bb0de\">They</font> gifted me a watch","I love <font color=\"#3bb0de\">swimming</font>"]
                },
                {
                    "instructions": qsTr("Place the POSSESSIVE PRONOUNS to the right and others to the left"),
                    "image": "Possessive Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["The bag is <font color=\"#3bb0de\">theirs.</font>","I liked <font color=\"#3bb0de\">his</font> singing.","Susan is a friend of <font color=\"#3bb0de\">mine.</font>","<font color=\"#3bb0de\">His</font> name was Alex.","<font color=\"#3bb0de\">Their</font> eyes were paining."],
                    "bad": ["<font color=\"#3bb0de\">He</font> writes poems.","<font color=\"#3bb0de\">They</font> play volleyball.","We <font color=\"#3bb0de\">cooked</font> meal.","Its raining <font color=\"#3bb0de\">outside.</font>"]
                },
                {
                    "instructions": qsTr("Place the POSSESSIVE PRONOUNS to the right and others to the left"),
                    "image": "Possessive Pronouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["He took <font color=\"#3bb0de\">his</font> pen.","The dog wagged <font color=\"#3bb0de\">his</font> tail.","<font color=\"#3bb0de\">My</font> car is bigger."],
                    "bad": ["He loves <font color=\"#3bb0de\">nature</font>.","They <font color=\"#3bb0de\">played</font> well.","<font color=\"#3bb0de\">George</font> is singing."]
                },
                {
                    "instructions": qsTr("Place the DEMONSTRATIVE PRONOUNS to the right and others to the left"),
                    "image": "Demonstrative Pronouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">This</font> tastes good.","<font color=\"#3bb0de\">That</font> is beautiful.","<font color=\"#3bb0de\">That</font> book is good.","I'll buy <font color=\"#3bb0de\">these</font>.","Is <font color=\"#3bb0de\">this</font> yours?","<font color=\"#3bb0de\">That</font> is incorrect."],
                    "bad": ["He <font color=\"#3bb0de\">was</font> running.","<font color=\"#3bb0de\">I</font> drank milk.","They <font color=\"#3bb0de\">complained.</font>","We <font color=\"#3bb0de\">did</font> well.","I did the work <font color=\"#3bb0de\">myself</font>.","He brushes <font color=\"#3bb0de\">his</font> teeth."]
                },
                {
                    "instructions": qsTr("Place the DEMONSTRATIVE PRONOUNS to the right and others to the left"),
                    "image": "Demonstrative Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["I wanted <font color=\"#3bb0de\">that.</font>","Is <font color=\"#3bb0de\">that</font> Jim?","I own <font color=\"#3bb0de\">those.</font>","Did you see <font color=\"#3bb0de\">this</font>?","I read <font color=\"#3bb0de\">this</font> book."],
                    "bad": ["He <font color=\"#3bb0de\">swims.</font>","Ben <font color=\"#3bb0de\">writes</font> beautifully.","<font color=\"#3bb0de\">They</font> won the match.","<font color=\"#3bb0de\">We</font> sco#3bb0de well in exams."]
                },
                {
                    "instructions": qsTr("Place the DEMONSTRATIVE PRONOUNS to the right and others to the left"),
                    "image": "Demonstrative Pronouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">These</font> are blue pens.","<font color=\"#3bb0de\">This</font> is an apple.","<font color=\"#3bb0de\">Those</font> were my fruits."],
                    "bad": ["<font color=\"#3bb0de\">They</font> went home.","The #3bb0de pen was <font color=\"#3bb0de\">mine.</font>","<font color=\"#3bb0de\">I</font> am sleeping."]
                },
                {
                    "instructions": qsTr("Place the INDEFINITE PRONOUNS to the right and others to the left"),
                    "image": "Indefinite Pronouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Somebody</font> ate my sandwich.","<font color=\"#3bb0de\">None</font> is interested.","<font color=\"#3bb0de\">Everyone</font> played football.","<font color=\"#3bb0de\">Either</font> choice has its advantages.","I don't know <font color=\"#3bb0de\">any</font> of the answers.","<font color=\"#3bb0de\">Everything</font> happens for a reason."],
                    "bad": ["<font color=\"#3bb0de\">He</font> lost his dog.","Jone likes listening <font color=\"#3bb0de\">music.</font>","She <font color=\"#3bb0de\">is</font> a dancer.","He speaks <font color=\"#3bb0de\">good</font> English.","Mom has went to market.","<font color=\"#3bb0de\">I</font> am cooking food."]
                },
                {
                    "instructions": qsTr("Place the INDEFINITE PRONOUNS to the right and others to the left"),
                    "image": "Indefinite Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Everybody</font> enjoyed the concert.","<font color=\"#3bb0de\">Nobody</font> came.","<font color=\"#3bb0de\">Anyone</font> can play this game.","<font color=\"#3bb0de\">Very few</font> came for the class.","<font color=\"#3bb0de\">All</font> were late for the party."],
                    "bad": ["<font color=\"#3bb0de\">Sun</font> rises from east.","I <font color=\"#3bb0de\">drive</font> car.","They lost <font color=\"#3bb0de\">their</font> keys","He loves <font color=\"#3bb0de\">yellow</font> color."]
                },
                {
                    "instructions": qsTr("Place the INDEFINITE PRONOUNS to the right and others to the left"),
                    "image": "Indefinite Pronouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Everyone</font> enjoyed the food.","Is <font color=\"#3bb0de\">anyone</font> available today?","<font color=\"#3bb0de\">Few</font> came to the wedding."],
                    "bad": ["<font color=\"#3bb0de\">They</font> won the contest.","<font color=\"#3bb0de\">An apple</font> a day keeps doctor away.","We went <font color=\"#3bb0de\">on</font> holidays."]
                },
                {
                    "instructions": qsTr("Place the RELATIVE PRONOUNS to the right and others to the left"),
                    "image": "Relative pronouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["The <font color=\"#3bb0de\">car</font> which I drive is old","This is not the icecream<font color=\"#3bb0de\">that</font>I like.","That's the dog <font color=\"#3bb0de\">who</font> doesn't like me.","The man <font color=\"#3bb0de\">who</font> I saw was a thief.","<font color=\"#3bb0de\">These</font> are some books which I love.","<font color=\"#3bb0de\">This</font> is the place where I ate lunch."],
                    "bad": ["These are not <font color=\"#3bb0de\">my</font> shoes.","<font color=\"#3bb0de\">Did</font> you hear her poem?","<font color=\"#3bb0de\">Jim</font> works slow.","I didn't <font color=\"#3bb0de\">go</font> to the party.","<font color=\"#3bb0de\">I</font> love pizza.","<font color=\"#3bb0de\">This</font> is my computer."]
                },
                {
                    "instructions": qsTr("Place the RELATIVE PRONOUNS to the right and others to the left"),
                    "image": "Relative pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["The car <font color=\"#3bb0de\">which</font> hit me was yellow.","The car <font color=\"#3bb0de\">that</font> I drive is old.","<font color=\"#3bb0de\">This</font> is the cake that I baked.","I will open <font color=\"#3bb0de\">whichever</font> package arrives fast.","The person <font color=\"#3bb0de\">who</font> called me is my best friend."],
                    "bad": ["His <font color=\"#3bb0de\">shoes</font> are dirty.","<font color=\"#3bb0de\">He</font> drives slow.","I completed my work <font color=\"#3bb0de\">myself.</font>","The <font color=\"#3bb0de\">class</font> passed the test."]
                },
                {
                    "instructions": qsTr("Place the RELATIVE PRONOUNS to the right and others to the left"),
                    "image": "Relative pronouns",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["Katie, <font color=\"#3bb0de\">who</font> is very kind is my friend","<font color=\"#3bb0de\">Whoever</font> spilled the milk will have to clean it."],
                    "bad": ["<font color=\"#3bb0de\">It</font> was sunny.","She went to the <font color=\"#3bb0de\">doctor.</font>","That's my <font color=\"#3bb0de\">umbrella.</font>","I bought a <font color=\"#3bb0de\">new</font> dog."]
                },
                {
                    "instructions": qsTr("Place the INTERROGATIVE PRONOUNS to the right and others to the left"),
                    "image": "Interrogative Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Who</font> will design the logo?","<font color=\"#3bb0de\">Whose</font> pen is it?","<font color=\"#3bb0de\">What</font> will you do there?","<font color=\"#3bb0de\">Whom</font> did you ask the details?","<font color=\"#3bb0de\">Which</font> place is it?"],
                    "bad": ["<font color=\"#3bb0de\">I</font> play guitar.","They like <font color=\"#3bb0de\">watching</font> movies.","<font color=\"#3bb0de\">He</font> topped the class.","<font color=\"#3bb0de\">Sun</font> sets in the west.","Exercises keep fit.","<font color=\"#3bb0de\">Phil</font> is a good boy.","<font color=\"#3bb0de\">Diana</font> is my best friend."]
                },
                {
                    "instructions": qsTr("Place the INTERROGATIVE PRONOUNS to the right and others to the left"),
                    "image": "Interrogative Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Which</font> is your favorite color?","<font color=\"#3bb0de\">Whose</font> pen is this?","<font color=\"#3bb0de\">What</font> is your name?","<font color=\"#3bb0de\">What</font> are you talking about?","<font color=\"#3bb0de\">Whose</font> camera is this?"],
                    "bad": ["I play <font color=\"#3bb0de\">alone.</font>","<font color=\"#3bb0de\">This</font> is my book.","<font color=\"#3bb0de\">They</font> played well.","I <font color=\"#3bb0de\">am going.</font>"]
                },
                {
                    "instructions": qsTr("Place the INTERROGATIVE PRONOUNS to the right and others to the left"),
                    "image": "Interrogative Pronouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Who</font> won the race?","<font color=\"#3bb0de\">Whom</font> shall we ask?","<font color=\"#3bb0de\">Which</font> of these do you prefer?"],
                    "bad": ["He went to the <font color=\"#3bb0de\">stadium.</font>","Do <font color=\"#3bb0de\">you</font> play?","<font color=\"#3bb0de\">She</font> is dancing."]
                }
            ]
        }
    ]
}

