# Then multires based on neural-style-pt...
# Example based on: https://github.com/ProGamerGov/neural-style-pt/blob/master/examples/scripts/starry_stanford.sh

#Set everything up

from pathlib import Path
import sys
import os

CONTENT_IMAGE=str(sys.argv[1])
STYLE_IMAGE=str(sys.argv[2])
CONTENT_WEIGHT=str(sys.argv[3])
STYLE_WEIGHT=str(sys.argv[4])
STYLE_SCALE=str(sys.argv[5])
ORIGINAL_COLORS=(sys.argv[6])
multipleimages=False
colorTransfer=False

content=Path(CONTENT_IMAGE).stem
style=Path(STYLE_IMAGE).stem
cw=str(CONTENT_WEIGHT)
sw=str(STYLE_WEIGHT)
scale=str(STYLE_SCALE)
oc=str(ORIGINAL_COLORS)

if ',' in STYLE_IMAGE:
    multipleimages=True
	
if ORIGINAL_COLORS == "0" and multipleimages == False:
	colorTransfer=True	

if multipleimages == False:
	OUT_DIR="MyDrive/neuralstyle/"+content+"_"+style+"_"+cw+"_"+sw+"_"+scale+"_"+oc
else:
	style=os.path.splitext(STYLE_IMAGE)
	stylelist=style[0].split(",")
	print(stylelist)
	laststyle=str(stylelist[-1])
	print(laststyle)
	OUT_DIR="MyDrive/neuralstyle/"+content+"_"+laststyle+"_"+cw+"_"+sw+"_"+scale+"_"+oc
		
print(OUT_DIR)	
	
os.makedirs(OUT_DIR, exist_ok=True)