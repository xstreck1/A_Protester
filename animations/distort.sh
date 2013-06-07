for i in *png; do convert $i -blur 2x3 $i; done;
for i in *png; do convert $i -transparent white $i; done;
for i in *png; do convert $i -blur 7x8 -paint 2 $i; done;
for i in *png; do convert $i -scale 75% $i; done;