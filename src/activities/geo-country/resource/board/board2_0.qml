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
import QtQuick 2.12

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
         "x" : "0.5837",
         "y" : "0.5303"
      },
      {
         "pixmapfile" : "germany/schleswig-holstein.svgz",
         //: State of Germany: Schleswig-Holstein
         "toolTipText" : qsTr("Schleswig-Holstein"),
         "x" : "0.4397",
         "y" : "0.1253"
      },
      {
         "pixmapfile" : "germany/saxony.svgz",
         //: State of Germany: Saxony
         "toolTipText" : qsTr("Saxony"),
         "x" : "0.8065",
         "y" : "0.5284"
      },
      {
         "pixmapfile" : "germany/saxony-anhalt.svgz",
         //: State of Germany: Saxony-Anhalt
         "toolTipText" : qsTr("Saxony-Anhalt"),
         "x" : "0.644",
         "y" : "0.3984"
      },
      {
         "pixmapfile" : "germany/saarland.svgz",
         //: State of Germany: Saarland
         "toolTipText" : qsTr("Saarland"),
         "x" : "0.1238",
         "y" : "0.715"
      },
      {
         "pixmapfile" : "germany/rhineland-palatinate.svgz",
         //: State of Germany: Rhineland-Palatinate
         "toolTipText" : qsTr("Rhineland-Palatinate"),
         "x" : "0.1729",
         "y" : "0.6468"
      },
      {
         "pixmapfile" : "germany/north_rhine-westphalia.svgz",
         //: State of Germany: North Rhine-Westphalia
         "toolTipText" : qsTr("North Rhine-Westphalia"),
         "x" : "0.2175",
         "y" : "0.4638"
      },
      {
         "pixmapfile" : "germany/lower_saxony.svgz",
         //: State of Germany: Lower Saxony
         "toolTipText" : qsTr("Lower Saxony"),
         "x" : "0.371",
         "y" : "0.3243"
      },
      {
         "pixmapfile" : "germany/mecklenburg-vorpommern.svgz",
         //: State of Germany: Mecklenburg-Vorpommern
         "toolTipText" : qsTr("Mecklenburg-Vorpommern"),
         "x" : "0.6998",
         "y" : "0.1631"
      },
      {
         "pixmapfile" : "germany/hesse.svgz",
         //: State of Germany: Hesse
         "toolTipText" : qsTr("Hesse"),
         "x" : "0.3505",
         "y" : "0.5786"
      },
      {
         "pixmapfile" : "germany/hamburg.svgz",
         //: State of Germany: Hamburg
         "toolTipText" : qsTr("Hamburg"),
         "x" : "0.4601",
         "y" : "0.2058"
      },
      {
         "pixmapfile" : "germany/bremen.svgz",
         //: State of Germany: Bremen
         "toolTipText" : qsTr("Bremen"),
         "x" : "0.3342",
         "y" : "0.2357"
      },
      {
         "pixmapfile" : "germany/brandenburg.svgz",
         //: State of Germany: Brandenburg
         "toolTipText" : qsTr("Brandenburg"),
         "x" : "0.7576",
         "y" : "0.3359"
      },
      {
         "pixmapfile" : "germany/berlin.svgz",
         //: State of Germany: Berlin
         "toolTipText" : qsTr("Berlin"),
         "x" : "0.7949",
         "y" : "0.3315"
      },
      {
         "pixmapfile" : "germany/bavaria.svgz",
         //: State of Germany: Bavaria
         "toolTipText" : qsTr("Bavaria"),
         "x" : "0.6046",
         "y" : "0.7778"
      },
      {
         "pixmapfile" : "germany/baden-wurttemberg.svgz",
         //: State of Germany: Baden-Württemberg
         "toolTipText" : qsTr("Baden-Württemberg"),
         "x" : "0.3416",
         "y" : "0.808"
      }
   ]
}
