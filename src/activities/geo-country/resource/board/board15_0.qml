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
   property int numberOfSubLevel: 3
   property string instruction: qsTr("Northern Scotland")
   property var levels: [
      {
         "pixmapfile" : "scotland/bg_north.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "scotland/n_aberdeenshire.png",
         "toolTipText" : "Aberdeenshire",
         "x" : "0.688",
         "y" : "0.804"
      },
      {
         "pixmapfile" : "scotland/n_aberdeen.png",
         "toolTipText" : "Aberdeen",
         "x" : "0.756",
         "y" : "0.818"
      },
      {
         "pixmapfile" : "scotland/n_moray.png",
         "toolTipText" : "Moray",
         "x" : "0.638",
         "y" : "0.768"
      },
      {
         "pixmapfile" : "scotland/n_eileanan_siar.png",
         "toolTipText" : "Na h-Eileanan Siar",
         "x" : "0.162",
         "y" : "0.722"
      },
      {
         "pixmapfile" : "scotland/n_orkney.png",
         "toolTipText" : "Orkney",
         "x" : "0.674",
         "y" : "0.448"
      },
      {
         "pixmapfile" : "scotland/n_shetland.png",
         "toolTipText" : "Shetland",
         "x" : "0.842",
         "y" : "0.23"
      },
      {
         "pixmapfile" : "scotland/n_hl_caithness.png",
         "toolTipText" : "Caithness",
         "x" : "0.612",
         "y" : "0.574"
      },
      {
         "pixmapfile" : "scotland/n_hl_sutherland.png",
         "toolTipText" : "Sutherland",
         "x" : "0.49",
         "y" : "0.61"
      },
      {
         "pixmapfile" : "scotland/n_hl_ross.png",
         "toolTipText" : "Ross",
         "x" : "0.456",
         "y" : "0.704"
      },
      {
         "pixmapfile" : "scotland/n_hl_inverness_nairn.png",
         "toolTipText" : "Inverness and Nairn",
         "x" : "0.564",
         "y" : "0.78"
      },
      {
         "pixmapfile" : "scotland/n_hl_lochalsh_badenoch_stra.png",
         "toolTipText" : "Lochalsh, Badenoch, Cromarty and Strathspey",
         "x" : "0.472",
         "y" : "0.802"
      },
      {
         "pixmapfile" : "scotland/n_hl_lochaber.png",
         "toolTipText" : "Lochaber",
         "x" : "0.372",
         "y" : "0.888"
      },
      {
         "pixmapfile" : "scotland/n_hl_skye.png",
         "toolTipText" : "Skye",
         "x" : "0.296",
         "y" : "0.776"
      }
   ]
}
