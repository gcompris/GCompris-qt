
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
            "name": qsTr("Adverbs"),
            "categoryLesson": qsTr("An <b>adverb</b> is a word that modifies a verb, adjective, another adverb, determiner, noun phrase, clause, or sentence.
We can class them in different categories.<br>
<b>1. Adverbs of frequency:</b> It is a word which tells us how often something happens.<br>
The <font color=\"#3bb0de\">blue</font> word is an adverb of frequency in these cases:<br>I drink water<font color=\"#3bb0de\">alot</font>.<br>
<font color=\"#3bb0de\">Occasionally</font> I drink coffee.
<br>I <font color=\"#3bb0de\">never </font> go out.<br><br>
<b>2. Adverbs of time:</b> It is a word which tells when an action happened.
<br>The <font color=\"#3bb0de\">blue</font> word is an adverb of time in these cases: <br>I have to leave <font color=\"#3bb0de\"> now</font>.<br>
I will do the work <font color=\"#3bb0de\"> later</font>.<br>
They are on a vacation for <font color=\"#3bb0de\"> a week</font>.<br><br>
<b>3. Adverbs of place: </b>It is a word which tells us where an action happens.<br>
The <font color=\"#3bb0de\">blue</font> word is an adverb of place in these cases: <br>My house is<font color=\"#3bb0de\"> nearby</font>.<br>
Put that book <font color=\"#3bb0de\"> here</font>.<br>
Did you go <font color=\"#3bb0de\"> there</font>?<br><br>
<b>4. Adverbs of manner: </b>It is a word which tells us the way an action happens.<br>
The <font color=\"#3bb0de\">blue</font> word is adverbs of manner in these cases:<br>She writes <font color=\"#3bb0de\">neatly</font>.<br>
Eat <font color=\"#3bb0de\"> healthily</font>.<br>
He dressed <font color=\"#3bb0de\">hurriedly</font>.<br><br>
<b>5. Adverbs of degree: </b>It is a word which tells the intensity of an action.<br>
The <font color=\"#3bb0de\">blue</font> word is an adverb of degree in these cases: <br>He is <font color=\"#3bb0de\">too</font>slow.<br>
He didn't work hard <font color=\"#3bb0de\">enough</font>.<br>
I am <font color=\"#3bb0de\">too</font> short.<br><br>"
            ),
            "image": imagesPrefix + "alphabets.jpg",
            "content": [
                {
                    "instructions": qsTr("Place the ADVERBS OF FREQUENCY to the right and others to the left"),
                    "image": "Adverbs of frequency",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["He is <font color=\"#3bb0de\">often</font> late for work.","We should brush<font color=\"#3bb0de\">daily</font>.","John is <font color=\"#3bb0de\">never</font> for late.","When do you <font color=\"#3bb0de\">usually</font> go for walk?","We went for a walk <font color=\"#3bb0de\">yesterday</font>.","We go for swimming <font color=\"#3bb0de\">twice a week</font>."],
                    "bad": ["He is <font color=\"#3bb0de\">generous</font>","She is a <font color=\"#3bb0de\">great </font> player.","It is <font color=\"#3bb0de\">too</font> hot.","They are <font color=\"#3bb0de\">playing</font>.","It is <font color=\"#3bb0de\">sunny</font> today.","I was <font color=\"#3bb0de\">just</font> leaving."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF FREQUENCY to the right and others to the left"),
                    "image": "Adverbs of frequency",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["I have <font color=\"#3bb0de\">never</font>.","I don't <font color=\"#3bb0de\">usually </font> give advice.","I <font color=\"#3bb0de\">always </font> study after class.","I <font color=\"#3bb0de\">seldom</font> put salt on my food.","I often <font color=\"#3bb0de\">read</font> at night."],
                    "bad": ["<font color=\"#3bb0de\">Do</font> you know him?","We will go <font color=\"#3bb0de\">tomorrow</font>.","He wakes up <font color=\"#3bb0de\">early</font>.","Did you play <font color=\"#3bb0de\"yesterday</font>?"]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF FREQUENCY to the right and others to the left"),
                    "image": "Adverbs of frequency",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">normally</font> go to gym.","I <font color=\"#3bb0de\">always</font> do my work,","Have you <font color=\"#3bb0de\">ever </font> been to France?"],
                    "bad": ["We are moving <font color=\"#3bb0de\">westwards</font>.","Is it cold <font color=\"#3bb0de\">enough</font>?.","They <font color=\"#3bb0de\">often </font> play volleyball."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF TIME to the right and others to the left"),
                    "image": "Adverbs of time",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["I go for a walk <font color=\"#3bb0de\">daily</font>.","I am going  <font color=\"#3bb0de\">tomorrow</font>.","We go out for movie <font color=\"#3bb0de\">weekly</font>.","He had his exam<font color=\"#3bb0de\">yesterday</font>.","Lunch has <font color=\"#3bb0de\">already </font> been served.","They <font color=\"#3bb0de\">still</font> live there."],
                    "bad": ["I am <font color=\"#3bb0de\">tired</font>.","They went to <font color=\"#3bb0de\">buy</font> a cake.","You are <font color=\"#3bb0de\">intelligent</font>.","I am playing <font color=\"#3bb0de\">since </font>morning.","The dog is <font color=\"#3bb0de\">hungry</font>.","I <font color=\"#3bb0de\">just </font> went to sleep."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF TIME to the right and others to the left"),
                    "image": "Adverbs of time",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["He <font color=\"#3bb0de\">still</font> has not finished his work.","Are you coming <font color=\"#3bb0de\">tomorrow</font>.","John went to the market <font color=\"#3bb0de\">yesterday</font>.","I have <font color=\"#3bb0de\">never </font> went to France."],
                    "bad": ["We are <font color=\"#3bb0de\">studying</font>.","The girl <font color=\"#3bb0de\">ran</font>.","<font color=\"#3bb0de\">She </font> bought apples.","<font color=\"#3bb0de\">They</font> did the work."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF TIME to the right and others to the left"),
                    "image": "Adverbs of time",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["Do it <font color=\"#3bb0de\">now</font>.","He got up <font color=\"#3bb0de\">early</font>.","This magazine is published <font color=\"#3bb0de\">monthly</font>."],
                    "bad": ["I do my work <font color=\"#3bb0de\">regularly</font>.","He drinks milk<font color=\"#3bb0de\">everyday</font>.","<font color=\"#3bb0de\">We</font> studied maths."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF PLACE to the right and others to the left"),
                    "image": "Adverbs of place",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["Put the food <font color=\"#3bb0de\">there</font>.","My house is <font color=\"#3bb0de\">nearby</font>.","I am going <font color=\"#3bb0de\">out</font>.","Are you going <font color=\"#3bb0de\">outside</font>?","This ship sails <font color=\"#3bb0de\">eastwards</font>.","The dog ran <font color=\"#3bb0de\">towards </font>me."],
                    "bad": ["<font color=\"#3bb0de\">Usually </font> I get up early.","I am <font color=\"#3bb0de\">going </font> to dentist.","He <font color=\"#3bb0de\">played r</font> well.","I <font color=\"#3bb0de\">carefully </font> placed the egg.","I <font color=\"#3bb0de\">often</font> read at night.","I hardly <font color=\"#3bb0de\">ever </font> get angry."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF PLACE to the right and others to the left"),
                    "image": "Adverbs of place",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["The sun rises from <font color=\"#3bb0de\">East</font>.","He walked <font color=\"#3bb0de\">towards </font> me.","I kicked the ball <font color=\"#3bb0de\">around.</font>","I looked <font color=\"#3bb0de\">everywhere </font> for my watch.","It is rather hot <font color=\"#3bb0de\">in here</font>."],
                    "bad": ["We played <font color=\"#3bb0de\">yesterday</font>.","He sang <font color=\"#3bb0de\">loudly</font>.","Please sit <font color=\"#3bb0de\">here</font>.","Do you know <font color=\"#3bb0de\">him</font>."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF PLACE to the right and others to the left"),
                    "image": "Adverbs of place",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["They are <font color=\"#3bb0de\">behind</font> us.","We were waiting <font color=\"#3bb0de\">outside</font>."],
                    "bad": ["The <font color=\"#3bb0de\">Earth </font>is a planet.","I <font color=\"#3bb0de\">won</font> the race.","<font color=\"#3bb0de\">Where</font> are you going."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF MANNER to the right and others to the left"),
                    "image": "Adverbs of manner",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["He ran <font color=\"#3bb0de\">quickly</font>.","He <font color=\"#3bb0de\">gently </font> woke me up.","Walk <font color=\"#3bb0de\">quickly</font>.","Listen <font color=\"#3bb0de\">carefully </font> to learn.","Don't play music <font color=\"#3bb0de\">loudly</font>.","A tortoise walks <font color=\"#3bb0de\">slowly</font>."],
                    "bad": ["<font color=\"#3bb0de\">What </font> is your name?","The cat is <font color=\"#3bb0de\">under</font> the table.","I ate <font color=\"#3bb0de\">an</font>apple.","I am going <font color=\"#3bb0de\">tomorrow</font>.","I did the work <font color=\"#3bb0de\">myself</font>.","He is brushing <font color=\"#3bb0de\">his</font> teeth."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF MANNER to the right and others to the left"),
                    "image": "Adverbs of manner",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["I worked <font color=\"#3bb0de\">hard</font>.","The food was <font color=\"#3bb0de\">delicious</font>.","The dog barks<font color=\"#3bb0de\">loudly</font>.","I speak English <font color=\"#3bb0de\">fluently</font>.","I often sleep <font color=\"#3bb0de\">late</font>."],
                    "bad": ["He <font color=\"#3bb0de\">likes</font> hamburger.","Ben <font color=\"#3bb0de\">writes</font> beautifully.","They <font color=\"#3bb0de\">won</font> the match.","It is a <font color=\"#3bb0de\">nice</font> movie."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF MANNER to the right and others to the left"),
                    "image": "Adverbs of manner",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["The train arrived <font color=\"#3bb0de\">late</font>.","He can drive <font color=\"#3bb0de\">fast</font>.","They <font color=\"#3bb0de\">carefully </font> read the notice."],
                    "bad": ["They <font color=\"#3bb0de\">went</font> home.","This is <font color=\"#3bb0de\">my</font> dog.","I am <font color=\"#3bb0de\">playing</font>."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF DEGREE to the right and others to the left"),
                    "image": "Adverbs of degree",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["We <font color=\"#3bb0de\">almost</font> finished the work.","The food is <font color=\"#3bb0de\">absolutely </font> delicious.","The dress was big <font color=\"#3bb0de\">enough </font> for me.","The coffee was <font color=\"#3bb0de\">too</font> hot.","He walked <font color=\"#3bb0de\">very</font> quickly."],
                    "bad": ["He <font color=\"#3bb0de\">lost</font> his dog.","Jone <font color=\"#3bb0de\">danced </font>all night.","The rabbit <font color=\"#3bb0de\">hopped</font>.","He <font color=\"#3bb0de\">speaks</font> good English.","Mom <font color=\"#3bb0de\">ironed</font>  my clothes.","<font color=\"#3bb0de\">They</font> are cooking food."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF DEGREE to the right and others to the left"),
                    "image": "Adverbs of degree",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["She <font color=\"#3bb0de\">rarely</font> enjoys the game.","I am <font color=\"#3bb0de\">just</font> leaving.","The water was <font color=\"#3bb0de\">extremely </font> cold.","They <font color=\"#3bb0de\">hardly</font> noticed me.","The test was <font color=\"#3bb0de\">too </font> difficult."],
                    "bad": ["I <font color=\"#3bb0de\">read</font> this book.","He <font color=\"#3bb0de\">topped</font> the class.","I played <font color=\"#3bb0de\">tennis</font>.","He <font color=\"#3bb0de\">likes</font>yellow  color."]
                },
                {
                    "instructions": qsTr("Place the ADVERBS OF DEGREE to the right and others to the left"),
                    "image": "Adverbs of degree",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["We enjoyed the film <font color=\"#3bb0de\">immensely</font>.","Is this car fast <font color=\"#3bb0de\">enough</font>?","The film is <font color=\"#3bb0de\">too</font> long."],
                    "bad": ["What is <font color=\"#3bb0de\">your</font> name.","The dishes are <font color=\"#3bb0de\">washed</font> by him.","The students are <font color=\"#3bb0de\">taught </font>well."]
                }
            ]
        }
    ]
}
