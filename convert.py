import os
startSvgTag = """<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1"
xmlns="http://www.w3.org/2000/svg"
xmlns:xlink="http://www.w3.org/1999/xlink"
width="240px" height="240px" viewBox="0 0 240 240">"""

endSvgTag = """</svg>"""
if not os.path.exists('./your_SVGs_here'):
	os.mkdir('your_SVGs_here')
for files in os.listdir("."):
    if files.endswith(".png"):
        pngFile = open(files, 'rb')
        base64data = pngFile.read().encode("base64").replace('\n', '')
        base64String = '<image xlink:href="data:image/png;base64,{0}" width="240" height="240" x="0" y="0" />'.format(
            base64data)

        f = open(os.getcwd()+ "/your_SVGs_here/" +os.path.splitext(files)[0] + ".svg", 'w')
        f.write(startSvgTag + base64String + endSvgTag)
        print 'Converted ' + files + ' to ' + os.path.splitext(files)[0] + ".svg"
