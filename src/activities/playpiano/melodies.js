/* GCompris - melodies.js
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
 **/

function get() {
    return [
             {
                 "title": "Twinkle Twinkle Little Star",
                 "_origin": qsTr("America: English Lullaby"),
                 "lyrics": "Twinkle, twinkle, little star, how I wonder what you are; Up above the world so high, like a diamond in the sky. Twinkle, twinkle, little star, how I wonder what you are.",
                 "melody": "treble C4 C4 G4 G4 A4 A4 G2 F4 F4 E4 E4 D4 D4 C2 G4 G4 F4 F4 E4 E4 D2 G4 G4 F4 F4 E4 E4 D2 C4 C4 G4 G4 A4 A4 G2 F4 F4 E4 E4 D4 D4 C1"
             },
             {
                 "title": "Yankee Doodle",
                 "_origin": qsTr("America: Patriotic"),
                 "lyrics": "Yankee Doodle went to town, Riding on a pony; He stuck a feather in his hat, And called it macaroni",
                 "melody": "treble G8 G8 A8 B8 G8 B8 A4 G8 G8 A8 B8 G4 F#4 G8 G8 A8 B8 2C8 B8 A8 G8 F#8 D8 E8 F#8 G4 G4"
             },
             {
                 "title": "Simple Gifts",
                 "_origin": qsTr("America: Shaker Tune"),
                 "lyrics": "Tis the gift to be simple, 'tis the gift to be free, 'tis the gift to come down where we ought to be. And when we find ourselves in the place just right, 'Twill be in the valley of love and delight.",
                 "melody": "treble C8 C8 F4 F8 G8 A8 F8 A8 Bb8 2C4 2C8 Bb8 A4 G8 F8 G4 C4 G4 F4 G8 A8 G8 E8 C4 C4 F8 E8 F8 G8 A4 G8 G8 A4 Bb4 2C4 A4 G4 G8 G8 A4 A8 G8 F4 F8 F8 F2"
             },
             {
                 "title": "Old MacDonald Had a Farm",
                 "_origin": qsTr("America: Nursery Rhyme"),
                 "lyrics": "Old MacDonald had a farm, EE-I-EE-I-O, And on that farm he had a [animal name], EE-I-EE-I-O",
                 "melody": "bass G4 G4 G4 D4 E4 E4 D2 B4 B4 A4 A4 G2 D2 G4 G4 G4 D4 E4 E4 D2 B4 B4 A4 A4 G1"
             },
             {
                 "title": "Un elefante se balanceaba",
                 "_origin": qsTr("Mexico"),
                 "lyrics": "Un elefante se columpiaba sobre la tela de una araña. Como veia que resistía fue a llamar a otro elefante",
                 "melody": "treble g4 g8 g8 e4 e4 g4 g8 g8 e4 e4 g4 g8 g8 a8 g8 f8 e8 f2 d2 f4 f8 f8 d4 d4 f4 f8 f8 d4 d4 f4 f8 f8 g8 f8 e8 d8 e2 c2"
             },
             {
                 "title": "Piove, Piove",
                 "_origin": qsTr("Italy"),
                 "lyrics": "Piove, piove. La gatta non si muove. La fiamma traballa. La mucca è nella stalla. La mucca ha il vitello. La pecora ha l’agnello. [La chioccia ha il pulcino.] Ognuno ha il suo bambino. Ognuno ha la sua mamma. E tutti fanno nanna!",
                 "melody": "treble E8 G4 G8 A8 G4 G8 E8 G8 G8 G8 A8 G4 G8 E8 G8 G8 G8 A8 G4 G8 E8 G8 G8 G8 A8 G4 G8 E8 G2 E8 G2 E8 G8 A8 G8 E8 G2"
             },
             {
                 "title": "Que llueva, que llueva",
                 "_origin": qsTr("Spain"),
                 "lyrics": "Que llueva, que llueva. La Virgen de la Cueva. Los pajaritos cantan, Las nubes se levantan. ¡Que sí, que no, que caiga un chaparrón! Que siga lloviendo, Los pájaros corriendo. Florezca la pradera. Al sol de la primavera....",
                 "melody": "treble E8 G4 G8 A8 G4 G8 E8 G8 G8 G8 A8 G4 G8 E8 G8 G8 G8 A8 G4 G8 E8 G8 G8 G8 A8 G4 G8 E8 G2 E8 G2 E8 G8 A8 G8 E8 G2"
             },
             {
                 "title": "Backe, backe Kuchen",
                 "_origin": qsTr("German Kid's Song"),
                 "lyrics": "Backe, backe, Kuchen Der Bäcker hat gerufen! Wer will guten Kuchen backen Der muß haben sieben Sachen: Eier und Schmalz Butter und Salz Milch und Mehl/Safran macht den Kuchen gehl!Schieb, schieb in´n Ofen ´nein.",
                 "melody": "treble A4 A4 B4 B4 A2 F#4 D4 A4 A4 B4 B4 A2 F#2 A4 A4 B4 B4 A4 A4 F#4 D4 A4 A4 B4 B4 A4 A4 F#4 F#4 A8 A8 A4 F#2 A8 A8 A4 F#2 A4 A4 F#2"
             },
             {
                 "title": "Se essa rua fosse minha",
                 "_origin": qsTr("Children's Song from Brazil"),
                 "lyrics": "Se essa rua Se essa rua fosse minha Eu mandava Eu mandava ladrilhar Com pedrinhas Com pedrinhas de brilhante Só pra ver Só pra ver meu bem passar Nessa rua Nessa rua tem um bosque Que se chama Que se chama solidão...",
                 "melody": "treble E8 E8 A8 A8 E8 C8 A8 C8 F8 E8 E4 D4 E8 E8 B8 B8 F8 E8 G#8 E8 C8 B8 A2 A8 A8 Bb8 A8 E8 C#8 A8 G8 F8 E8 G8 F8 E8 D8 E4 B8 G#8 E8 D8 C8 B8 A2"
             },
             {
                 "title": "Fuchs du hast die Gans gestohlen",
                 "_origin": qsTr("German"),
                 "lyrics": "Fuchs, du hast die Gans gestohlen, gib sie wieder her, gib sie wieder her! Sonst wird dich der Jäger holen, mit dem Schießgewehr! Sonst wird dich der Jäger holen, mit dem Schießgewehr!",
                 "melody": "treble D4 E4 F#4 G4 A4 A4 A4 A4 B4 G4 2D4 B4 A1 B4 G4 2D4 B4 A1 A4 G4 G4 G4 G4 F#4 F#4 F#4 F#4 E4 F#4 E4 D4 F#4 A2"
             },
             {
                 "title": "Un éléphant qui se balançait",
                 "_origin": qsTr("France"),
                 "lyrics": "Un éléphant qui se balançait\nSur une toile toile toile\nToile d'araignée\nIl trouvait ça tellement amusant\nQu'il alla chercher un\nDeuxième éléphant.",
                 "melody": "treble g4 g8 g8 e4 e4 g4 g8 g8 e4 e4 g4 g8 g8 a8 g8 f8 e8 f2 d2 f4 f8 f8 d4 d4 f4 f8 f8 d4 d4 f4 f8 f8 g8 f8 e8 d8 e2 c2"
             },
             {
                 "title": "Alle Meine Entchen",
                 "_origin": qsTr("Germany"),
                 "lyrics": "Alle meine Entchen schwimmen auf dem See, schwimmen auf dem See, Köpfchen in das Wasser, Schwänzchen in die Höh'.",
                 "melody": "treble C8 D8 E8 F8 G4 G4 A8 A8 A8 A8 G2 A8 A8 A8 A8 G2 F8 F8 F8 F8 E4 E4 D8 D8 D8 G8 C2"
             },
             {
                 "title": "À la claire fontaine",
                 "_origin": qsTr("France"),
                 "lyrics": "À la claire fontaine\nM'en allant promener\nJ'ai trouvé l'eau si belle\nQue je m'y suis baigné\nIl y a longtemps que je t'aime\nJamais je ne t'oublierai.",
                 "melody": "treble G4 G8 B8 B8 A8 B8 B8 G4 G8 B8 B8 A8 B4 B4 B8 A8 G8 B8 2D8 B8 2D4 2D8 B8 G8 B8 A2 G2 G4 B4 B4 A8 G8 B4 G4 B2 B4 A8 G8 B4 A4 G1"
             },
             {
                 "title": "O Cravo e a Rosa",
                 "_origin": qsTr("Brazil"),
                 "lyrics": "O Cravo brigou com a Rosa Debaixo de uma sacada O Cravo ficou ferido E a Rosa despedaçada O Cravo ficou doente A Rosa foi visitar O Cravo teve um desmaio A Rosa pôs-se a chorar",
                 "melody": "treble G4 G4 E4 2C8 B8 A8 G4 F2 A4 A4 F4 2C8 B8 A8 G4 G2 G4 2C4 2C4 2C8 2D8 2C8 B4 A2 A4 G4 B2 A8 F8 D8 C4"
             },
             {
                 "title": "Marcha Soldado",
                 "_origin": qsTr("Brazil"),
                 "lyrics": "Marcha soldado Cabeça de papel Se não marchar direito Vai preso pro quartel O quartel pegou fogo A polícia deu sinal Acode acode acode A bandeira nacional",
                 "melody": "treble G4 G8 E8 C4 C8 E8 G8 G8 G8 E8 D2 E8 F8 F8 F8 D8 G4 G8 A8 G8 F8 E8 D8 C2"
             },
             {
                 "title": "Frère jacques",
                 "_origin": qsTr("France"),
                 "lyrics": "Frère Jacques\nFrère Jacques\nDormez-vous ?\nDormez-vous ?\nSonnez les matines\nSonnez les matines\nDing ding dong\nDing ding dong",
                 "melody": "treble F4 G4 A4 F4 F4 G4 A4 F4 A4 Bb4 2C2 A4 Bb4 2C2 2C8 2D8 2C8 Bb8 A4 F4 2C8 2D8 2C8 Bb8 A4 F4 F4 C4 F2 F4 C4 F2"
             },
             {
                 "title": "Au clair de la lune",
                 "_origin": qsTr("France"),
                 "lyrics": "Au clair de la lune\nMon ami Pierrot\nPrête-moi ta plume\nPour écrire un mot\nMa chandelle est morte\nJe n'ai plus de feu\nOuvre-moi ta porte\nPour l'amour de Dieu.",
                 "melody": "treble G4 G4 G4 A4 B2 A2 G4 B4 A4 A4 G1 G4 G4 G4 A4 B2 A2 G4 B4 A4 A4 G1 A4 A4 A4 A4 E2 E2 A4 G4 F#4 E4 D1 G4 G4 G4 A4 B2 A2 G4 B4 A4 A4 G1"
             },
             {
                 "title": "Boci, boci tarka",
                 "_origin": qsTr("Hungary, Nursery Rhyme"),
                 "lyrics": "Boci, boci tarka, Se füle, se farka, Oda megyünk lakni, Ahol tejet kapni.",
                 "melody": "treble D8 F#8 D8 F#8 A4 A4 D8 F#8 D8 F#8 A4 A4 2D8 2C#8 B8 A8 G4 B4 A8 G8 F#8 E8 D4 D4"
             },
             {
                 "title": "Nyuszi ül a fűben",
                 "_origin": qsTr("Hungary, Nursery Rhyme"),
                 "lyrics": "Nyuszi ül a fűben, ülve szundikálva. Nyuszi talán beteg vagy, hogy már nem is ugorhatsz? Nyuszi hopp! Nyuszi hopp! Máris egyet elkapott.",
                 "melody": "treble A8 A8 A8 B8 A4 F#4 A8 A8 A8 B8 A8 G8 F#4 F#8 E8 F#8 E8 D8 D8 D4 A8 A8 2D4 A8 A8 2D4 F#8 E8 F#8 E8 D8 D8 D4"
             },
             {
                 "title": "Lánc, lánc, eszterlánc",
                 "_origin": qsTr("Hungary, Children's Song"),
                 "lyrics": "Lánc, lánc, eszterlánc,/ eszterlánci cérna,/ cérna volna, selyem volna,/ mégis kifordulna. / Pénz volna karika, karika,/ forduljon ki Marika,/ Marikának lánca.",
                 "melody": "treble A4 B4 A8 A8 F#4 A8 A8 A8 B8 A4 F#4 A8 A8 A8 B8 A8 G8 F#8 E8 F#8 E8 F#8 E8 D4 D4 A4 A8 A8 A8 2D8 A4 A8 G8 F#8 E8 D8 2D8 A4 A8 G8 F#8 E8 D4 D4"
             },
             {
                 "title": "Tavaszi szél vizet áraszt",
                 "_origin": qsTr("Hungary, Children's Song"),
                 "lyrics": "Tavaszi szél vizet áraszt, virágom, virágom. / Minden madár társat választ virágom, virágom. / Hát én immár kit válasszak? Virágom, virágom. / Te engemet, én tégedet, virágom, virágom.",
                 "melody": "treble F4 G4 A4 A4 G4 G8 A8 F4 G4 A8 A4 G4 G8 A8 F2 C2 F4 G4 A8 A4 G4 G8 A8 F8 E8 D4 G8 G4 A8 F4 E4 D2 D2"
             },
             {
                 "title": "Zec kopa repu",
                 "_origin": qsTr("Serbia"),
                 "lyrics": "Zec kopa repu, a lisica cveklu / Vuk im se prikrade, zeca da ukrade / Zec spazi repu, a lisica cveklu / Vuka nije bilo, u snu im se snilo",
                 "melody": "treble A2 A4 F#4 G2 E2 D4 E4 E4 E4 E2 D2 F4 F4 E4 F4 G2 E2 F4 F4 E4 D4 E2 D2"
             },
             {
                 "title": "Jack and Jill",
                 "_origin": qsTr("Britain"),
                 "lyrics": "Jack and Jill went up the hill / To fetch a pail of water. / Jack fell down and broke his crown,/ And Jill came tumbling after",
                 "melody": "treble C4 C8 D4 D8 E4 E8 F4 F8 G4 G8 A4 A8 B2 2C2 2C4 2C8 B4 B8 A4 A8 G4 G8 F4 F8 E4 E8 D2 C2"
             },
             {
                 "title": "Wlazł kotek na płotek",
                 "_origin": qsTr("Poland"),
                 "lyrics": "Wlazł kotek na płotek i mruga,/ Ładna to piosenka nie długa. / Nie długa, nie krótka, lecz w sam raz,/ Zaśpiewaj koteczku jeszcze raz.",
                 "melody": "treble G4 E4 E4 F4 D4 D4 C8 E8 G2 G4 E4 E4 F4 D4 D4 C8 E8 C2"
             },
             {
                 "title": "Φεγγαράκι μου λαμπρό",
                 "_origin": qsTr("Greece"),
                 "lyrics": "Φεγγαράκι μου λαμπρό,/ Φέγγε μου να περπατώ,/ Να πηγαίνω στο σχολειό / Να μαθαίνω γράμματα,/ Γράμματα σπουδάματα / Του Θεού τα πράματα.",
                 "melody": "treble C4 C4 G4 G4 A4 A4 G2 F4 F4 E4 E4 D4 D4 C2 G4 G4 F4 F4 E4 E4 D2 G4 G4 F4 F4 E4 E4 D2 C4 C4 G4 G4 A4 A4 G2 F4 F4 E4 E4 D4 D4 C1"
             },
             {
                 "title": "Βρέχει, χιονίζει",
                 "_origin": qsTr("Greece"),
                 "lyrics": "Βρέχει, χιονίζει,/ Τα μάρμαρα ποτίζει,/ Κι' ο γέρος πα στα ξύλα / Κ' η γριά του μαγειρεύει / Κουρκούτι με το μέλι. / \"'Ελα γέρο μου να φας / Πού να φας την / κουτσουλιά,/ Και του σκύλλου την οριά.\"",
                 "melody": "treble D8 G8 G8 G8 A8 A8 G8 G8 D8 G8 G8 G8 A8 A8 G8 G8 D8 G8 G8 G8 A8 A8 G8 G8 D8 G8 G8 G8 A8 A8 G8 G8"
             },
             {
                 "title": "Котику сіренький",
                 "_origin": qsTr("Ukraine"),
                 "lyrics": "Котику сіренький,/ Котику біленький,/ Котку волохатий,/ Не ходи по хаті! / Не ходи по хаті,/ Не буди дитяти! / Дитя буде спати,/ Котик воркотати. / Ой на кота воркота,/ На дитину дрімота. / А-а, люлі!",
                 "melody": "treble C4 F4 G4 Bb8 Ab8 G4 F4 C4 F4 G4 Bb8 Ab8 G2 F2 Bb4 Bb4 Bb4 Ab4 G2 F2 Bb4 Bb4 Bb4 Ab4 G2 F2 C4 F4 G4 Bb8 Ab8 G8 F8 G4 F2"
             },
             {
                 "title": "Baa, Baa, Blacksheep",
                 "_origin": qsTr("Britain"),
                 "lyrics": "Baa, baa, black sheep, / Have you any wool? / Yes, sir, yes, sir, / Three bags full; / One for the master, / And one for the dame, / And one for the little boy / Who lives down the lane",
                 "melody": "treble G4 G4 2D4 2D4 2E8 2E8 2E8 2E8 2D2 2C4 2C4 B4 B4 A4 A4 G2 2D4 2D8 2D8 2C4 2C4 B4 B8 B8 A2 2D4 2D8 2D8 2C8 2C8 2C8 2C8 B4 B8 B8 A2"
             },
             {
                 "title": "A la rueda de San Miguel",
                 "_origin": qsTr("Mexico"),
                 "lyrics": "A la rueda, a la rueda de San Miguel / Todos traen su caja de miel. / A lo maduro, a lo maduro / Que se voltee (nombre del niño) de burro.",
                 "melody": "treble G4 G4 2C4 G4 2C4 G8 G8 2C4 2D4 2E2 2C4 2D4 2E2 2C4 2C4 2D4 2D8 2D8 G4 G8 G8 2C2"
             },
             {
                 "title": "Arroz con leche",
                 "_origin": qsTr("Mexico"),
                 "lyrics": "Arroz con leche / me quiero casar / con una mexicana / de la capital.",
                 "melody": "treble C8 F2 A8 F4 F8 C8 F4 F8 A8 G2 A8 Bb8 A8 G8 F8 E4 E8 C8 D4 E8 E8 F4"
             },
             {
                 "title": "Los pollitos dicen",
                 "_origin": qsTr("Mexico"),
                 "lyrics": "Los pollitos dicen / pío pío pío / cuando tienen hambre / cuando tienen frío",
                 "melody": "treble A8 E8 A8 B8 2C#4 2C#4 B8 2D8 2C#8 B8 A4 A4 A8 G#8 F#8 E8 B4 B4 E8 E8 F#8 G#8 A4 A4"
             },
             {
                 "title": "Dale dale dale",
                 "_origin": qsTr("Mexican song to break a piñata"),
                 "lyrics": "Dale dale dale / no pierdas el tino / porque si lo pierdes / pierdes el camino",
                 "melody": "treble G8 G8 G8 E8 A4 A4 B8 B8 B8 G8 2C4 2C4 G8 G8 G8 E8 A4 A4 B8 B8 B8 G8 2C2"
             },
             {
                 "title": "Kolme varista",
                 "_origin": qsTr("Finland"),
                 "lyrics": "Kolme varista istui aidalla. Silivati seilaa, silivati seilaa, yksi lensi pois. Kaksi varista istui aidalla. Silivati seilaa, silivati seilaa, yksi lensi pois. Yksi varis vain istui aidalla. Silivati seilaa, silivati seilaa, sekin lensi pois.",
                 "melody": "treble A4 Bb4 A8 F2 D1 A4 D4 2C4 Bb4 G1 A8 A8 A8 G8 E4 G4 A8 A8 A8 G8 E4 G4 A2 G8 F4 E4 D4"
             },
             {
                 "title": "Humpty Dumpty",
                 "_origin": qsTr("Britain"),
                 "lyrics": "Humpty Dumpty sat on a wall, / Humpty Dumpty had a great fall. / All the king's horses and all the king's men / Couldn't put Humpty together again",
                 "melody": "treble E4 G8 F4 A8 G8 A8 B8 2C2 E4 G8 F4 A8 G8 F8 E8 D2 E8 E8 G8 F8 F8 A8 G8 A8 B8 2C4 2C8 2E8 2E8 2C8 2F4 2E8 2D8 2C8 B8 2C2"
             }
         ];
}
