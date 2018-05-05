/* GCompris - wordset.js
 *
 * Copyright (C) 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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

var dataset = {"ca": {
    "3letters": ["deu","gla","noi","col","gat","nen","cub","cau","gos",
                 "nan","ull","peu","dit","vol","all","joc","got","cap","suc"],
    "4letters": ["llit","poma","vuit","cinc","gran","blau","brot","capa",
                 "vaca","crep","fada","cara","peix","flor","bosc","amic","noia"],
    "5letters": ["dotze","bossa","ocell","nabiu","cacau","cotxe","carro",
                 "cranc","metge","porta","colze","regal","herba","cuina","gatet"]
                     },
               "de": {
    "3letters": ["elf","arm","ast","der","die","das","bus","ton","kuh",
                 "ohr","fee","hut","heu","see","weg","rot","ast","zeh","zug"],
    "4letters": ["zehn","acht","ball","blau","boot","buch","auto","kind",
                 "bach","hund","ente","mehl","gans","grau","kopf","igel","saft"],
    "5letters": ["sechs","apfel","bauch","biber","blond","junge","kamel",
                 "karte","kater","gurke","vater","erpel","zwerg","augen","fisch"]
                     },
               "en": {
    "3letters": ["cat","dog","win","red","yes","big","box","air","arm",
                 "car","bus","fun","day","eat","hat","leg","ice","old","egg"],
    "4letters": ["blue","best","good","area","bell","coat","easy","farm",
                 "food","else","girl","give","hero","help","hour","sand","song"],
    "5letters": ["happy","child","white","apple","brown","truth","fresh",
                 "green","horse","hotel","house","paper","shape","shirt","study"]
                     },
               "es": {
    "3letters": ["uno","ser","ajo","oro","rey","luz","par","dos","mar",
                 "ver","hoy","voz","ola","col","dar","fan","pan","ojo","pie"],
    "4letters": ["diez","gato","cama","azul","rojo","pero","codo","pies",
                 "dedo","flor","mesa","mano","casa","lago","luna","boca","rosa"],
    "5letters": ["cinco","playa","abeja","perro","libro","pollo","reloj",
                 "comer","huevo","fruta","chica","chico","gafas","bueno","verde"],
                     },
               "fr": {
    "3letters": ["six","nez","fil","dos","lit","oui","bus","air","sol",
                 "car","cil","cou","jeu","oie","jus","roi","lac","une","nid"],
    "4letters": ["chat","nuit","jour","ciel","gens","paon","faon","rose",
                 "vert","lire","toit","rond","voir","fort","gare","roue","deux"],
    "5letters": ["reine","douze","pomme","jaune","vache","bulle","wagon",
                 "carte","craie","ville","tissu","clown","forme","froid","chaud"]
                     },
               "ga": {
    "3letters": ["tar","dar","gur","cur","ort","ord","olc","cat","lab","jab",
		 "fad","fud","rud","rug","gur","cad","sin","rua"],
    "4letters": ["clog","frog","drud","club","pluc","fada","dara","dona",
                 "bata","hata","lofa","roth","guth","cath","dath","mise","glan"],
    "5letters": ["solas","turas","doras","focal","pobal","ansin","clann","crann",
                 "ansin","inniu","pobal","peaca","racht","othar","solas","cumas","olcas"]
                     },
               "ro": {
    "3letters": ["unu","doi","urs","pat","pod","bec","cub","vis","cot",
                 "joc","sol","cap","suc","lac","far","leu","mov","nas","bou"],
    "4letters": ["zece","trei","baie","maro","tort","ceas","cerb","ochi",
                 "pumn","zbor","deal","elan","film","ziar","pian","tras","orez"],
    "5letters": ["atlet","spate","minge","frate","copil","desen","deget",
                 "steag","vulpe","cadou","pahar","verde","gazon","homar","lapte"]
                     },
               "sv": {
    "3letters": ["tio","arù","ben","bur","bil","ost","jul","tyg","kub",
                 "ide","and","fot","get","hem","hus","yla","dam","ben","fyr"],
    "4letters": ["elva","djur","myra","baka","bror","kort","katt","barn",
                 "moln","mynt","duva","fisk","skog","gald","ljus","lila","berg"],
    "5letters": ["pojke","krita","pappa","mamma","gurka","groda","frukt",
                 "rolig","huvud","lejon","karta","svamp","utter","byxor","ponny"]
                     }
};
