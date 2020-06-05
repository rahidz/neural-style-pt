CONTENT_IMAGE=$1
STYLE_IMAGE=$2
CONTENT_WEIGHT=$3
STYLE_WEIGHT=$4
STYLE_SCALE=$5
ORIGINAL_COLORS=$6
multipleimages=false
STYLE_WEIGHT2=$((STYLE_WEIGHT*5)) # Style weight for image size 2048 and above

if [[ $2 = *","* ]];
then
	multipleimages=true
else
	multipleimages=false
fi

X2_SIZE=800

content=$(basename ${1%.*})
style=$(basename ${2%.*})
cw=$(basename ${3%.*})
sw=$(basename ${4%.*})
scale=$(basename ${5%.*})
oc=$(basename ${6%.*})

OUT_DIR="$content-$style-$3-$4-$5-$6-large/"
mkdir -p $OUT_DIR

PYTHON=python3
SCRIPT=neural_style.py
GPU=0

NEURAL_STYLE=$PYTHON
NEURAL_STYLE+=" "
NEURAL_STYLE+=$SCRIPT

$NEURAL_STYLE \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -style_scale $STYLE_SCALE \
  -print_iter 100 \
  -save_iter 100 \
  -content_weight $CONTENT_WEIGHT \
  -style_weight $STYLE_WEIGHT \
  -image_size 256 \
  -num_iterations 1000 \
  -content_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
  -style_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
  -output_image $OUT_DIR/X0.png \
  -original_colors $ORIGINAL_COLORS \
  -tv_weight 0.00001 \
  -gpu $GPU \
  -backend cudnn -cudnn_autotune
  
PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

