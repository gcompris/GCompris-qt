import QtQuick 2.2

Planegame {

    dataset: [
        {
            data: "0 1 2 3 4 5 6 7 8 9 10".split(" "),
            showNext: true
        },
        {
            data: "10 11 12 13 14 15 16 17 18 19 20".split(" "),
            showNext: true
        },
        {
            data: "0 1 2 3 4 5 6 7 8 9 10".split(" "),
            showNext: false
        },
        {
            data: "10 11 12 13 14 15 16 17 18 19 20".split(" "),
            showNext: false
        }
    ]
}
