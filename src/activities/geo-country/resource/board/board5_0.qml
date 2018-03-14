/* GCompris
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
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
import QtQuick 2.6

QtObject {
   property int numberOfSubLevel: 2
   property string instruction: qsTr("Districts of Turkey")
   property var levels: [
      {
         "pixmapfile" : "turkey/turkey-west.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "turkey/zonguldak.png",
         "toolTipText" : "Zonguldak",
         "x" : "0.533",
         "y" : "0.15"
      },
      {
         "pixmapfile" : "turkey/yozgat.png",
         "toolTipText" : "Yozgat",
         "x" : "0.806",
         "y" : "0.398"
      },
      {
         "pixmapfile" : "turkey/yalova.png",
         "toolTipText" : "Yalova",
         "x" : "0.296",
         "y" : "0.239"
      },
      {
         "pixmapfile" : "turkey/usak.png",
         "toolTipText" : "Usak",
         "x" : "0.3",
         "y" : "0.515"
      },
      {
         "pixmapfile" : "turkey/tekirdag.png",
         "toolTipText" : "Tekirdag",
         "x" : "0.167",
         "y" : "0.155"
      },
      {
         "pixmapfile" : "turkey/sinop.png",
         "toolTipText" : "Sinop",
         "x" : "0.794",
         "y" : "0.114"
      },
      {
         "pixmapfile" : "turkey/samsun.png",
         "toolTipText" : "Samsun",
         "x" : "0.886",
         "y" : "0.162"
      },
      {
         "pixmapfile" : "turkey/sakarya.png",
         "toolTipText" : "Sakarya",
         "x" : "0.414",
         "y" : "0.221"
      },
      {
         "pixmapfile" : "turkey/osmaniye.png",
         "toolTipText" : "Osmaniye",
         "x" : "0.91",
         "y" : "0.692"
      },
      {
         "pixmapfile" : "turkey/nigde.png",
         "toolTipText" : "Nigde",
         "x" : "0.765",
         "y" : "0.638"
      },
      {
         "pixmapfile" : "turkey/nevsehir.png",
         "toolTipText" : "Nevsehir",
         "x" : "0.765",
         "y" : "0.5"
      },
      {
         "pixmapfile" : "turkey/mugla.png",
         "toolTipText" : "Mugla",
         "x" : "0.206",
         "y" : "0.733"
      },
      {
         "pixmapfile" : "turkey/mersin.png",
         "toolTipText" : "Mersin",
         "x" : "0.688",
         "y" : "0.794"
      },
      {
         "pixmapfile" : "turkey/manisa.png",
         "toolTipText" : "Manisa",
         "x" : "0.196",
         "y" : "0.477"
      },
      {
         "pixmapfile" : "turkey/kutahya.png",
         "toolTipText" : "Kütahya",
         "x" : "0.32",
         "y" : "0.413"
      },
      {
         "pixmapfile" : "turkey/konya.png",
         "toolTipText" : "Konya",
         "x" : "0.602",
         "y" : "0.62"
      },
      {
         "pixmapfile" : "turkey/kocaeli.png",
         "toolTipText" : "Kocaeli",
         "x" : "0.367",
         "y" : "0.198"
      },
      {
         "pixmapfile" : "turkey/kirsehir.png",
         "toolTipText" : "Kirsehir",
         "x" : "0.718",
         "y" : "0.431"
      },
      {
         "pixmapfile" : "turkey/kirklareli.png",
         "toolTipText" : "Kirklareli",
         "x" : "0.178",
         "y" : "0.07"
      },
      {
         "pixmapfile" : "turkey/kirikkale.png",
         "toolTipText" : "Kirikkale",
         "x" : "0.686",
         "y" : "0.362"
      },
      {
         "pixmapfile" : "turkey/kayseri.png",
         "toolTipText" : "Kayseri",
         "x" : "0.869",
         "y" : "0.543"
      },
      {
         "pixmapfile" : "turkey/kastamonu.png",
         "toolTipText" : "Kastamonu",
         "x" : "0.69",
         "y" : "0.142"
      },
      {
         "pixmapfile" : "turkey/karaman.png",
         "toolTipText" : "Karaman",
         "x" : "0.627",
         "y" : "0.748"
      },
      {
         "pixmapfile" : "turkey/karabuk.png",
         "toolTipText" : "Karabük",
         "x" : "0.59",
         "y" : "0.188"
      },
      {
         "pixmapfile" : "turkey/izmir.png",
         "toolTipText" : "Izmir",
         "x" : "0.129",
         "y" : "0.485"
      },
      {
         "pixmapfile" : "turkey/istanbul.png",
         "toolTipText" : "Istanbul",
         "x" : "0.292",
         "y" : "0.157"
      },
      {
         "pixmapfile" : "turkey/isparta.png",
         "toolTipText" : "Isparta",
         "x" : "0.42",
         "y" : "0.618"
      },
      {
         "pixmapfile" : "turkey/hatay.png",
         "toolTipText" : "Hatay",
         "x" : "0.916",
         "y" : "0.835"
      },
      {
         "pixmapfile" : "turkey/eskisehir.png",
         "toolTipText" : "Eskisehir",
         "x" : "0.457",
         "y" : "0.38"
      },
      {
         "pixmapfile" : "turkey/edirne.png",
         "toolTipText" : "Edirne",
         "x" : "0.096",
         "y" : "0.104"
      },
      {
         "pixmapfile" : "turkey/duzce.png",
         "toolTipText" : "Düzce",
         "x" : "0.476",
         "y" : "0.201"
      },
      {
         "pixmapfile" : "turkey/denizli.png",
         "toolTipText" : "Denizli",
         "x" : "0.29",
         "y" : "0.633"
      },
      {
         "pixmapfile" : "turkey/corum.png",
         "toolTipText" : "Çorum",
         "x" : "0.78",
         "y" : "0.265"
      },
      {
         "pixmapfile" : "turkey/cankiri.png",
         "toolTipText" : "Çankiri",
         "x" : "0.665",
         "y" : "0.244"
      },
      {
         "pixmapfile" : "turkey/canakkale.png",
         "toolTipText" : "Çanakkale",
         "x" : "0.084",
         "y" : "0.27"
      },
      {
         "pixmapfile" : "turkey/bursa.png",
         "toolTipText" : "Bursa",
         "x" : "0.296",
         "y" : "0.306"
      },
      {
         "pixmapfile" : "turkey/burdur.png",
         "toolTipText" : "Burdur",
         "x" : "0.355",
         "y" : "0.682"
      },
      {
         "pixmapfile" : "turkey/bolu.png",
         "toolTipText" : "Bolu",
         "x" : "0.5",
         "y" : "0.242"
      },
      {
         "pixmapfile" : "turkey/bilecik.png",
         "toolTipText" : "Bilecik",
         "x" : "0.382",
         "y" : "0.311"
      },
      {
         "pixmapfile" : "turkey/bartin.png",
         "toolTipText" : "Bartin",
         "x" : "0.594",
         "y" : "0.114"
      },
      {
         "pixmapfile" : "turkey/balikesir.png",
         "toolTipText" : "Balikesir",
         "x" : "0.18",
         "y" : "0.321"
      },
      {
         "pixmapfile" : "turkey/aydin.png",
         "toolTipText" : "Aydin",
         "x" : "0.171",
         "y" : "0.61"
      },
      {
         "pixmapfile" : "turkey/antalya.png",
         "toolTipText" : "Antalya",
         "x" : "0.424",
         "y" : "0.779"
      },
      {
         "pixmapfile" : "turkey/ankara.png",
         "toolTipText" : "Ankara",
         "x" : "0.571",
         "y" : "0.382"
      },
      {
         "pixmapfile" : "turkey/amasya.png",
         "toolTipText" : "Amasya",
         "x" : "0.863",
         "y" : "0.252"
      },
      {
         "pixmapfile" : "turkey/aksaray.png",
         "toolTipText" : "Aksaray",
         "x" : "0.694",
         "y" : "0.551"
      },
      {
         "pixmapfile" : "turkey/afyon.png",
         "toolTipText" : "Afyon",
         "x" : "0.412",
         "y" : "0.536"
      },
      {
         "pixmapfile" : "turkey/adana.png",
         "toolTipText" : "Adana",
         "x" : "0.841",
         "y" : "0.687"
      }
   ]
}
