
DialogBackground {
    visible: false
    title: qsTr("About GCompris")
    subtitle: qsTr("GCompris Home Page: http://gcompris.net")

    property string translators: qsTr("Here will be the name of the translators")
    property string version: "0.4"

    content: "<center><b>" + "GCompris Qt " + version + "</b></center>" + "<br/>" +
             translators + "<br/>" +
             "<center><b>" + "Copyright 2000-2014 Bruno Coudoin and Others" + "</b></center>" + "<br/>"
}
