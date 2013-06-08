for i in *png; do convert $i -negate -paint 1 -blur 0x0 -transparent black -blur 5x5 -quality 00 $i; done;
