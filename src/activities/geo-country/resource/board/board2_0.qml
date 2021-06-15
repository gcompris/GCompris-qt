/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (new SVG map)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9

QtObject {
   property string instruction: qsTr("States of Germany")
   property var levels: [
      {
         "pixmapfile" : "germany/germany.svgz",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "germany/thuringia.svgz",
         //: State of Germany: Thuringia
         "toolTipText" : qsTr("Thuringia"),
         "x" : "0.5848",
         "y" : "0.5289"
      },
      {
         "pixmapfile" : "germany/schleswig-holstein.svgz",
         //: State of Germany: Schleswig-Holstein
         "toolTipText" : qsTr("Schleswig-Holstein"),
         "x" : "0.4092",
         "y" : "0.1293"
      },
      {
         "pixmapfile" : "germany/saxony.svgz",
         //: State of Germany: Saxony
         "toolTipText" : qsTr("Saxony"),
         "x" : "0.8142",
         "y" : "0.5287"
      },
      {
         "pixmapfile" : "germany/saxony-anhalt.svgz",
         //: State of Germany: Saxony-Anhalt
         "toolTipText" : qsTr("Saxony-Anhalt"),
         "x" : "0.6485",
         "y" : "0.3998"
      },
      {
         "pixmapfile" : "germany/saarland.svgz",
         //: State of Germany: Saarland
         "toolTipText" : qsTr("Saarland"),
         "x" : "0.1259",
         "y" : "0.7177"
      },
      {
         "pixmapfile" : "germany/rhineland-palatinate.svgz",
         //: State of Germany: Rhineland-Palatinate
         "toolTipText" : qsTr("Rhineland-Palatinate"),
         "x" : "0.171",
         "y" : "0.6472"
      },
      {
         "pixmapfile" : "germany/north_rhine-westphalia.svgz",
         //: State of Germany: North Rhine-Westphalia
         "toolTipText" : qsTr("North Rhine-Westphalia"),
         "x" : "0.2079",
         "y" : "0.468"
      },
      {
         "pixmapfile" : "germany/lower_saxony.svgz",
         //: State of Germany: Lower Saxony
         "toolTipText" : qsTr("Lower Saxony"),
         "x" : "0.3604",
         "y" : "0.3261"
      },
      {
         "pixmapfile" : "germany/mecklenburg-vorpommern.svgz",
         //: State of Germany: Mecklenburg-Vorpommern
         "toolTipText" : qsTr("Mecklenburg-Vorpommern"),
         "x" : "0.7143",
         "y" : "0.1674"
      },
      {
         "pixmapfile" : "germany/hesse.svgz",
         //: State of Germany: Hesse
         "toolTipText" : qsTr("Hesse"),
         "x" : "0.3483",
         "y" : "0.5776"
      },
      {
         "pixmapfile" : "germany/hamburg.svgz",
         //: State of Germany: Hamburg
         "toolTipText" : qsTr("Hamburg"),
         "x" : "0.4553",
         "y" : "0.2077"
      },
      {
         "pixmapfile" : "germany/bremen.svgz",
         //: State of Germany: Bremen
         "toolTipText" : qsTr("Bremen"),
         "x" : "0.3202",
         "y" : "0.2387"
      },
      {
         "pixmapfile" : "germany/brandenburg.svgz",
         //: State of Germany: Brandenburg
         "toolTipText" : qsTr("Brandenburg"),
         "x" : "0.768",
         "y" : "0.3425"
      },
      {
         "pixmapfile" : "germany/berlin.svgz",
         //: State of Germany: Berlin
         "toolTipText" : qsTr("Berlin"),
         "x" : "0.8108",
         "y" : "0.3367"
      },
      {
         "pixmapfile" : "germany/bavaria.svgz",
         //: State of Germany: Bavaria
         "toolTipText" : qsTr("Bavaria"),
         "x" : "0.5998",
         "y" : "0.7735"
      },
      {
         "pixmapfile" : "germany/baden-wurttemberg.svgz",
         //: State of Germany: Baden-Württemberg
         "toolTipText" : qsTr("Baden-Württemberg"),
         "x" : "0.3482",
         "y" : "0.8045"
      }
   ]
}
