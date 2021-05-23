/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

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
         //: District of Turkey: Zonguldak
         "toolTipText" : qsTr("Zonguldak"),
         "x" : "0.533",
         "y" : "0.15"
      },
      {
         "pixmapfile" : "turkey/yozgat.png",
         //: District of Turkey: Yozgat
         "toolTipText" : qsTr("Yozgat"),
         "x" : "0.806",
         "y" : "0.398"
      },
      {
         "pixmapfile" : "turkey/yalova.png",
         //: District of Turkey: Yalova
         "toolTipText" : qsTr("Yalova"),
         "x" : "0.296",
         "y" : "0.239"
      },
      {
         "pixmapfile" : "turkey/usak.png",
         //: District of Turkey: Uşak
         "toolTipText" : qsTr("Uşak"),
         "x" : "0.3",
         "y" : "0.515"
      },
      {
         "pixmapfile" : "turkey/tekirdag.png",
         //: District of Turkey: Tekirdağ
         "toolTipText" : qsTr("Tekirdağ"),
         "x" : "0.167",
         "y" : "0.155"
      },
      {
         "pixmapfile" : "turkey/sinop.png",
         //: District of Turkey: Sinop
         "toolTipText" : qsTr("Sinop"),
         "x" : "0.794",
         "y" : "0.114"
      },
      {
         "pixmapfile" : "turkey/samsun.png",
         //: District of Turkey: Samsun
         "toolTipText" : qsTr("Samsun"),
         "x" : "0.886",
         "y" : "0.162"
      },
      {
         "pixmapfile" : "turkey/sakarya.png",
         //: District of Turkey: Sakarya
         "toolTipText" : qsTr("Sakarya"),
         "x" : "0.414",
         "y" : "0.221"
      },
      {
         "pixmapfile" : "turkey/osmaniye.png",
         //: District of Turkey: Osmaniye
         "toolTipText" : qsTr("Osmaniye"),
         "x" : "0.91",
         "y" : "0.692"
      },
      {
         "pixmapfile" : "turkey/nigde.png",
         //: District of Turkey: Niğde
         "toolTipText" : qsTr("Niğde"),
         "x" : "0.765",
         "y" : "0.638"
      },
      {
         "pixmapfile" : "turkey/nevsehir.png",
         //: District of Turkey: Nevşehir
         "toolTipText" : qsTr("Nevşehir"),
         "x" : "0.765",
         "y" : "0.5"
      },
      {
         "pixmapfile" : "turkey/mugla.png",
         //: District of Turkey: Muğla
         "toolTipText" : qsTr("Muğla"),
         "x" : "0.206",
         "y" : "0.733"
      },
      {
         "pixmapfile" : "turkey/mersin.png",
         //: District of Turkey: Mersin
         "toolTipText" : qsTr("Mersin"),
         "x" : "0.688",
         "y" : "0.794"
      },
      {
         "pixmapfile" : "turkey/manisa.png",
         //: District of Turkey: Manisa
         "toolTipText" : qsTr("Manisa"),
         "x" : "0.196",
         "y" : "0.477"
      },
      {
         "pixmapfile" : "turkey/kutahya.png",
         //: District of Turkey: Kütahya
         "toolTipText" : qsTr("Kütahya"),
         "x" : "0.32",
         "y" : "0.413"
      },
      {
         "pixmapfile" : "turkey/konya.png",
         //: District of Turkey: Konya
         "toolTipText" : qsTr("Konya"),
         "x" : "0.602",
         "y" : "0.62"
      },
      {
         "pixmapfile" : "turkey/kocaeli.png",
         //: District of Turkey: Kocaeli
         "toolTipText" : qsTr("Kocaeli"),
         "x" : "0.367",
         "y" : "0.198"
      },
      {
         "pixmapfile" : "turkey/kirsehir.png",
         //: District of Turkey: Kirsehir
         "toolTipText" : qsTr("Kirsehir"),
         "x" : "0.718",
         "y" : "0.431"
      },
      {
         "pixmapfile" : "turkey/kirklareli.png",
         //: District of Turkey: Kırklareli
         "toolTipText" : qsTr("Kırklareli"),
         "x" : "0.178",
         "y" : "0.07"
      },
      {
         "pixmapfile" : "turkey/kirikkale.png",
         //: District of Turkey: Kırıkkale
         "toolTipText" : qsTr("Kırıkkale"),
         "x" : "0.686",
         "y" : "0.362"
      },
      {
         "pixmapfile" : "turkey/kayseri.png",
         //: District of Turkey: Kayseri
         "toolTipText" : qsTr("Kayseri"),
         "x" : "0.869",
         "y" : "0.543"
      },
      {
         "pixmapfile" : "turkey/kastamonu.png",
         //: District of Turkey: Kastamonu
         "toolTipText" : qsTr("Kastamonu"),
         "x" : "0.69",
         "y" : "0.142"
      },
      {
         "pixmapfile" : "turkey/karaman.png",
         //: District of Turkey: Karaman
         "toolTipText" : qsTr("Karaman"),
         "x" : "0.627",
         "y" : "0.748"
      },
      {
         "pixmapfile" : "turkey/karabuk.png",
         //: District of Turkey: Karabük
         "toolTipText" : qsTr("Karabük"),
         "x" : "0.59",
         "y" : "0.188"
      },
      {
         "pixmapfile" : "turkey/izmir.png",
         //: District of Turkey: İzmir
         "toolTipText" : qsTr("İzmir"),
         "x" : "0.129",
         "y" : "0.485"
      },
      {
         "pixmapfile" : "turkey/istanbul.png",
         //: District of Turkey: İstanbul
         "toolTipText" : qsTr("İstanbul"),
         "x" : "0.292",
         "y" : "0.157"
      },
      {
         "pixmapfile" : "turkey/isparta.png",
         //: District of Turkey: Isparta
         "toolTipText" : qsTr("Isparta"),
         "x" : "0.42",
         "y" : "0.618"
      },
      {
         "pixmapfile" : "turkey/hatay.png",
         //: District of Turkey: Hatay
         "toolTipText" : qsTr("Hatay"),
         "x" : "0.916",
         "y" : "0.835"
      },
      {
         "pixmapfile" : "turkey/eskisehir.png",
         //: District of Turkey: Eskişehir
         "toolTipText" : qsTr("Eskişehir"),
         "x" : "0.457",
         "y" : "0.38"
      },
      {
         "pixmapfile" : "turkey/edirne.png",
         //: District of Turkey: Edirne
         "toolTipText" : qsTr("Edirne"),
         "x" : "0.096",
         "y" : "0.104"
      },
      {
         "pixmapfile" : "turkey/duzce.png",
         //: District of Turkey: Düzce
         "toolTipText" : qsTr("Düzce"),
         "x" : "0.476",
         "y" : "0.201"
      },
      {
         "pixmapfile" : "turkey/denizli.png",
         //: District of Turkey: Denizli
         "toolTipText" : qsTr("Denizli"),
         "x" : "0.29",
         "y" : "0.633"
      },
      {
         "pixmapfile" : "turkey/corum.png",
         //: District of Turkey: Çorum
         "toolTipText" : qsTr("Çorum"),
         "x" : "0.78",
         "y" : "0.265"
      },
      {
         "pixmapfile" : "turkey/cankiri.png",
         //: District of Turkey: Çankırı
         "toolTipText" : qsTr("Çankırı"),
         "x" : "0.665",
         "y" : "0.244"
      },
      {
         "pixmapfile" : "turkey/canakkale.png",
         //: District of Turkey: Çanakkale
         "toolTipText" : qsTr("Çanakkale"),
         "x" : "0.084",
         "y" : "0.27"
      },
      {
         "pixmapfile" : "turkey/bursa.png",
         //: District of Turkey: Bursa
         "toolTipText" : qsTr("Bursa"),
         "x" : "0.296",
         "y" : "0.306"
      },
      {
         "pixmapfile" : "turkey/burdur.png",
         //: District of Turkey: Burdur
         "toolTipText" : qsTr("Burdur"),
         "x" : "0.355",
         "y" : "0.682"
      },
      {
         "pixmapfile" : "turkey/bolu.png",
         //: District of Turkey: Bolu
         "toolTipText" : qsTr("Bolu"),
         "x" : "0.5",
         "y" : "0.242"
      },
      {
         "pixmapfile" : "turkey/bilecik.png",
         //: District of Turkey: Bilecik
         "toolTipText" : qsTr("Bilecik"),
         "x" : "0.382",
         "y" : "0.311"
      },
      {
         "pixmapfile" : "turkey/bartin.png",
         //: District of Turkey: Bartın
         "toolTipText" : qsTr("Bartın"),
         "x" : "0.594",
         "y" : "0.114"
      },
      {
         "pixmapfile" : "turkey/balikesir.png",
         //: District of Turkey: Balıkesir
         "toolTipText" : qsTr("Balıkesir"),
         "x" : "0.18",
         "y" : "0.321"
      },
      {
         "pixmapfile" : "turkey/aydin.png",
         //: District of Turkey: Aydın
         "toolTipText" : qsTr("Aydın"),
         "x" : "0.171",
         "y" : "0.61"
      },
      {
         "pixmapfile" : "turkey/antalya.png",
         //: District of Turkey: Antalya
         "toolTipText" : qsTr("Antalya"),
         "x" : "0.424",
         "y" : "0.779"
      },
      {
         "pixmapfile" : "turkey/ankara.png",
         //: District of Turkey: Ankara
         "toolTipText" : qsTr("Ankara"),
         "x" : "0.571",
         "y" : "0.382"
      },
      {
         "pixmapfile" : "turkey/amasya.png",
         //: District of Turkey: Amasya
         "toolTipText" : qsTr("Amasya"),
         "x" : "0.863",
         "y" : "0.252"
      },
      {
         "pixmapfile" : "turkey/aksaray.png",
         //: District of Turkey: Aksaray
         "toolTipText" : qsTr("Aksaray"),
         "x" : "0.694",
         "y" : "0.551"
      },
      {
         "pixmapfile" : "turkey/afyon.png",
         //: District of Turkey: Afyon
         "toolTipText" : qsTr("Afyon"),
         "x" : "0.412",
         "y" : "0.536"
      },
      {
         "pixmapfile" : "turkey/adana.png",
         //: District of Turkey: Adana
         "toolTipText" : qsTr("Adana"),
         "x" : "0.841",
         "y" : "0.687"
      }
   ]
}
