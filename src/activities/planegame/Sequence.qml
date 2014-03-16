import QtQuick 2.0

Planegame {

    dataset: [
        {
            data: qsTr("0 1 2 3 4 5 6 7 8 9 10").split(" "),
            showNext: true
        },
        {
            data: qsTr("10 11 12 13 14 15 16 17 18 19 20").split(" "),
            showNext: true
        },
        {
            data: qsTr("0 1 2 3 4 5 6 7 8 9 10").split(" "),
            showNext: false
        },
        {
            data: qsTr("10 11 12 13 14 15 16 17 18 19 20").split(" "),
            showNext: false
        }
    ]
}
