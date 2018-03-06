/* GCompris - DialogAbout.qml
 *
 * Copyright (C) 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import QtQuick.Controls 1.5
import GCompris 1.0

/**
 * GCompris' full screen about dialog.
 * @ingroup infrastructure
 *
 * @sa DialogBackground
 */
DialogBackground {
    visible: false
    title: qsTr("About GCompris")
    button0Text: qsTr("License")
    onButton0Hit: { licenseContainer.visible = true }

    File {
        id: licenseFile
        name: "qrc:/gcompris/src/core/COPYING"
        onError: print(msg)
    }
    
    DialogBackground {
        id: licenseContainer
        visible: false
        anchors.fill: parent
        title: qsTr("License")
        onVisibleChanged: {
            if(!content) {
                content = licenseFile.read()
            }
        }
        onClose: visible = false
    }

    //: Replace this string with your names, one name per line.
    property string translators: qsTr("translator-credits") ===
                                 "translator-credits" ? "" : qsTr("translator-credits") + "<br/>"
    // Let's try to maitain here the contributor list sorted by number of commits
    // git shortlog -se | sort -nr | cut -c8- | sed 's/ <.*>/,/' | xargs
    property string developers: "Bruno Coudoin, Johnny Jazeix, Holger Kaelberer, Timothée Giet, Rajdeep Kaur, Siddhesh Suthar, Aruna Sankaranarayanan, Stephane Mankowski, Thibaut Romain, Akshat Tandon, Yuri Chornoivan, Manuel Tondeur, Ayush Agrawal, Pulkit Gupta, Stefan Toncu, Ilya Bizyaev, Bharath M S, Yuri Chornoivan, JB BUTET, Emmanuel Charruau, Divyam Madaan, Rudra Nil Basu, Arkit Vora, Luigi Toscano, Amit Tomar, Anu Mittal, Chaitanya KS, Imran Tatriev, Nitish Chauhan, Sergey Popov, Yask Srivastava, Shashwat Dixit, Sayan Biswas, Artur Puzio, Utkarsh Tiwari, Andrey Cygankov, Horia PELLE, Harpreet S, rahul yadav, Aseem Arora, Amit Sagtani"

    property string gcVersion: ApplicationInfo.GCVersion
    property string qtVersion: ApplicationInfo.QTVersion
    property string gcVersionTxt: qsTr("GCompris %1").arg(gcVersion)
    property string qtVersionTxt: qsTr("Based on Qt %1").arg(qtVersion)

    content:
        "<center><b>" + "<a href='http://gcompris.net'>" +
        qsTr("GCompris Home Page: http://gcompris.net") + "</a>" +
        "</b></center>" +
        "<center>" + gcVersionTxt + " " + qtVersionTxt + "</center>" + "<br/>" +

        "<img align='right' width='" + 320 * ApplicationInfo.ratio +
        "' height='" + 114 * ApplicationInfo.ratio + "' src='qrc:/gcompris/src/core/resource/gcompris.png'/>" +

        qsTr("<b>GCompris</b> is a Free Software developed within the KDE community.") +

        "<br /> <br />" +

        qsTr("<b>KDE</b> is a world-wide network of software engineers, artists, writers, translators and facilitators " +
             "who are committed to <a href=\"%1\">Free Software</a> development. " +
             "This community has created hundreds of Free Software applications as part of the KDE " +
             "frameworks, workspaces and applications.<br /><br />" +
             "KDE is a cooperative enterprise in which no single entity controls the " +
             "efforts or products of KDE to the exclusion of others. Everyone is welcome to join and " +
             "contribute to KDE, including you.<br /><br />" +
             "Visit <a href=\"%2\">%2</a> for " +
             "more information about the KDE community and the software we produce.")
        .arg("http://www.gnu.org/philosophy/free-sw.html")
        .arg("http://www.kde.org/") +

        "<img align='right' width='" + 138 * ApplicationInfo.ratio +
        "' height='" + 202 * ApplicationInfo.ratio + "' src='qrc:/gcompris/src/core/resource/aboutkde.png'/>" +

        "<br /> <br />" +

        qsTr("Software can always be improved, and the KDE team is ready to " +
             "do so. However, you - the user - must tell us when " +
             "something does not work as expected or could be done better.<br /><br />" +
             "KDE has a bug tracking system. Visit " +
             "<a href=\"%1\">%1</a> to report a bug.<br /><br />" +
             "If you have a suggestion for improvement then you are welcome to use " +
             "the bug tracking system to register your wish. Make sure you use the " +
             "severity called \"Wishlist\".")
        .arg("https://bugs.kde.org/") +

        "<br /> <br />" +

        qsTr("You do not have to be a software developer to be a member of the " +
             "KDE team. You can join the national teams that translate " +
             "program interfaces. You can provide graphics, themes, sounds, and " +
             "improved documentation. You decide!" +
             "<br /><br />" +
             "Visit " +
             "<a href=\"%1\">%1</a> " +
             "for information on some projects in which you can participate." +
             "<br /><br />" +
             "If you need more information or documentation, then a visit to " +
             "<a href=\"%2\">%2</a> " +
             "will provide you with what you need.")
        .arg("http://www.kde.org/community/getinvolved/")
        .arg("http://techbase.kde.org/") +

        "<br /> <br />" +

        qsTr("To support development the KDE community has formed the KDE e.V., a non-profit organization " +
             "legally founded in Germany. KDE e.V. represents the KDE community in legal and financial matters. " +
             "See <a href=\"%1\">%1</a>" +
             " for information on KDE e.V.<br /><br />" +
             "KDE benefits from many kinds of contributions, including financial. " +
             "We use the funds to reimburse members and others for expenses " +
             "they incur when contributing. Further funds are used for legal " +
             "support and organizing conferences and meetings. <br /> <br />" +
             "We would like to encourage you to support our efforts with a " +
             "financial donation, using one of the ways described at " +
             "<a href=\"%2\">%2</a>." +
             "<br /><br />Thank you very much in advance for your support.")
        .arg("http://ev.kde.org/")
        .arg("http://www.kde.org/community/donations/") +

        "<br /> <br />" +

        qsTr("<b>A big thanks to the development team:</b> %1").arg(developers) +

        "<br /> <br />" +

        qsTr("<b>A big thanks to the translation team:</b> %1")
        .arg(translators) +

        "<br/><center><b>" + "Copyright 2000-2018 Timothée Giet and Others" + "</b></center>" + "<br/>"
}
