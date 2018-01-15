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
            "name": qsTr("Tenses"),
            "image": imagesPrefix + "alphabets.jpg",
            "categoryLesson": qsTr("A <b>tense</b> is a form taken by a verb to show the time of an action.<br>
<b>1. Simpe present tense: </b>It is used to describe habits, unchanging situations, general truths, and fixed arrangements.<br>
The <font color=\"#3bb0de\">blue</font> word is a simple present tense in these cases:<br>I <font color=\"#3bb0de\"> drink </font>milk everyday.<br>
He <font color=\"#3bb0de\">likes</font> mango.
<br>The exam <font color=\"#3bb0de\">starts</font> at 10:00.<br><br>
<b>2. Present continuous tense: </b>It is used to express a continued or ongoing action.
<br>The <font color=\"#3bb0de\">blue</font> word is a present continuous tense in these cases: <br>I am <font color=\"#3bb0de\">sleeping.</font><br>
They are<font color=\"#3bb0de\"> playing.</font><br>
John is <font color=\"#3bb0de\">driving</font> a car.<br><br>
<b>3. Present perfect tense: </b>It is used to express an action which happened at a short time before now.<br>
The <font color=\"#3bb0de\">blue</font> word is a present perfect tense in these cases: <br>She <font color=\"#3bb0de\">has learnt </font>the lesson.<br>
I <font color=\"#3bb0de\"> have eaten</font> my meal.<br>
They <font color=\"#3bb0de\">have gone</font> to school.<br><br>
<b>4. Simple past tense: </b>He ate<br>
The <font color=\"#3bb0de\">blue</font> word is a simple past tense in these cases:<br>They <font color=\"#3bb0de\">went </font>to the park.<br>
I <font color=\"#3bb0de\"> ate</font> an apple.<br>
Has it<font color=\"#3bb0de\">rained</font>.<br><br>
<b>5. Past continuous tense: </b>It is an ongoing action which occurred in past and completed at some point in past.<br>
The <font color=\"#3bb0de\">blue</font> word is a past continuous tense in these cases: <br>It <font color=\"#3bb0de\">was raining </font> yesterday.<br>
They <font color=\"#3bb0de\">were playing </font>football.<br>
They <font color=\"#3bb0de\">were laughing </font>at him.<br><br>
<b>6. Past perfect tense: </b>It is used to express an action which has occurred in past a long time ago and action which has occurred in past before another action in past. <br>
The <font color=\"#3bb0de\">blue</font> word is a past perfect tense in these cases:<br>A thief <font color=\"#3bb0de\">had stolen </font> my watch.<br>
He <font color=\"#3bb0de\">had slept</font>.<br>
He <font color=\"#3bb0de\">had not finished </font>his work.<br><br>
<b>1. Simpe future tense:</b>It is used to express time later than now, facts or certainty..<br>
<font color=\"#3bb0de\">blue</font> word is a simple future tense in these cases:<br>It <font color=\"#3bb0de\"> will rain </font>tomorrow.<br>
<font color=\"#3bb0de\">Shall I open</font> the window?
<br>I <font color=\"#3bb0de\">will go</font> for the show.<br><br>
<b>2. Future continuous tense:</b>It is used to express an unfinished action or event that will be in progress at a time later than now.
<br>The <font color=\"#3bb0de\">blue</font> word is a future continuous tense in these cases: <br><font color=\"#3bb0de\">Will he be coming</font>with us?<br>
You<font color=\"#3bb0de\"> will be missing </font>the sunshine once you go back.<br>
He<font color=\"#3bb0de\">will be ironing </font> my clothes in an hour.<br><br>
<b>3. Future perfect tense: </b>It is used to express an event that is expected or planned to happen before a time of reference in the future,<br>
The <font color=\"#3bb0de\">blue</font> word is a future perfect tense in these cases: <br>I <font color=\"#3bb0de\">will have seen </font>him.<br>
I <font color=\"#3bb0de\"> will have</font> eaten.<br>
I <font color=\"#3bb0de\">will have gone.</font><br><br>"),
            "content": [
                {
                    "instructions": qsTr("Place the SIMPLE PRESENT TENSE to the right and others to the left"),
                    "image": "Present Tense",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">wake</font> up.","We <font color=\"#3bb0de\">play</font> basketball.","The cinema <font color=\"#3bb0de\">closes</font> at 7pm.","We <font color=\"#3bb0de\">take</font> a taxi to work.","He <font color=\"#3bb0de\">gets</font> up early on Mondays."],
                    "bad": ["He <font color=\"#3bb0de\">woke</font> up.","<font color=\"#3bb0de\">I</font> am going.","George <font color=\"#3bb0de\">was studying</font>.","They <font color=\"#3bb0de\">went</font> to the party","I am not <font color=\"#3bb0de\">playing</font>.","We <font color=\"#3bb0de\">did</font> our homework.","He <font color=\"#3bb0de\">is learning</font> French."]
                },
                {
                    "instructions": qsTr("Place the SIMPLE PRESENT TENSE to the right and others to the left"),
                    "image": "Present Tense",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">like</font> pizza.","When do you <font color=\"#3bb0de\">wake up</font>?","She <font color=\"#3bb0de\">lives</font> in India.","I don't <font color=\"#3bb0de\">believe</font> in witches.","We <font color=\"#3bb0de\">go</font> for swimming everyday."],
                    "bad": ["She <font color=\"#3bb0de\">bought</font> a new dress.","We <font color=\"#3bb0de\">went</font> to the church.","Jim <font color=\"#3bb0de\">completed</font> my work.","It is <font color=\"#3bb0de\">raining</font>."]
                },
                {
                    "instructions": qsTr("Place the SIMPLE PRESENT TENSE to the right and others to the left"),
                    "image": "Present Tense",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">drink</font> milk daily.","Sun <font color=\"#3bb0de\">rises</font> in the east.","I go for <font color=\"#3bb0de\">walk</font> every morning."],
                    "bad": ["We <font color=\"#3bb0de\">won</font> the match.","I am <font color=\"#3bb0de\">listening</font> music.","We <font color=\"#3bb0de\">cooked</font> the meal"]
                },
                {
                    "instructions": qsTr("Place the PRESENT CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Present Continuous Tense",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">am going</font>.","He <font color=\"#3bb0de\">is playing</font>.","She <font color=\"#3bb0de\">is riding</font>.","I <font color=\"#3bb0de\">am loving</font>.","They <font color=\"#3bb0de\">are eating</font>.","He <font color=\"#3bb0de\">is sinking</font>."],
                    "bad": ["I <font color=\"#3bb0de\">went</font> for a walk.","We play <font color=\"#3bb0de\">football</font>.","She <font color=\"#3bb0de\">saw</font> him.","<font color=\"#3bb0de\">Roger</font> was busy.","Tim was <font color=\"#3bb0de\">the</font> winner.","We <font color=\"#3bb0de\">ate</font> the meal."]
                },
                {
                    "instructions": qsTr("Place the PRESENT CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Present Continuous Tense",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">am going</font> to the market.","It <font color=\"#3bb0de\">is raining</font>.","They <font color=\"#3bb0de\">are studying</font>.","We <font color=\"#3bb0de\">are playing</font> for 2 hours.","I <font color=\"#3bb0de\">am leaving</font> work"],
                    "bad": ["I <font color=\"#3bb0de\">have lost</font> my keys.","She <font color=\"#3bb0de\">went</font> shopping","I <font color=\"#3bb0de\">will help</font> you.","This is my <font color=\"#3bb0de\">cat</font>."]
                },
                {
                    "instructions": qsTr("Place the PRESENT CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Present Continuous Tense",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["They <font color=\"#3bb0de\">are sleeping</font>.","He is always <font color=\"#3bb0de\">laughing</font>.","<font color=\"#3bb0de\">What</font> are you doing?"],
                    "bad": ["He <font color=\"#3bb0de\">had been playing</font> since morning.","It <font color=\"#3bb0de\">was</font> a good day.","I <font color=\"#3bb0de\">love</font> to read."]
                },
                {
                    "instructions": qsTr("Place the PRESENT PERFECT WORDS to the right and others to the left"),
                    "image": "Present Perfect Tense",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["He <font color=\"#3bb0de\">has gone</font>.","She <font color=\"#3bb0de\">has eaten</font>.","He <font color=\"#3bb0de\">has done</font>.","I <font color=\"#3bb0de\">have eaten</font>.","He <font color=\"#3bb0de\">has shown</font>","He <font color=\"#3bb0de\">has slept</font>."],
                    "bad": ["I <font color=\"#3bb0de\">am sleeping</font>.","He <font color=\"#3bb0de\">is upset</font>.","They <font color=\"#3bb0de\">were talking</font>.","<font color=\"#3bb0de\">Milk</font> is good for health.","It is sunny <font color=\"#3bb0de\">outside</font>.","Cat is <font color=\"#3bb0de\">under</font> the table."]
                },
                {
                    "instructions": qsTr("Place the PRESENT PERFECT WORDS to the right and others to the left"),
                    "image": "Present Perfect Tense",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Have</font> you <font color=\"#3bb0de\">slept</font>?","She <font color=\"#3bb0de\">has eaten</font>.","He <font color=\"#3bb0de\">has done</font>,","I <font color=\"#3bb0de\">have eaten</font>.","He <font color=\"#3bb0de\">has shown</font>."],
                    "bad": ["I <font color=\"#3bb0de\">am busy</font>.","He is my best <font color=\"#3bb0de\">friend</font>.","The <font color=\"#3bb0de\">dog</font> is hungry.","<font color=\"#3bb0de\">Today</font> is sunny.","I <font color=\"#3bb0de\">am dreaming</font>.","I had a <font color=\"#3bb0de\">mamgo</font>."]
                },
                {
                    "instructions": qsTr("Place the PRESENT PERFECT WORDS to the right and others to the left"),
                    "image": "Present Perfect Tense",
                    "maxNumberOfGood": 2,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">have just finished</font> my work.","He <font color=\"#3bb0de\">has read</font> that book."],
                    "bad": ["He had not eaten his meal.","I have been playing since morning.","I like apples.","He is running."]
                },
                {
                    "instructions": qsTr("Place the PAST TENSE WORDS to the right and others to the left"),
                    "image": "Past Tense",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["He <font color=\"#3bb0de\">went</font> to the school.","I <font color=\"#3bb0de\">played</font> cricket.","I <font color=\"#3bb0de\">did</font> my work.","He <font color=\"#3bb0de\">ate</font> a sandwich.","I <font color=\"#3bb0de\">loved</font> music.","She <font color=\"#3bb0de\">drank</font> the juice."],
                    "bad": ["The <font color=\"#3bb0de\">ball</font> is under the table.","We are <font color=\"#3bb0de\">friends</font>.","I <font color=\"#3bb0de\">like</font> his work.","He <font color=\"#3bb0de\">loves</font> pizza.","I <font color=\"#3bb0de\">like</font> GCompris.","I am <font color=\"#3bb0de\">afraid</font> of lizard."]
                },
                {
                    "instructions": qsTr("Place the PAST TENSE WORDS to the right and others to the left"),
                    "image": "Past Tense",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["We <font color=\"#3bb0de\">met</font> him.","I <font color=\"#3bb0de\">did</font> my job.","We <font color=\"#3bb0de\">saw</font> a good film yesterday.","She <font color=\"#3bb0de\">finished</font> her work.","He <font color=\"#3bb0de\">played</font> the piano."],
                    "bad": ["I <font color=\"#3bb0de\">am reading</font> this book.","The red <font color=\"#3bb0de\">kitten</font> is mine.","I <font color=\"#3bb0de\">am playing</font> soccer.","I <font color=\"#3bb0de\">like</font> his work."]
                },
                {
                    "instructions": qsTr("Place the PAST TENSE WORDS to the right and others to the left"),
                    "image": "Past Tense",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 2,
                    "prefix": "",
                    "good": ["He <font color=\"#3bb0de\">went</font> to the school.","I <font color=\"#3bb0de\">played</font> cricket.","I <font color=\"#3bb0de\">did</font> my work.","He <font color=\"#3bb0de\">ate</font> a sandwich."],
                    "bad": ["The glass is <font color=\"#3bb0de\">on</font> the table.","Today is his <font color=\"#3bb0de\">birthday</font>."]
                },
                {
                    "instructions": qsTr("Place the PAST CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["We <font color=\"#3bb0de\">were going</font>.","I <font color=\"#3bb0de\">was playing</font>.","He <font color=\"#3bb0de\">was doing</font> his work.","He <font color=\"#3bb0de\">was running</font>.","I <font color=\"#3bb0de\">was drinking</font> milk.","I <font color=\"#3bb0de\">was eating</font> cookies."],
                    "bad": ["I <font color=\"#3bb0de\">am playing</font>.","I <font color=\"#3bb0de\">ate</font> my food.","I <font color=\"#3bb0de\">bought</font> vegetables.","I <font color=\"#3bb0de\">had been sleeping</font> since morning.","I <font color=\"#3bb0de\">am cooking</font>.","He <font color=\"#3bb0de\">sells</font> vegetables."]
                },
                {
                    "instructions": qsTr("Place the PAST CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["It <font color=\"#3bb0de\">was raining</font>.","They <font color=\"#3bb0de\">were swimming</font>.","<font color=\"#3bb0de\">Were</font> they <font color=\"#3bb0de\">laughing</font>?","<font color=\"#3bb0de\">Was</font> she crying</font>?"],
                    "bad": ["I <font color=\"#3bb0de\">am singing</font> at the concert.","They <font color=\"#3bb0de\">won</font> the match.","We <font color=\"#3bb0de\">are washing</font> clothes.","I <font color=\"#3bb0de\">had</font> a fish.","I <font color=\"#3bb0de\">don't eat</font> spinach."]
                },
                {
                    "instructions": qsTr("Place the PAST CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["We <font color=\"#3bb0de\">were walking</font>.","They <font color=\"#3bb0de\">were climbing</font> a hill.","She <font color=\"#3bb0de\">was not working</font>."],
                    "bad": ["We <font color=\"#3bb0de\">climbed</font> the mountain.","I <font color=\"#3bb0de\">am driving</font> a car.","I <font color=\"#3bb0de\">love</font> music."]
                },
                {
                    "instructions": qsTr("Place the PAST PERFECT WORDS to the right and others to the left"),
                    "image": "Past perfect Tense",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["We <font color=\"#3bb0de\">had swum</font>.","They <font color=\"#3bb0de\">had played</font> voleyball.","When they arrived, we <font color=\"#3bb0de\">had already started</font> cooking. ","<font color=\"#3bb0de\">Had</font> they <font color=\"#3bb0de\">arrived</font>?","The train <font color=\"#3bb0de\">had just left</font> when I arrived.","We <font color=\"#3bb0de\">had had</font> that car for ten years."],
                    "bad": ["I <font color=\"#3bb0de\">like</font> his work.","He <font color=\"#3bb0de\">loves</font> pizza.","I like <font color=\"#3bb0de\">GCompris</font>.","I am <font color=\"#3bb0de\">afraid</font> of lizard.","He is <font color=\"#3bb0de\">busy>/font> today.","I <font color=\"#3bb0de\">will go</font> there tomorrow."]
                },
                {
                    "instructions": qsTr("Place the PAST PERFECT WORDS to the right and others to the left"),
                    "image": "Past Perfect Tense",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["She <font color=\"#3bb0de\">had never seen</font> a bear.","He <font color=\"#3bb0de\">had not slept</font> well.","My car <font color=\"#3bb0de\">had been repaird</font> by John.","I <font color=\"#3bb0de\">had cleaned</font> it off the door."],
                    "bad": ["She is a <font color=\"#3bb0de\">good</font> dancer.","We <font color=\"#3bb0de\">are going</font> for his birthday.","We <font color=\"#3bb0de\">are tired</font>.","I <font color=\"#3bb0de\">like</font> the sunrise.","We <font color=\"#3bb0de\">go for running</font> everyday."]
                },
                {
                    "instructions": qsTr("Place the PAST PERFECT WORDS to the right and others to the left"),
                    "image": "Past Perfect Tense",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["The show <font color=\"#3bb0de\">had started</font> before we arrived.","I wish I <font color=\"#3bb0de\">had not been</font> so late.","I <font color=\"#3bb0de\">had eaten</font> my dinner before time."],
                    "bad": ["They <font color=\"#3bb0de\">lost</font> their way.","We <font color=\"#3bb0de\">will play</font> handball.","He <font color=\"#3bb0de\">works</font> hard."]
                },
                {
                    "instructions": qsTr("Place the SIMPLE FUTURE WORDS to the right and others to the left"),
                    "image": "Simple future Tense",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 7,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">will buy</font> a computer.","<font color=\"#3bb0de\">Will you go</font> to visit him?","It <font color=\"#3bb0de\">will rain</font> tonight.","I <font color=\"#3bb0de\">shall play</font> football.","I <font color=\"#3bb0de\">will watch</font> the film"],
                    "bad": ["I <font color=\"#3bb0de\">am going</font> for a walk.","<font color=\"#3bb0de\">Can I</font> help you?","It is so <font color=\"#3bb0de\">cold</font>.","Stop <font color=\"#3bb0de\">fighting</font>!","He is a <font color=\"#3bb0de\">doctor</font>.","I <font color=\"#3bb0de\">am not</font> well","The <font color=\"#3bb0de\">clothes</font> are dirty."]
                },
                {
                    "instructions": qsTr("Place the SIMPLE FUTURE WORDS to the right and others to the left"),
                    "image": "Simple future Tense",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["<font color=\"#3bb0de\">Will</font> you <font color=\"#3bb0de\">help</font> him?","<font color=\"#3bb0de\">Will</font> you <font color=\"#3bb0de\">cook</font> food?","John <font color=\"#3bb0de\">will finish</font> the work.","I <font color=\"#3bb0de\">will get</font> it.","I <font color=\"#3bb0de\">won't go</font> alone."],
                    "bad": ["<font color=\"#3bb0de\">Could you open</font> the door?","I <font color=\"#3bb0de\">don't open</font> the door.","<font color=\"#3bb0de\">He</font> has a headache.","We <font color=\"#3bb0de\">are going</font> in the car."]
                },
                {
                    "instructions": qsTr("Place the SIMPLE FUTURE WORDS to the right and others to the left"),
                    "image": "Simple future Tense",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">shall wash</font> the clothes.","I <font color=\"#3bb0de\">will eat</font> fish.","I <font color=\"#3bb0de\">will get</font> you some tea."],
                    "bad": ["<font color=\"#3bb0de\">It</font> is 6:30.","I <font color=\"#3bb0de\">am good</font> at tennis.","<font color=\"#3bb0de\">When</font> did you come?"]
                },,
                {
                    "instructions": qsTr("Place the FUTURE CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">will not be waiting</font> for you.","He <font color=\"#3bb0de\">will not flying</font> a kite.","It <font color=\"#3bb0de\">will be raining</font> tomorrow.","They <font color=\"#3bb0de\">won't be watching</font> T.V.","What <font color=\"#3bb0de\">will you be doing</font>?","She <font color=\"#3bb0de\">will not be sleeping</font>."],
                    "bad": ["Are you <font color=\"#3bb0de\">dancing</font>?","I am at <font color=\"#3bb0de\">park</font>.","<font color=\"#3bb0de\">Which</font> one is your car?","<font color=\"#3bb0de\">These</font> are my shoes.","<font color=\"#3bb0de\">She</font> is my sister.","<font color=\"#3bb0de\">Where</font> were you born?."]
                },
                {
                    "instructions": qsTr("Place the FUTURE CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 4,
                    "maxNumberOfBad": 5,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">will be baking</font> a cake.","<font color=\"#3bb0de\">Will you be going</font> to market?","She <font color=\"#3bb0de\">will be having</font> a bath.","John <font color=\"#3bb0de\">won't be sleeping</font> now."],
                    "bad": ["You can <font color=\"#3bb0de\">do it</font>.","We <font color=\"#3bb0de\">study</font> every afternoon.","<font color=\"#3bb0de\">This</font> is my car.","How <font color=\"#3bb0de\">old</font> are you?"]
                },
                {
                    "instructions": qsTr("Place the FUTURE CONTINUOUS WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["I am going <font color=\"#3bb0de\">to be throwing</font> a party.","I <font color=\"#3bb0de\">will be hosing off</font> my car.","He <font color=\"#3bb0de\">will be working</font>."],
                    "bad": ["You <font color=\"#3bb0de\">did great</font>.","<font color=\"#3bb0de\">Don't</font> give up.","<font color=\"#3bb0de\">Where</font> does he live?"]
                },
                {
                    "instructions": qsTr("Place the FUTURE PERFECT WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 6,
                    "maxNumberOfBad": 6,
                    "prefix": "",
                    "good": ["I <font color=\"#3bb0de\">will have finished</font> this book.","She <font color=\"#3bb0de\">will have cooked</font> food.","It <font color=\"#3bb0de\">will have stopped</font> raining","<font color=\"#3bb0de\">Will it have</font> got colder?","<font color=\"#3bb0de\">Will we have watched</font> the film?","When <font color=\"#3bb0de\">will you have finished</font>?"],
                    "bad": ["He <font color=\"#3bb0de\">accepted</font> the job","<font color=\"#3bb0de\">What</font> does he work?","How is the <font color=\"#3bb0de\">food</font> here?","Let me <font color=\"#3bb0de\">solve</font> this problem.","","He <font color=\"#3bb0de\">sells</font> vegetables."]
                },
                {
                    "instructions": qsTr("Place the FUTUR PERFECT WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 5,
                    "maxNumberOfBad": 4,
                    "prefix": "",
                    "good": ["When <font color=\"#3bb0de\">will you have read</font> the book?","We <font color=\"#3bb0de\">will have cleaned</font> the house.","John <font color=\"#3bb0de\">will have eaten</font> the cake.","The train <font color=\"#3bb0de\">will have left</font>.","The guests <font color=\"#3bb0de\">will have arrived</font>."],
                    "bad": ["What <font color=\"#3bb0de\">are you listening</font> to?","I <font color=\"#3bb0de\">can't ride</font> a bike","The <font color=\"#3bb0de\">sky</font> is blue.","<font color=\"#3bb0de\">Tomorrow</font> is Monday."]
                },
                {
                    "instructions": qsTr("Place the FUTURE PERFECT WORDS to the right and others to the left"),
                    "image": "Past Continuous Tense",
                    "maxNumberOfGood": 3,
                    "maxNumberOfBad": 3,
                    "prefix": "",
                    "good": ["She is going to <font color=\"#3bb0de\">have had</font> my book.","I <font color=\"#3bb0de\">will have been</font> in London.","They <font color=\"#3bb0de\">will have completed</font> the project."],
                    "bad": ["These cushions are <font color=\"#3bb0de\">new</font>.","I <font color=\"#3bb0de\">have</font> my exam tomorrow.","The <font color=\"#3bb0de\">baby</font> is smiling."]
                }
            ]
        }
    ]
}
