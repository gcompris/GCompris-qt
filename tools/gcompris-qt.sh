#!/bin/sh
export LD_LIBRARY_PATH=$(dirname $0)
## uncomment the line below in case of too fast animations, with nvidia drivers especially...
#export QSG_RENDER_LOOP=basic
$(dirname $0)/gcompris-qt

