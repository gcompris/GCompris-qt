/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

ActivityInfo {
  name: "erase/Erase.qml"
  difficulty: 1
  icon: "erase/erase.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Move the mouse or touch the screen")
  //: Help title
  description: qsTr("Move the mouse or touch the screen to erase the area and discover the background.")
//  intro: " Clear the window with your sponge and discover the hidden picture."
  //: Help goal
  goal: qsTr("Motor-coordination.")
  //: Help prerequisite
  prerequisite: qsTr("Mouse-manipulation.")
  //: Help manual
  manual: qsTr("Move the mouse or touch the screen on the blocks to make them disappear.")
  credit: ("<ul><li>") +
          ('"Alpaca" by Dietmar Rabich / Wikimedia Commons (https://commons.wikimedia.org/wiki/File:D%C3%BClmen,_B%C3%B6rnste,_Alpakas_--_2020_--_5338.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Pollinationn" by aussiegall (https://commons.wikimedia.org/wiki/File:Pollinationn.jpg), CC BY 2.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Butterfly" by © 2014 Jee & Rani Nature Photography (https://commons.wikimedia.org/wiki/File:Parantica_aglea_at_Nayikayam_Thattu.jpg), CC BY-SA 4.0, changes: non-linear rescaling, cropping, sharpening') + ("</li><li>") +
          ('"Calf" by Basile Morin (https://commons.wikimedia.org/wiki/File:Close-up_photograph_of_a_calf%27s_head_looking_at_the_viewer_with_pricked_ears_in_Don_Det_Laos.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Camels" by Alexandr frolov (https://commons.wikimedia.org/wiki/File:Camelus_bactrianus_in_western_Mongolia_02.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Caterpillar" by Ivar Leidus (https://commons.wikimedia.org/wiki/File:Papilio_machaon_-_Daucus_carota_-_Keila.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Chamaeleo chamaeleon Samos Griechenland" by Benny Trapp (https://commons.wikimedia.org/wiki/File:BennyTrapp_Chamaeleo_chamaeleon_Samos_Griechenland.jpg), CC BY 3.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Cheetah" by Charles J. Sharp (https://commons.wikimedia.org/wiki/File:Cheetah_(Acinonyx_jubatus)_female_2.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Dolphin" by טל שמע (https://commons.wikimedia.org/wiki/File:Eilat_Dolphin_Reef_(3).jpg), CC BY-SA 4.0, changes: cropping, sharpening, removed a few spots') + ("</li><li>") +
          ('"Flying fox" by Andrew Mercer (https://commons.wikimedia.org/wiki/File:Grey_headed_flying_fox_-_AndrewMercer_IMG41848.jpg), CC BY-SA 4.0, changes: cropping, sharpening, removed a few spots') + ("</li><li>") +
          ('"Hylobates lar - Kaeng Krachan WB" by JJ Harrison (https://commons.wikimedia.org/wiki/File:Hylobates_lar_-_Kaeng_Krachan_WB.jpg), CC BY 3.0, changes: cropping') + ("</li><li>") +
          ('"Goat" by JoachimKohlerBremen (https://commons.wikimedia.org/wiki/File:Walliser_Schwarzhalsziege,_Belalp_2014.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Gorilla" by Charles J. Sharp (https://commons.wikimedia.org/wiki/File:Mountain_gorilla_(Gorilla_beringei_beringei)_female_2.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Gosling" by Stephan Sprinz (https://commons.wikimedia.org/wiki/File:Graugans-G%C3%B6ssel_(anser_anser)_im_Naturschutzgebiet_Wagbachniederung.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Heron" by Stephan Sprinz (https://commons.wikimedia.org/wiki/File:Purpurreiher_(ardea_purpurea)_im_Flug_-_NSG_Wagbachniederung_1.jpg), CC BY-SA 4.0, changes: cropping') + ("</li><li>") +
          ('"Horse" by Eatcha (https://commons.wikimedia.org/wiki/File:Zaniskari_Horse_in_Ladakh.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"A posing kitten" by GalgenTX (https://commons.wikimedia.org/wiki/File:A_posing_kitten_(Flickr).jpg), CC BY 2.0, changes: cropping, colour adjustment, sharpening') + ("</li><li>") +
          ('"Long nosed monkey" by Charles J. Sharp (https://commons.wikimedia.org/wiki/File:Proboscis_monkey_(Nasalis_larvatus)_female_and_baby.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Macaque" by PJeganathan (https://commons.wikimedia.org/wiki/File:Bonnet_macaques_in_anaimalai_hills_JEG2730.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Meerkats" by Charles J. Sharp (https://commons.wikimedia.org/wiki/File:Meerkat_(Suricata_suricatta)_Tswalu.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Northern harrier" by Frank Schulenburg (https://commons.wikimedia.org/wiki/File:Female_northern_harrier_in_flight-1142.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Nubian ibex" by Rhododendrites (https://commons.wikimedia.org/wiki/File:Juvenile_Nubian_ibex_in_Mitzpe_Ramon_(40409).jpg), CC BY-SA 4.0, changes: non-linear rescaling, cropping, sharpening') + ("</li><li>") +
          ('"Penguin" Photo: Gordon Leggett / Wikimedia Commons (https://commons.wikimedia.org/wiki/File:2019-03-03_Chinstrap_penguin_on_Barrientos_Island,_Antarctica.jpg), CC BY-SA 4.0, changes: non-linear rescaling, cropping, sharpening') + ("</li><li>") +
          ('"Rhinoceros" by Charles J. Sharp (https://commons.wikimedia.org/wiki/File:Indian_rhinoceros_(Rhinoceros_unicornis)_4.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Spoonbills" by Ryzhkov Sergey (https://commons.wikimedia.org/wiki/File:%D0%9A%D0%BE%D1%81%D0%B0%D1%80%D1%96_%D0%B2_%D0%B4%D0%B5%D0%BB%D1%8C%D1%82%D1%96_%D0%94%D1%83%D0%BD%D0%B0%D1%8E.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Squirrel" by Роман Наумов (https://commons.wikimedia.org/wiki/File:%D0%91%D1%96%D0%BB%D0%BA%D0%B0_%D0%BD%D0%B0_%D0%B4%D0%B5%D1%80%D0%B5%D0%B2%D1%96_%D0%B2_%D0%B4%D0%B5%D0%BD%D0%B4%D1%80%D0%BE%D0%BF%D0%B0%D1%80%D0%BA%D1%83_%D0%9E%D0%BB%D0%B5%D0%BA%D1%81%D0%B0%D0%BD%D0%B4%D1%80%D1%96%D1%8F.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Swans" by Charles J. Sharp (https://commons.wikimedia.org/wiki/File:Mute_swans_(Cygnus_olor)_and_cygnets.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li><li>") +
          ('"Toucan" by LG Nyqvist (https://commons.wikimedia.org/wiki/File:Pteroglossus_torquatus_Costa_Rica.jpg), CC BY-SA 4.0, changes: cropping, sharpening') + ("</li></ul>")
  section: "computer mouse"
  createdInVersion: 0
}
