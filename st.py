#Set everything up

from pathlib import Path
import sys
import os

CONTENT_IMAGE=str(sys.argv[1])
STYLE_IMAGE=str(sys.argv[2])

content=Path(CONTENT_IMAGE).stem
style=Path(STYLE_IMAGE).stem

OUT_DIR="strotss"+content+style
os.makedirs(OUT_DIR, exist_ok=True)

print("python3 strotss.py --weight 0.25 --output " + OUT_DIR + "/out25.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)

os.system("python3 strotss.py --weight 0.25 --output " + OUT_DIR + "/out25.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)

os.system("python3 strotss.py --weight 0.50 --output " + OUT_DIR + "/out50.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)

os.system("python3 strotss.py --weight 0.75 --output " + OUT_DIR + "/out75.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)

os.system("python3 strotss.py --weight 1.00 --output " + OUT_DIR + "/out100.png " + CONTENT_IMAGE + " " + STYLE_IMAGE)
