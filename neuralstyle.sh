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
	
# Then multires based on neural-style-pt...
# Example based on: https://github.com/ProGamerGov/neural-style-pt/blob/master/examples/scripts/starry_stanford.sh

!python3 neural_style.py \
-content_image $CONTENT_IMAGE \
-style_image $STYLE_IMAGE -style_scale 1 \
-print_iter 100 -save_iter 0 -num_iterations 1000 -content_weight $CONTENT_WEIGHT -style_weight $STYLE_WEIGHT -image_size 256 \
-content_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
-style_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
-output_image $OUT_DIR/X0.png -tv_weight 0.00001 -gpu 0 -backend cudnn -cudnn_autotune

PREV=OUT_DIR+"/X0.png"

if ORIGINAL_COLORS == 0 and multipleimages == False:
    !python3 linear-color-transfer.py \
    --target_image $PREV \
    --source_image $STYLE_IMAGE \
    --mode chol \
    --output_image $OUT_DIR/histstyleX0.png
    PREV=OUT_DIR+"/histstyleX0.png"
    print(PREV)

!python3 neural_style.py \
-content_image $CONTENT_IMAGE \
-style_image $STYLE_IMAGE -init image \
-init_image $PREV -style_scale 1 -print_iter 50 -save_iter 0 \
-model_file models/nyud-fcn32s-color-heavy.pth \
-content_weight $CONTENT_WEIGHT -style_weight $STYLE_WEIGHT -image_size 512 -num_iterations 1000 \
-content_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
-style_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
-output_image $OUT_DIR/X1.png -tv_weight 0.00001 -gpu 0 -backend cudnn -cudnn_autotune

PREV=OUT_DIR+"/X1.png"

if ORIGINAL_COLORS == 0 and multipleimages == False:
    !python3 linear-color-transfer.py \
    --target_image $PREV \
    --source_image $STYLE_IMAGE \
    --mode chol \
    --output_image $OUT_DIR/histstyleX1.png
    PREV=OUT_DIR+"/histstyleX1.png"
    print(PREV)

!python3 neural_style.py \
-content_image $CONTENT_IMAGE \
-style_image $STYLE_IMAGE -init image \
-init_image $PREV -style_scale 1 -print_iter 50 -save_iter 0 \
-model_file models/nyud-fcn32s-color-heavy.pth \
-content_weight $CONTENT_WEIGHT -style_weight $STYLE_WEIGHT -image_size 800 -num_iterations 1500 \
-content_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
-style_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
-output_image $OUT_DIR/X2.png -tv_weight 0.00001 -gpu 0 -backend cudnn -cudnn_autotune

PREV=OUT_DIR+"/X2.png"

if ORIGINAL_COLORS == 0 and multipleimages == False:
    !python3 linear-color-transfer.py \
    --target_image $PREV \
    --source_image $STYLE_IMAGE \
    --mode chol \
    --output_image $OUT_DIR/histstyleX2.png
    PREV=OUT_DIR+"/histstyleX2.png"
    print(PREV)

STYLE_WEIGHT=(STYLE_WEIGHT/10)
CONTENT_WEIGHT=(CONTENT_WEIGHT/5)

!python3 neural_style.py \
-content_image $CONTENT_IMAGE \
-style_image $STYLE_IMAGE -init image \
-model_file models/nyud-fcn32s-color-heavy.pth \
-init_image $PREV -style_scale 1 -print_iter 50 -save_iter 0 \
-content_weight $CONTENT_WEIGHT -style_weight $STYLE_WEIGHT -image_size 1148 -num_iterations 200 \
-output_image $OUT_DIR/X3.png -tv_weight 0.00001 -gpu 0 -backend cudnn

PREV=OUT_DIR+"/X3.png"

if ORIGINAL_COLORS == 0 and multipleimages == False:
    !python3 linear-color-transfer.py \
    --target_image $PREV \
    --source_image $STYLE_IMAGE \
    --mode chol \
    --output_image $OUT_DIR/histstyleX3.png
    PREV=OUT_DIR+"/histstyleX3.png"
    print(PREV)

STYLE_WEIGHT=1000
CONTENT_WEIGHT=0

