#Set everything up

from pathlib import Path
import sys
import os

CONTENT_IMAGE=str(sys.argv[1])
STYLE_IMAGE=str(sys.argv[2])
CONTENT_WEIGHT=int(sys.argv[3])
STYLE_WEIGHT=int(sys.argv[4])
STYLE_SCALE=int(sys.argv[5])
ORIGINAL_COLORS=sys.argv[6]
multipleimages=False

content=Path(CONTENT_IMAGE).stem
style=Path(STYLE_IMAGE).stem
cw=str(CONTENT_WEIGHT)
sw=str(STYLE_WEIGHT)
scale=str(STYLE_SCALE)
oc=str(ORIGINAL_COLORS)

OUT_DIR=content+"_"+style+"_"+cw+"_"+sw+"_"+scale+"_"+oc
os.makedirs(OUT_DIR, exist_ok=True)

if ',' in STYLE_IMAGE:
    multipleimages=True
	
os.system("python3 strotss.py --weight 0.25 --output " + OUT_DIR + "/out25.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)

os.system("python3 strotss.py --weight 0.50 --output " + OUT_DIR + "/out50.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)

os.system("python3 strotss.py --weight 0.75 --output " + OUT_DIR + "/out75.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)

os.system("python3 strotss.py --weight 1.00 --output " + OUT_DIR + "/out100.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)
