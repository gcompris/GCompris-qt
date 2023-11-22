/* GCompris - DialogAbout.qml
 *
 * SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
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
    property string developers: "Bruno Coudoin, Timothée Giet, Johnny Jazeix, Holger Kaelberer, Akshat Tandon, Rajdeep Kaur, Aman Kumar Gupta, Siddhesh Suthar, Yuri Chornoivan, Aruna Sankaranarayanan, Stephane Mankowski, Amit Tomar, Thibaut ROMAIN, Deepak Kumar, Aiswarya Kaitheri Kandoth, Amit Sagtani, Ilya Bizyaev, Pulkit Gupta, Shubham Mishra, Karl Ove Hufthammer, Mariam Fahmy, Harsh Kumar, Stefan Toncu, Divyam Madaan, SagarC Agarwal, Ganesh Harshan, Ayush Agrawal, Manuel Tondeur, Horia PELLE, Rudra Nil Basu, Harry Mecwan, Akshay Kumar, Emmanuel Charruau, Burkhard Lück, Antoni Bella Pérez, Bharath M S, Per Andersson, JB BUTET, Himanshu Vishwakarma, Aastha Chauhan, Samarth Raj, Rohit Das, Arkit Vora, Anant Verma, Séamus Ó Briain, Sergey Popov, Sambhav Kaul, Nitish Chauhan, Lionel Duboeuf, Jonathan Riddell, Imran Tatriev, Harpreet S, Harald H, Alexis Breton, Aleix Pol, Rahul Yadav, Souradeep Barua, Sai Moukthik Konduru, Riccardo Iaconelli, Rajat Asthana, Kent VanderVelden, Billy Laws, Aseem Arora, Alexander Potashev, Varun Patel, Utkarsh Tiwari, Parth Partani, Paolo Gibellini, Nick Richards, Luigi Toscano, Luciano Montanaro, Lionel Duboeuf, Isabelle Le Nabat, Envel Kervoas, Tõnis Piirits, Daniel Shahaf, Christophe Chabanois, Chaitanya KS, B.J. Cupps, Anu Mittal, Antos Vaclauski, André Marcelo Alvarenga, Łukasz Wojniłowicz, Ömer Fadıl Usta, Ynon Perek, Yask Srivastava, Volker Krause, Thiago Masato Costa Sueto, Stefan Asserhäll, Smit S. Patil, Shashwat Dixit, Sayan Biswas, Răpițeanu Viorel-Cătălin, Rohan Rashinkar, Rishabh Gupta, Pino Toscano, Peter Eszlari, Nicolas Fella, Mantas Kriaučiūnas, Joshua Shreve, Jose Riha, Jonathan Demeyer, Jiri Bohac, Jesús Espino, Hannah von Reth, Frederico Goncalves Guimaraes, Edgar HIPP, Djalil Mesli, Dawid Wróbel, Clément Coudoin, Bob Stouffer, Bharath Brat, Besnik Bleta, Avinash Sonawane, Artur Puzio, Arnold Dumas, Anuj Yadav, Andrey Cygankov, Alex Kovrigin, Aditya Suthar, Abhay Kaushik"

    property string gcVersion: ApplicationInfo.GCVersion
    property string qtVersion: ApplicationInfo.QTVersion
    property string openSslVersion: ApplicationInfo.OpenSSLVersion
    property string gcVersionTxt: qsTr("GCompris %1").arg(gcVersion)
    //! first string is the version of Qt, second is the version of openSSL. The second string is something like: "OpenSSL 1.1.1m 14 Dec 2021"
    property string qtVersionTxt: qsTr("Based on Qt %1 and %2").arg(qtVersion).arg(openSslVersion)

    content:
        "<center style='color:#00000000'>.<img width='" +
        320 * ApplicationInfo.ratio + "' height='" + 114 * ApplicationInfo.ratio +
        "' src='qrc:/gcompris/src/core/resource/gcompris-logo-full.svg'/>.</center>
        <center><b><a href='https://gcompris.net'>" +
        qsTr("GCompris Home Page: https://gcompris.net") + "</a></b></center>
        <center>" + gcVersionTxt + " " + qtVersionTxt + "</center><br/>" +
        //: Replace the link with the page in your language if it exists, else keep the english page link
        qsTr("You can provide financial support for the development of <b>GCompris</b>, please visit " +
              "<a href='https://gcompris.net/donate-en.html'>https://gcompris.net/donate-en.html</a>.") +

        "<br />" +

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
        .arg("https://www.gnu.org/philosophy/free-sw.html")
        .arg("https://www.kde.org/") +

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
             "KDE team. You can join the language teams that translate " +
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
        .arg("https://www.kde.org/community/getinvolved/")
        .arg("https://techbase.kde.org/") +

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
        .arg("https://ev.kde.org/")
        .arg("https://www.kde.org/community/donations/") +

        "<br /> <br />" +

        qsTr("<b>A big thanks to the development team:</b> %1").arg(developers) +

        "<br /> <br />" +

        qsTr("<b>A big thanks to the translation team:</b> %1")
        .arg(translators) +

        "<br/><center><b>" + "Copyright 2000-2023 Timothée Giet and Others" + "</b></center>" + "<br/>"
}
