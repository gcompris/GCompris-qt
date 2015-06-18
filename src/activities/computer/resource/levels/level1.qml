import QtQuick 2.0

QtObject {
    property variant levels : [
        {
            "pixmapfile" : "images/monitor.svg" ,
            "name"       : "Monitor" ,
            "text"       : qsTr("A monitor or a display is an electronic visual display for computers. The monitor comprises the display device, circuitry and an enclosure."),
        } ,
        {
            "pixmapfile" : "images/cpu.svg",
            "name"       : "Central Processing Unit" ,
            "text"       : qsTr(" central processing unit (CPU) is the electronic circuitry within a computer that carries out the instructions of a computer program by performing the basic arithmetic, logical, control and input/output (I/O) operations specified by the instructions. ")
        } ,
        {
            "pixmapfile" : "images/keyboard.svg" ,
            "name"       : "Keyboard" ,
            "text"       : qsTr(" the keyboard is used as a text entry interface to type text and numbers into a word processor, text editor or other programs.A keyboard is also used to give commands to the operating system of a computer"),
        },
        {
            "pixmapfile" : "images/mouse.svg",
            "name"       :"Mouse" ,
            "text"       : qsTr("In computing, a mouse is a pointing device that detects two-dimensional motion relative to a surface. This motion is typically translated into the motion of a pointer on a display, which allows for fine control of a graphical user interface."),
        }
    ]

}
