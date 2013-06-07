for i in *png; do convert $i -blur 1x2 $i; done;
for i in *png; do convert $i -transparent white $i; done;
for i in *png; do convert $i -blur 9x9 -paint 2 $i; done;