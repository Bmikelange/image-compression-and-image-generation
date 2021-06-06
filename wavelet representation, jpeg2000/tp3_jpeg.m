# tp3_jpeg
# exercice 7
# Barros Mikel-ange 11508726


# couleur 

Image=imread("doc.tif");
q=100;
Nom_fichier= sprintf("doc_%.2d.jpg",q);
imwrite(Image, Nom_fichier, "quality", q);
[X Y]=size(Image);
[info,err,msg]=stat(Nom_fichier);
sizes=info.size*8;
taux=sizes/(X*Y);

# taux 10% : 0.049753 qualit� inf�rieure jpeg2000
# taux 20% : 0.081612 qualit� similaire jpeg2000
# taux 30% : 0.11302 qualit� similaire jpeg2000
# taux 50% : 0.17320 qualit� similaire jpeg2000
# taux 75% : 0.29424 qualit� similaire jpeg2000
# taux 100% : 4.0572  qualit� similaire jpeg2000

# noir et blanc 

Image=imread("lena.pgm");
q=100;
Nom_fichier= sprintf("lena_%.2d.jpg",q);
imwrite(Image, Nom_fichier, "quality", q);
[X Y]=size(Image);
[info,err,msg]=stat(Nom_fichier);
sizes=info.size*8;
taux=sizes/(X*Y);

# taux 10% : 0.19980 qualit� inf�rieure jpeg2000
# taux 20% : 0.32898 qualit� similaire jpeg2000
# taux 30% : 0.43597 qualit� similaire jpeg2000
# taux 50% : 0.53055 qualit� similaire jpeg2000
# taux 75% : 0.98004  qualit� similaire jpeg2000
# taux 100% : 4.7210 qualit� similaire jpeg2000
