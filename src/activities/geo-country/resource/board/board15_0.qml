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
   property int numberOfSubLevel: 3
   property string instruction: qsTr("Northern Scotland")
   property var levels: [
      {
         "pixmapfile" : "scotland/bg_north.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "scotland/n_aberdeenshire.png",
         //: District of Northern Scotland: Aberdeenshire
         "toolTipText" : qsTr("Aberdeenshire"),
         "x" : "0.688",
         "y" : "0.804"
      },
      {
         "pixmapfile" : "scotland/n_aberdeen.png",
         //: District of Northern Scotland: Aberdeen
         "toolTipText" : qsTr("Aberdeen"),
         "x" : "0.756",
         "y" : "0.818"
      },
      {
         "pixmapfile" : "scotland/n_moray.png",
         //: District of Northern Scotland: Moray
         "toolTipText" : qsTr("Moray"),
         "x" : "0.638",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "scotland/n_eileanan_siar.png",
         //: District of Northern Scotland: Na h-Eileanan Siar
         "toolTipText" : qsTr("Na h-Eileanan Siar"),
         "x" : "0.162",
         "y" : "0.722"
      },
      {
         "pixmapfile" : "scotland/n_orkney.png",
         //: District of Northern Scotland: Orkney
         "toolTipText" : qsTr("Orkney"),
         "x" : "0.674",
         "y" : "0.448"
      },
      {
         "pixmapfile" : "scotland/n_shetland.png",
         //: District of Northern Scotland: Shetland
         "toolTipText" : qsTr("Shetland"),
         "x" : "0.842",
         "y" : "0.23"
      },
      {
         "pixmapfile" : "scotland/n_hl_caithness.png",
         //: District of Northern Scotland: Caithness
         "toolTipText" : qsTr("Caithness"),
         "x" : "0.612",
         "y" : "0.574"
      },
      {
         "pixmapfile" : "scotland/n_hl_sutherland.png",
         //: District of Northern Scotland: Sutherland
         "toolTipText" : qsTr("Sutherland"),
         "x" : "0.49",
         "y" : "0.61"
      },
      {
         "pixmapfile" : "scotland/n_hl_ross.png",
         //: District of Northern Scotland: Ross
         "toolTipText" : qsTr("Ross"),
         "x" : "0.456",
         "y" : "0.704"
      },
      {
         "pixmapfile" : "scotland/n_hl_inverness_nairn.png",
         //: District of Northern Scotland: Inverness and Nairn
         "toolTipText" : qsTr("Inverness and Nairn"),
         "x" : "0.564",
         "y" : "0.78"
      },
      {
         "pixmapfile" : "scotland/n_hl_lochalsh_badenoch_stra.png",
         //: District of Northern Scotland: Lochalsh, Badenoch, Cromarty and Strathspey
         "toolTipText" : qsTr("Lochalsh, Badenoch, Cromarty and Strathspey"),
         "x" : "0.472",
         "y" : "0.802"
      },
      {
         "pixmapfile" : "scotland/n_hl_lochaber.png",
         //: District of Northern Scotland: Lochaber
         "toolTipText" : qsTr("Lochaber"),
         "x" : "0.372",
         "y" : "0.888"
      },
      {
         "pixmapfile" : "scotland/n_hl_skye.png",
         //: District of Northern Scotland: Skye
         "toolTipText" : qsTr("Skye"),
         "x" : "0.296",
         "y" : "0.776"
      }
   ]
}
