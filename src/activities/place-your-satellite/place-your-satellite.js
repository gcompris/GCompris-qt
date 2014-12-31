
/* GCompris - place-your-satellite.js
 *
  * Copyright (C) 2014 <YOUR NAME HERE>
   *
    * Authors:
     *   <THE GTK VERSION AUTHOR> (GTK+ version)
      *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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
var planetDataset = [['EARTH', 6000000000000000000000000, '12800'], ['SATURN', 600000000000000000000000000, '116464'], ['JUPITER', '2*10^27', '139822'], ['SUN', '2*10^30', '1391684'], ['67PComet', '1.0*10^13', '4']]
//var satelliteDataset = [['SPOUTNIK','84' ], ['InternationalSpaceShip', '400000'], ['ROSETTA','3000' ]]
var satelliteDataset = [['InternationalSpaceShip', '400000'], ['satellite', '3000']]
var url = "qrc:/gcompris/src/activities/place-your-satellite/"

var currentLevel = 0
var numberOfLevel = 1
var items

var massObjectName = planetDataset[0][0]
var massObjectMass = planetDataset[0][1]
var massObjectDiameter = planetDataset[0][2]

var satObjectName = satelliteDataset[0][0]
var satObjectMass = satelliteDataset[0][1]
var satObjectDiameter = satelliteDataset[0][2]

var distance,G
var speedX
var speedY, Ec_massique, Em_massique, Ep_massique
var position, speed, points
var t, dt, listT,a, listPoints, listPointsPix
var y0=[]
var x0=[]


function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1

    //feed left Menu : satellite Menu
    for (var i = 0; i < satelliteDataset.length; i++) {

        items.satList.append({
                                 name: satelliteDataset[i][0],
                                 image: satelliteDataset[i][1]
                             })
    }

    //feed Right Menu : Mass Menu
    for (var j = 0; j < planetDataset.length; j++) {

        items.massList.append({
                                  name: planetDataset[j][0],
                                  image: planetDataset[j][1]
                              })
    }
}

function massChanged(massNb) {

    massObjectName = planetDataset[massNb][0]
    massObjectMass = planetDataset[massNb][1]
    massObjectDiameter = planetDataset[massNb][2]
    console.log("changement d'objet central", massObjectName)
}

function calcparameters() {
    //distance in m
    distance = items.slidDistance.value*1000

    speedX = items.slidSpeed.value*Math.cos(items.arrowSatAngle/180*Math.PI)
    speedY = items.slidSpeed.value*Math.sin(items.arrowSatAngle/180*Math.PI)

    console.log('rrrrrr', distance, speedX, speedY,items.arrowSatAngle )
    G = 0.0000000000667259

    //    Energy calculation
    Ec_massique = 0.5*(Math.pow(speedX,2) + Math.pow(speedY,2))
    Ep_massique = -massObjectMass*G/(distance)

    Em_massique=Ec_massique+Ep_massique
    if (Em_massique >= 0){
        //too much energy. It can't sattelite

        console.log('toomuche energy')
       // explanation = "Ce n'est pas un satellite. \nL'énergie mécanique initiale est positive, l'objet lancé échappera à l'attraction de l'astre. Une partie de la trajectoire est dessinée"
        t=2*Math.PI*Math.sqrt((Math.pow(distance,3)/massObjectMass/G))
       // console.log('t', t, massObjectMass,Ec_massique, Ep_massique)
        dt=t/1000
    }
    else{
    //   # calcul du grand axe a : Em = -k/2a pour une trajectoire elliptique
    //   # donc a = -k/2Em
         a = -massObjectMass*G/2/Em_massique

    //   # calcul de la période, en utilisant la troisième loi de Kepler
    //                # T²=4pi²/MG*a³
         t = 2*Math.PI*Math.sqrt((Math.pow(a,3)/massObjectMass/G))
       // console.log('t', t,'a',a,Ec_massique, Ep_massique)
        dt=t/1000
         //dt = t/1000
    //            self.debug(5,u"masse astre %s" %self.masse_astre)
   //console.log('good energy', t, dt, massObjectMass, G, a,Ep_massique,distance, Em_massique, Ec_massique)

    }
    //New gravitation field
    //gAstre = newGravField([0,0,0],massAstre)
    position = [distance, 0, 0]  //x, y,z
    speed = [speedX,speedY,0.0]  //vx,vy,vz
    calcul()

}

function derivs(x,t){
    //calcul de la dérivée du vecteur à 6 composantes position,vitesse
  // console.assert(x.length===6, "good !")

   var  g = gravField(x.slice(0,3),[0,0,0],massObjectMass)       // le champ de gravité

    //console.log('g', g,x,t)
    return [x[3],               // vitesse x
            x[4],               //# vitesse y
            x[5],                // vitesse z
            g[0],                // acceleration x
            g[1],                // acceleration y
            g[2]] // acceleration z
}

function rk4(y0, t){
//    """
//    C'est le code de rk4 pris dans le module matplotplib.

//    Liste des paramètres d'entrée

//    derivs :
//      une fonction qui accepte en entrée un 6-uplet position,vitesse
//      et le papramètre temps, et qui renvoie en sortie un 6-uplet de dérivées.
//    y0 :
//      un 6-uplet représentant la position et la vitesse initiales
//    t :
//      une liste de dates régulièrement espacées pour lesquelles on veut
//      construire les points et vitessesde la trajectoire

//    Résultat de la fonction :
//      une liste de 6-uplets représentant les positions et vitesses aux
//      instants de la liste des dates données.
//    """
   // console.log(y0)
    var yout=[]
    yout[0] = y0

    for (var i=0;i<t.length-1;i++){
        var thist = t[i]
       //console.log(thist)
        var dt = t[i+1] - thist
        var  dt2 = dt/2.0
        y0 = yout[i]
        var  k1 = derivs(y0, thist)
       // if(i<3){ console.log("k1",k1)}

        var k1add=[]
        var k2add=[]
        var k3add=[]
        var k4add=[]

        for (var j=0; j<6; j++){
           // console.log(y0,k1,dt2)
           k1add[j]  = y0[j] + dt2*k1[j]
        }
        var k2 = derivs(k1add, thist+dt2)
       // if(i<3){ console.log("k2",k2)}

        for (var j=0; j<6; j++){
           k2add[j]  = y0[j] + dt2*k2[j]
        }
        var  k3 = derivs(k2add, thist+dt2)
      //  if(i<3){ console.log("k3",k3)}

        for (var j=0; j<6; j++){
           k3add[j]  = y0[j] + dt2*k3[j]
        }

        var  k4 = derivs(k3add, thist+dt)
       // if(i<3){ console.log("k4",k4)}

        yout[i+1] = []
        for (var j=0; j<6; j++){
            yout[i+1][j] = y0[j] + dt/6.0*(k1[j] + 2*k2[j] + 2*k3[j] + k4[j])
        }
       // if(i<3){ console.log("yout",yout)}

       // if(i<3){console.log(yout.length) }
    }
   // console.log(yout[3],yout[20], yout.length)
    return yout
}

function extractXY(yout){
    //This function takes a list of  6-uplets, with [x,y,z,vx,vy,vz] coordinates
    //It transforms it in a 2D-Vector to be drawn

    listPoints = []
    listPointsPix = []
    for (var j=0; j<points.length; j++){
        if(j%8==0){ //we draw only one point over 8
            listPoints[j/8] = points[j].slice(0,2)
            listPointsPix[j/8] = [Math.round(150*listPoints[j/8][0]/a), Math.round(150*listPoints[j/8][1]/a)]
            //if(j==1000){ console.log("listePoints",listPoints[j],a,listPointsPix)}
        }


    }
    console.log("listePoints",a,listPointsPix)
    items.trajecCanvas.requestPaint()


}

function calcul(){
    //"""lance le calcul de la trajectoire à l'aide de l'algorithme de
    //Runge-Kutta qui est d'ordre 4 et rapide en même temps.
//    le résultat est dans self.pv, qui est une liste contenant
//    les 6-uplets position, vitesse.
//    """
    listT = []

    for (var i=0;i<1000;i++){
        listT[i] = i*dt
    }
    y0=position.concat(speed)
   // console.log(y0)
    points = rk4(y0, listT)
    extractXY(points)
    //console.log(points)
}



function gravField(x,x0,m){
    //Cette fonction renvoie une fonction anonyme représentant un champ
    //gravitationnel créé par un objet de masse m immobile aux coordonnées
    //spécifiées par x0.
    //le profil de la fonction résultat est :
    //(vecteur position -> vecteur accélération)

    return  [-0.0000000000667*m*(x[0]-x0[0])/Math.pow(Math.pow((x[0]-x0[0]),2)+Math.pow((x[1]-x0[1]),2)+Math.pow((x[2]-x0[2]),2),1.5),
                       -0.0000000000667*m*(x[1]-x0[1])/Math.pow(((x[0]-x0[0])*(x[0]-x0[0])+(x[1]-x0[1])*(x[1]-x0[1])+(x[2]-x0[2])*(x[2]-x0[2])),1.5),
                       -0.0000000000667*m*(x[2]-x0[2])/Math.pow((Math.pow((x[0]-x0[0]),2)+Math.pow((x[1]-x0[1]),2)+Math.pow((x[2]-x0[2]),2)),1.5)]
}


function satChanged(satNb) {

    satObjectName = satelliteDataset[satNb][0]
    satObjectMass = satelliteDataset[satNb][1]
    satObjectDiameter = satelliteDataset[satNb][2]
    console.log("chgt de satellite", satObjectName, satNb)
}

function nextLevel() {
    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel()
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel()
}
