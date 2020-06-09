#Set everything up

from pathlib import Path
import os

CONTENT_IMAGE="out100.png"
STYLE_IMAGE="deep.jpg"
CONTENT_WEIGHT=int(50)
STYLE_WEIGHT=int(1000)
STYLE_SCALE=int(1)
ORIGINAL_COLORS=0
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
	
#Run STROTSS first...

!python3 strotss.py --weight 0.25 --output out25.png $CONTENT_IMAGE $STYLE_IMAGE
!python3 strotss.py --weight 0.5 --output out50.png $CONTENT_IMAGE $STYLE_IMAGE
!python3 strotss.py --weight 0.75 --output out75.png $CONTENT_IMAGE $STYLE_IMAGE
!python3 strotss.py --weight 1 --output out100.png $CONTENT_IMAGE $STYLE_IMAGE