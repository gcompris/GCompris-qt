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
            "name": qsTr("Nouns"),
            "image": imagesPrefix + "alphabets.jpg",
            "categoryLesson": qsTr("A <b>noun</b> is a word which denotes person, place or thing.
We can class them in different categories.<br>
<b>1. Proper Nouns:</b> A proper noun is used for an individual person, place or orgization.<br>
<font color=\"#3bb0de\">blue</font> word is a personal pronoun in these cases:<br><font color=\"#3bb0de\"> Cloe</font> plays football.<br>
<font color=\"#3bb0de\">Dave</font> is honest.
<br><font color=\"#3bb0de\">Nile</font> is the name of a river.<br><br>
<b>2. Common Nouns:</b> A common noun refers to general people, place or things.
<br>The <font color=\"#3bb0de\">blue</font> word is a common noun in these cases: <br>Their <font color=\"#3bb0de\">teacher</font>was absent.<br>
<font color=\"#3bb0de\">Children</font> are playing outside.<br>
<font color=\"#3bb0de\">Milk</font>is good for health.<br><br>
<b>3. Countable nouns: </b>Countable nouns are people, places or things that can be counted.<br>
The <font color=\"#3bb0de\">blue</font> word is a countable noun in these cases: <br>I ate a<font color=\"#3bb0de\"> sandwich</font>.<br>
Is this <font color=\"#3bb0de\"> ball</font>yours?<br>
I bought some<font color=\"#3bb0de\">apples</font>.<br><br>
<b>4. Uncountable nouns: </b>Uncountable nouns are the things and substances that cannot be counted.<br>
The <font color=\"#3bb0de\">blue</font> word is a uncountable noun in these cases:<br>I have some<font color=\"#3bb0de\">money</font>.<br>
Do you like<font color=\"#3bb0de\"> rice</font>?<br>
I like listening<font color=\"#3bb0de\">music</font>.<br><br>
<b>5. Collective nouns: </b>A collective noun refers to collection of things taken as whole.<br>
The <font color=\"#3bb0de\">blue</font> word is a collective noun in these cases: <br>The dogs gathered the<font color=\"#3bb0de\">flock</font> of sheep.<br>
We bought our mother<font color=\"#3bb0de\">bouquet</font>of roses.<br>
The<font color=\"#3bb0de\">Crowd</font>cheered the team.<br><br>
<b>6. Abstract nouns: </b>Abstract nouns refer to an idea, quality or state.<br>
The <font color=\"#3bb0de\">blue</font> word is a abstract noun in these cases:<br>I <font color=\"#3bb0de\">love</font> my parents.<br>
We must never lose<font color=\"#3bb0de\">hope</font>.<br>
Children have a lot of<font color=\"#3bb0de\">curiousity</font>.<br><br>"),
            "content": [
                {
                    "instructions": qsTr("Place the PROPER NOUNS to the right and others to the left"),
                    "image": "Proper Nouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">James</font> is a good boy.","<font color=\"#3bb0de\">Agatha Christie</font> wrote many books.","<font color=\"#3bb0de\">Cleopetra</font> is a cute kitten.","I am craving <font color=\"#3bb0de\">Oreos.</font>","<font color=\"#3bb0de\">Wilson</font> threw the ball.","We are going to <font color=\"#3bb0de\">France.</font>"],
                    "bad": ["<font color=\"#3bb0de\">She</font> is a good girl.","They <font color=\"#3bb0de\">went</font> to buy furniture.","Cat is <font color=\"#3bb0de\">under</font> the table.","Bill went for <font color=\"#3bb0de\">shopping.</font>","She looks <font color=\"#3bb0de\">beautiful</font> in red dress.","They went for <font color=\"#3bb0de\">party.</font>"]
                },
                {
                    "instructions": qsTr("Place the PROPER NOUNS to the right and others to the left"),
                    "image": "Proper Nouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Pacific ocean</font> is the larget ocean.","<font color=\"#3bb0de\">Mango </font> is my favorite fruit.","<font color=\"#3bb0de\">Earth</font> revolves around the sun","<font color=\"#3bb0de\">Mount Everest</font> is the highest mountain.","<font color=\"#3bb0de\">India</font> is a nice country."],
                    "bad": ["John and I will play <font color=\"#3bb0de\">tennis.</font>","We are going <font color=\"#3bb0de\">outside.</font>","It's a <font color=\"#3bb0de\">nice</font> weather.","<font color=\"#3bb0de\">Exercises</font> keeps us fit."]
                },
                {
                    "instructions": qsTr("Place the PROPER NOUNS to the right and others to the left"),
                    "image": "Proper Nouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">James</font> is a good boy.","<font color=\"#3bb0de\">Agatha Christie</font> wrote many books.","<font color=\"#3bb0de\">Cleopetra</font> is a cute kitten.","I am craving <font color=\"#3bb0de\">Oreos.</font>","<font color=\"#3bb0de\">Wilson</font> threw the ball.","<font color=\"#3bb0de\">Nile</font> is the longest river in the world."],
                    "bad": ["Our <font color=\"#3bb0de\">team</font> won the match.","I don't have an <font color=\"#3bb0de\">umbrella.</font>","My <font color=\"#3bb0de\">dog</font> is not well."]
                },
                {
                    "instructions": qsTr("Place the COMMON NOUNS to the right and others to the left"),
                    "image": "Common Nouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["You broke my favorite <font color=\"#3bb0de\">mug</font>","They all are waiting for us at the <font color=\"#3bb0de\">restraunt.</font>","I want to travel to a big <font color=\"#3bb0de\">city.</font>","I bought a new pair of <font color=\"#3bb0de\">jeans.</font>","Call the <font color=\"#3bb0de\">police.</font>","The <font color=\"#3bb0de\">waiter</font> brought our food."],
                    "bad": ["I am going to see <font color=\"#3bb0de\">Dr. Ling.</font>","<font color=\"#3bb0de\">Karen</font> loves to eat.","<font color=\"#3bb0de\">Harry</font> went to the park.","Jim loves to <font color=\"#3bb0de\">eat.</font>","<font color=\"#3bb0de\">Frine</font> is a good restraunt.","He runs <font color=\"#3bb0de\">fast.</fast>"]
                },
                {
                    "instructions": qsTr("Place the COMMON NOUNS to the right and others to the left"),
                    "image": "Common Nouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["Sarah finally got her <font color=\"#3bb0de\">degree</font>","Tim and his <font color=\"#3bb0de\">brother</font> are on holidays.","Hary went to the <font color=\"#3bb0de\">park</font>","I like vegetarian <font color=\"#3bb0de\">food.</font>","I went to the <font color=\"#3bb0de\">dentist.</font>"],
                    "bad": ["<font color=\"#3bb0de\">Nick</font> got into flight","<font color=\"#3bb0de\">Football</font> is my favorite sport.","I like <font color=\"#3bb0de\">watching</font> T.V.","<font color=\"#3bb0de\">This</font> table is expensive.","The <font color=\"#3bb0de\">weather</font> is nice today."]
                },
                {
                    "instructions": qsTr("Place the COMMON NOUNS to the right and others to the left"),
                    "image": "Common Nouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["We're going to have <font color=\"#3bb0de\">fish</font> for dinner.","This <font color=\"#3bb0de\">book</font> is full of classic novels.","Dog is my favorite <font color=\"#3bb0de\">animal.</font>"],
                    "bad": ["I really love art by <font color=\"#3bb0de\">Van Gogh</font>.","<font color=\"#3bb0de\">Simy</font> bought me a dress.","I heard Bern going to <font color=\"#3bb0de\">Germany.</font>"]
                },
                {
                    "instructions": qsTr("Place the COUNTABLE NOUNS to the right and others to the left"),
                    "image": "Countable Nouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["The <font color=\"#3bb0de\">children</font> fell asleep quickly","The parade included fire <font color=\"#3bb0de\">trucks</font>","Michael can play several <font color=\"#3bb0de\">instruments.</font>","I love <font color=\"#3bb0de\">cookiees</font>.","We like the large <font color=\"#3bb0de\">bottles</font> of mineral water","I ate all the <font color=\"#3bb0de\">oranges.</font>"],
                    "bad": ["Would you like <font color=\"#3bb0de\">some chocolate?</font>","The table was made of <font color=\"#3bb0de\"> glass.</font>","John loves <font color=\"#3bb0de\">sports.</font>","I have <font color=\"#3bb0de\">alot of money.</font>","There is no <font color=\"#3bb0de\"> water</font> in the jug.","John <font color=\"#3bb0de\"> played</font> well."]
                },
                {
                    "instructions": qsTr("Place the COUNTABLE NOUNS to the right and others to the left"),
                    "image": "Countable Nouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["My <font color=\"#3bb0de\">dog</font> is playing.","I haven't got many <font color=\"#3bb0de\">pens.</font>","Mack has two <font color=\"#3bb0de\">cars</font>","She has two <font color=\"#3bb0de\">sisters.</font>","Those <font color=\"#3bb0de\">shoes</font> look old."],
                    "bad": ["There's no <font color=\"#3bb0de\">truth</font> in the rumours.","Would you like <font color=\"#3bb0de\">some coffee?</font>","My <font color=\"#3bb0de\">favorite</font> color is green.","Sun sets in the <font color=\"#3bb0de\">west.</font>"]
                },
                {
                    "instructions": qsTr("Place the COUNTABLE NOUNS to the right and others to the left"),
                    "image": "Countable Nouns",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["She brought a big <font color=\"#3bb0de\">suitcase.</font>","We went on a <font color=\"#3bb0de\">trip</font> to the Brazil."],
                    "bad": ["Most pottery is made of <font color=\"#3bb0de\">clay.</font>","Its <font color=\"#3bb0de\">raining</font> heavily.","The <font color=\"#3bb0de\">water</font> is deep.","This place <font color=\"#3bb0de\">was stuck</font> by an earthquake."]
                },
                {
                    "instructions": qsTr("Place the UNCOUNTABLE NOUNS to the right and others to the left"),
                    "image": "Unocuntable nouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["I love <font color=\"#3bb0de\">music.</font>","This <font color=\"#3bb0de\">news</font> is important.","I have got <font color=\"#3bb0de\">some money.</font>","Have you got any <font color=\"#3bb0de\">rice?</font>","He ate the <font color=\"#3bb0de\">cheese.</font>","I don't have much <font color=\"#3bb0de\">hair.</font>"],
                    "bad": ["I bought <font color=\"#3bb0de\">a toy.</font>","The teacher taught us <font color=\"#3bb0de\">a lesson.</font>","Jim was wearing a nice <font color=\"#3bb0de\">shirt.</font>","<font color=\"#3bb0de\">Rin</font> won the poetry competetion.","I have <font color=\"#3bb0de\">two pens</font>.","<font color=\"#3bb0de\">We</font> have two dogs."]
                },
                {
                    "instructions": qsTr("Place the UNCOUNTABLE NOUNS to the right and others to the left"),
                    "image": "Unocuntable nouns",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["It's difficult to work in <font color=\"#3bb0de\">noise.</font>","Have you got <font color=\"#3bb0de\">some paper?</font>","Do you have time for a cup of <font color=\"#3bb0de\">coffee?</font>","His <font color=\"#3bb0de\">advice</font> helped me."],
                    "bad": ["I have been playing <font color=\"#3bb0de\">since morning.</font>","<font color=\"#3bb0de\">They</font. did the job well.","We were <font color=\"#3bb0de\">watching</font> a basketball match.","I ate <font color=\"#3bb0de\">two mangoes.</font>","George <font color=\"#3bb0de\">completed</font> his work."]
                },
                {
                    "instructions": qsTr("Place the UNCOUNTABLE NOUNS to the right and others to the left"),
                    "image": "Unocuntable nouns",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 2,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Sugar</font> is bad for you.","I don't drink much <font color=\"#3bb0de\">coffee.</font>","I have a lot of <font color=\"#3bb0de\">work.</font>","<font color=\"#3bb0de\">Silence</font> is essential in libraries."],
                    "bad": ["We won the <font color=\"#3bb0de\">match.</font>","I ate all the <font color=\"#3bb0de\">cookies.</font>"]
                },
                {
                    "instructions": qsTr("Place the COLLECTIVE NOUNS to the right and others to the left"),
                    "image": "Collective nouns",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["Our <font color=\"#3bb0de\">class</font> took a field trip","We waited anxiously for the <font color=\"#3bb0de\">jury.</font>","Their basketball <font color=\"#3bb0de\">team</font> includes three players.","Napoleon’s <font color=\"#3bb0de\">army</font> was finally defeated at Waterloo.","The town <font color=\"#3bb0de\">council</font> has approved all plans.","He comes from a huge <font color=\"#3bb0de\">family.</font>"],
                    "bad": ["Use <font color=\"#3bb0de\">words</font> properly to be understood.","<font color=\"#3bb0de\">Close</font> the door.","I am <font color=\"#3bb0de\">going</font> to the barber.","Let's go <font color=\"#3bb0de\">dancing.</font>","We are going on <font color=\"#3bb0de\">vacation.</font>","The <font color=\"#3bb0de\">laundry</font> isn’t going to do itself."]
                },
                {
                    "instructions": qsTr("Place the COLLECTIVE NOUNS to the right and others to the left"),
                    "image": "Collective nouns",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["The <font color=\"#3bb0de\">senate</font> will be voting today.","All of the students are attending the school <font color=\"#3bb0de\">assembly.</font>","Everyone in the <font color=\"#3bb0de\">audience</font> applauded loudly ","The rock <font color=\"#3bb0de\">group</font> has been on tour for months."],
                    "bad": ["The <font color=\"#3bb0de\">dog</font> barked at the cat.","<font color=\"#3bb0de\">Throw</font> the ball.","<font color=\"#3bb0de\">Follow</font> the rules.","John started to <font color=\"#3bb0de\">run.</font>","<font color=\"#3bb0de\">Plato</font> was an influential Greek philosopher."]
                },
                {
                    "instructions": qsTr("Place the COLLECTIVE NOUNS to the right and others to the left"),
                    "image": "Collective nouns",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["The boat’s <font color=\"#3bb0de\">crew</font> worked all night","The <font color=\"#3bb0de\">team</font> celebrated heartily.","The boys decided to join the <font color=\"#3bb0de\">navy after graduation."],
                    "bad": ["<font color=\"#3bb0de\">Come</font> here","The <font color=\"#3bb0de\">restaurant</font> is open.","The judge gave his <font color=\"#3bb0de\">verdict.</font>"]
                },
                {
                    "instructions": qsTr("Place the ABSTRACT NOUNS to the right and others to the left"),
                    "image": "Abstract nouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "",
                    "good": ["I want to see <font color=\"#3bb0de\">justice</font> served.","We struck water at the <font color=\"#3bb0de\">depth</font> of twenty feet.","I want your <font color=\"#3bb0de\">goodwill.</font>","The <font color=\"#3bb0de\">length</font> of this road is just two miles.","<font color=\"#3bb0de\">Apprehension</font> is not good for health."],
                    "bad": ["This is <font color=\"#3bb0de\">John</font> speaking.","<font color=\"#3bb0de\">Terry</font> is taller than me","He <font color=\"#3bb0de\">drives</font> carefully.","It's terribly <font color=\"#3bb0de\">hot.</font>","<font color=\"#3bb0de\">Where</font> is Greg?","The <font color=\"#3bb0de\">dog</font> ran.","He plays <font color=\"#3bb0de\">tennis</font> well."]
                },
                {
                    "instructions": qsTr("Place the ABSTRACT NOUNS to the right and others to the left"),
                    "image": "Abstract nouns",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["My <font color=\"#3bb0de\">determination</font> is to get higher education.","If we <font color=\"#3bb0de\">persevere</font>, victory shall be ours.","There is <font color=\"#3bb0de\">uncertainty</font> in the final exam date.","I will <font color=\"#3bb0de\">surprise</font> my mom on her birthday.","Lots of <font color=\"#3bb0de\">pain</font> make us a real human being."],
                    "bad": ["The <font color=\"#3bb0de\">ball</font> is above the table.","Look over <font color=\"#3bb0de\">there.</font>","It's <font color=\"#3bb0de\">time</font> to go.","The driver <font color=\"#3bb0de\">stopped</font> the bus.","<font color=\"#3bb0de\">She</font> was walking rapidly."]
                },
                {
                    "instructions": qsTr("Place the ABSTRACT NOUNS to the right and others to the left"),
                    "image": "Abstract nouns",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["I worship to God daily which gives me <font color=\"#3bb0de\">strength.</font>","Helping others is the real <font color=\"#3bb0de\">joy</font> of life.","I <font color=\"#3bb0de\">hate</font> bad and lazy people"],
                    "bad": ["She <font color=\"#3bb0de\">arrived</font> early.","Have you done your <font color=\"#3bb0de\">homework?</font>","Are you coming <font color=\"#3bb0de\">tomorrow?"]
                }
            ]
        }
    ]
}