if [ $ORIGINAL_COLORS == 0 -a $multipleimages == false ];
then

	python3 ../Neural-Tools/linear-color-transfer.py \
	--target_image $PREV \
	--source_image ${STYLE_IMAGE##*,} \
	--mode chol \
	--output_image "${PREV%.*}-$content-$style-$cw-$sw-histfinal".png

	PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

fi

$NEURAL_STYLE \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $PREV \
  -style_scale $STYLE_SCALE \
  -save_iter 100 \
  -print_iter 100 \
  -content_weight $CONTENT_WEIGHT \
  -style_weight $STYLE_WEIGHT \
  -image_size 512 \
  -num_iterations 1000 \
  -content_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
  -style_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
  -output_image $OUT_DIR/X1.png \
  -tv_weight 0.00001 \
  -original_colors $ORIGINAL_COLORS \
  -gpu $GPU \
  -backend cudnn -cudnn_autotune
  
PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

if [ $ORIGINAL_COLORS == 0 -a $multipleimages == false ];
then

	python3 ../Neural-Tools/linear-color-transfer.py \
	--target_image $PREV \
	--source_image ${STYLE_IMAGE##*,} \
	--mode chol \
	--output_image "${PREV%.*}-$content-$style-$cw-$sw-histfinal".png

	PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

fi

CONTENT_WEIGHT=$((CONTENT_WEIGHT/5))
STYLE_WEIGHT=$((STYLE_WEIGHT/10))

$NEURAL_STYLE \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $PREV \
  -style_scale $STYLE_SCALE \
  -print_iter 100 \
  -save_iter 250 \
  -content_weight $CONTENT_WEIGHT \
  -style_weight $STYLE_WEIGHT \
  -image_size 800 \
  -num_iterations 1500 \
  -content_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
  -style_layers relu1_1,relu2_1,relu3_1,relu4_1,relu5_1 \
  -output_image $OUT_DIR/X2.png \
  -tv_weight 0.00001 \
  -original_colors $ORIGINAL_COLORS \
  -gpu $GPU \
  -backend cudnn -cudnn_autotune
  
PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

if [ $ORIGINAL_COLORS == 0 -a $multipleimages == false ];
then

	python3 ../Neural-Tools/linear-color-transfer.py \
	--target_image $PREV \
	--source_image ${STYLE_IMAGE##*,} \
	--mode chol \
	--output_image "${PREV%.*}-$content-$style-$cw-$sw-histfinal".png

	PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

fi

$NEURAL_STYLE \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $PREV \
  -style_scale $STYLE_SCALE \
  -print_iter 50 \
  -save_iter 100 \
  -content_weight $CONTENT_WEIGHT \
  -style_weight $STYLE_WEIGHT2 \
  -optimizer adam \
  -learning_rate 1 \
  -image_size 1148 \
  -num_iterations 200 \
  -output_image $OUT_DIR/X3.png \
  -tv_weight 0 \
  -original_colors $ORIGINAL_COLORS \
  -gpu $GPU \
  -backend cudnn
  
PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

if [ $ORIGINAL_COLORS == 0 -a $multipleimages == false ];
then

	python3 ../Neural-Tools/linear-color-transfer.py \
	--target_image $PREV \
	--source_image ${STYLE_IMAGE##*,} \
	--mode chol \
	--output_image "${PREV%.*}-$content-$style-$cw-$sw-histfinal".png

	PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

fi

$NEURAL_STYLE \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $PREV \
  -style_scale $STYLE_SCALE \
  -content_weight $CONTENT_WEIGHT \
  -style_weight $STYLE_WEIGHT2 \
  -optimizer adam \
  -learning_rate 1 \
  -image_size 1800 \
  -num_iterations 600 \
  -output_image $OUT_DIR/X4.png \
  -tv_weight 0 \
  -original_colors $ORIGINAL_COLORS \
  -gpu $GPU \
  -backend cudnn
  
PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

if [ $ORIGINAL_COLORS == 0 -a $multipleimages == false ];
then

	python3 ../Neural-Tools/linear-color-transfer.py \
	--target_image $PREV \
	--source_image ${STYLE_IMAGE##*,} \
	--mode chol \
	--output_image "${PREV%.*}-$content-$style-$cw-$sw-histfinal".png

	PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

fi

$NEURAL_STYLE \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $PREV \
  -style_scale $STYLE_SCALE \
  -content_weight $CONTENT_WEIGHT \
  -style_weight $STYLE_WEIGHT2 \
  -optimizer adam \
  -learning_rate 1 \
  -image_size 2550 \
  -num_iterations 200 \
  -style_layers relu0,relu1,relu2,relu3,relu5,relu6,relu7,relu8 \
  -content_layers relu0,relu1,relu2,relu3,relu5,relu6,relu7,relu8 \
  -output_image $OUT_DIR/X5.png \
  -tv_weight 0 \
  -original_colors $ORIGINAL_COLORS \
  -gpu $GPU \
  -backend cudnn

PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

if [ $ORIGINAL_COLORS == 0 -a $multipleimages == false ];
then

	python3 ../Neural-Tools/linear-color-transfer.py \
	--target_image $PREV \
	--source_image ${STYLE_IMAGE##*,} \
	--mode chol \
	--output_image "${PREV%.*}-$content-$style-$cw-$sw-histfinal".png

	PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

fi

$NEURAL_STYLE \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $PREV \
  -style_scale $STYLE_SCALE \
  -content_weight $CONTENT_WEIGHT \
  -style_weight $STYLE_WEIGHT2 \
  -optimizer adam \
  -learning_rate 1 \
  -image_size 2700 \
  -num_iterations 200 \
  -content_layers relu0,relu1,relu2,relu3,relu5,relu6 \
  -style_layers relu0,relu1,relu2,relu3,relu5,relu6 \
  -output_image $OUT_DIR/X6.png \
  -tv_weight 0 \
  -original_colors $ORIGINAL_COLORS \
  -gpu $GPU \
  -backend cudnn

PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

if [ $ORIGINAL_COLORS == 0 -a $multipleimages == false ];
then

	python3 ../Neural-Tools/linear-color-transfer.py \
	--target_image $PREV \
	--source_image ${STYLE_IMAGE##*,} \
	--mode chol \
	--output_image "${PREV%.*}-$content-$style-$cw-$sw-histfinal".png

	PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

fi

$NEURAL_STYLE \
  -content_image $CONTENT_IMAGE \
  -style_image $STYLE_IMAGE \
  -init image -init_image $PREV \
  -style_scale $STYLE_SCALE \
  -content_weight $CONTENT_WEIGHT \
  -style_weight $STYLE_WEIGHT2 \
  -optimizer adam \
  -learning_rate 1 \
  -image_size 2900 \
  -num_iterations 200 \
  -content_layers relu0,relu1,relu2,relu3,relu5,relu6,relu7,relu8 \
  -style_layers relu0,relu1,relu2,relu3,relu5,relu6,relu7,relu8 \
  -output_image $OUT_DIR/X7.png \
  -tv_weight 0 \
  -original_colors $ORIGINAL_COLORS \
  -gpu $GPU \
  -backend cudnn
  
  if [ $ORIGINAL_COLORS == 0 -a $multipleimages == false ];
then

	python3 ../Neural-Tools/linear-color-transfer.py \
	--target_image $PREV \
	--source_image ${STYLE_IMAGE##*,} \
	--mode chol \
	--output_image "${PREV%.*}-$content-$style-$cw-$sw-histfinal".png

	PREV=$OUT_DIR/$(ls -t $OUT_DIR | head -n1)

fi