!python3 neural_style.py \
-content_image $CONTENT_IMAGE \
-style_image $STYLE_IMAGE -init image \
-model_file models/channel_pruning.pth \
-init_image $PREV -style_scale 1 -print_iter 50 -save_iter 0 \
-content_weight $CONTENT_WEIGHT -style_weight $STYLE_WEIGHT -image_size 1800 -num_iterations 200 \
-output_image $OUT_DIR/X4.png -tv_weight 0 -gpu 0 -backend cudnn -optimizer adam

PREV=OUT_DIR+"/X4.png"

if ORIGINAL_COLORS == 0 and multipleimages == False:
    !python3 linear-color-transfer.py \
    --target_image $PREV \
    --source_image $STYLE_IMAGE \
    --mode chol \
    --output_image $OUT_DIR/histstyleX4.png
    PREV=OUT_DIR+"/histstyleX4.png"
    print(PREV)

!python3 neural_style.py \
-content_image $CONTENT_IMAGE \
-style_image $STYLE_IMAGE -init image \
-init_image $PREV -style_scale 1 -print_iter 50 -save_iter 0 \
-model_file models/nin_imagenet.pth \
-content_weight $CONTENT_WEIGHT -style_weight $STYLE_WEIGHT -image_size 2400 -num_iterations 200 \
-content_layers relu0,relu1,relu2,relu3,relu5,relu6,relu7,relu8 \
-style_layers relu0,relu1,relu2,relu3,relu5,relu6,relu7,relu8 \
-output_image $OUT_DIR/X5.png -tv_weight 0 -gpu 0 -backend cudnn -optimizer adam

PREV=OUT_DIR+"/X5.png"

if ORIGINAL_COLORS == 0 and multipleimages == False:
    !python3 linear-color-transfer.py \
    --target_image $PREV \
    --source_image $STYLE_IMAGE \
    --mode chol \
    --output_image $OUT_DIR/histstyleX5.png
    PREV=OUT_DIR+"/histstyleX5.png"
    print(PREV)

!python3 neural_style.py \
-content_image $CONTENT_IMAGE \
-style_image $STYLE_IMAGE -init image \
-init_image $PREV -style_scale 1 -print_iter 50 -save_iter 0 \
-content_weight $CONTENT_WEIGHT -style_weight $STYLE_WEIGHT -image_size 2700 -num_iterations 200 \
-model_file models/nin_imagenet.pth \
-content_layers relu0,relu1,relu2,relu3,relu5,relu6 \
-style_layers relu0,relu1,relu2,relu3,relu5,relu6 \
-output_image $OUT_DIR/X6.png -tv_weight 0 -gpu 0 -backend cudnn -optimizer adam

PREV=OUT_DIR+"/X6.png"

if ORIGINAL_COLORS == 0 and multipleimages == False:
    !python3 linear-color-transfer.py \
    --target_image $PREV \
    --source_image $STYLE_IMAGE \
    --mode chol \
    --output_image $OUT_DIR/histstyleX6.png
    PREV=OUT_DIR+"/histstyleX6.png"
    print(PREV)

!python3 neural_style.py \
-content_image $CONTENT_IMAGE \
-style_image $STYLE_IMAGE -init image \
-init_image $PREV -style_scale 1 -print_iter 50 -save_iter 0\
-model_file models/nin_imagenet.pth \
-content_layers relu0,relu1,relu2,relu3,relu5,relu6,relu7,relu8 \
-style_layers relu0,relu1,relu2,relu3,relu5,relu6,relu7,relu8 \
-content_weight $CONTENT_WEIGHT -style_weight $STYLE_WEIGHT -image_size 2900 -num_iterations 200 \
-output_image $OUT_DIR/X7.png -tv_weight 0 -gpu 0 -backend cudnn -optimizer adam

PREV=OUT_DIR+"/X7.png"

if ORIGINAL_COLORS == 0 and multipleimages == False:
    !python3 linear-color-transfer.py \
    --target_image $PREV \
    --source_image $STYLE_IMAGE \
    --mode chol \
    --output_image $OUT_DIR/histstyleX7.png
    PREV=OUT_DIR+"/histstyleX7.png"
    print(PREV) 
