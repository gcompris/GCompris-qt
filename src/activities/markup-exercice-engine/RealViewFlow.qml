import QtQuick
import QtQuick.Layouts

import "markup-exercice-engine.js" as Activity

FlexboxLayout {
    id: flexLayout

    // 1. S'assurer qu'il prend toute la largeur disponible de la colonne parente
    Layout.fillWidth: true

    // 2. Forcer le calcul de la hauteur en se basant sur la largeur actuelle
    // et les éléments qu'il contient (évite le blocage sur une seule ligne)
    implicitHeight: childrenRect.height > 0 ? childrenRect.height : 25

    wrap: FlexboxLayout.Wrap
    direction: FlexboxLayout.Row
    justifyContent: FlexboxLayout.JustifyStart
}

// FlexboxLayout.JustifyStart	(default) Items are aligned to the start of the flex box layout.
// FlexboxLayout.JustifyCenter	Items are aligned along the center of the flex box layout.
// FlexboxLayout.JustifyEnd	Items are aligned to the end of the flex box layout.
// FlexboxLayout.JustifySpaceBetween	The spaces are evenly distributed between the items and no space along the edges of the flex box layout.
// FlexboxLayout.JustifySpaceAround	The spaces are evenly distributed between the items and half-size space on the edges of the flex box layout.
// FlexboxLayout.JustiftSpaceEvenly