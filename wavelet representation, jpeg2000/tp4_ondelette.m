# tp3_ondelette
# exercice 8
# Barros Mikel-ange 11508726

# nombre de niveaux de decomposition
m=1;
m1=2;
m2=3;

#crée un graphe à partir d'un filtre de Daubechies
qmf = MakeONFilter('Daubechies',power(2,2));
qmf3 = MakeONFilter('Daubechies',power(2,3));
qmf4 = MakeONFilter('Daubechies',power(2,4));

# Transformée de fourrier des filtres
fftqmf=fftshift(fft(qmf));
fftqmf3=fftshift(fft(qmf3));
fftqmf4=fftshift(fft(qmf4));
module=abs(fftqmf);
module3=abs(fftqmf3);
module4=abs(fftqmf4);

#Affiche les filtres
figure(1)
subplot(3,2,1);
plot(module);
subplot(3,2,3);
plot(module3);
subplot(3,2,5);
plot(module4);

subplot(3,2,2);
plot(qmf);
subplot(3,2,4);
plot(qmf3);
subplot(3,2,6);
plot(qmf4);
waitforbuttonpress();

# Conclusion :
# le graphe est un filtre des basses fréquences 
# dans tout les cas le graphe est compris entre la valeur 0 et la valeur ordre
# Donc plus l'ordre est petit plus il se contracte et plus l'ordre est grand
# plus il s'étale
# lorsque l'on diminue l'ordre du filtre, le graphe devient moins détaillé
# lorsque l'on augmente l'ordre du filtre, le graphe devient plus détaillé


# lis une image 
lena=double(imread("lena.pgm"));

# force l'utilisation de nunaces de gris
colormap("gray");

#calcul la puissance de 2 associée à la longueur de l'image
k=log2(rows(lena));

# appliques les ondelettes à l'image et les affiches.
figure(1);
subplot(3,2,1);
lena1=FWT2_PO(lena,k-m,qmf);
image(lena1);
title("m : 1 image");

subplot(3,2,3);
lena2=FWT2_PO(lena,k-m1,qmf);
image(lena2);
title("m : 2 image");

subplot(3,2,5);
lena3=FWT2_PO(lena,k-m2,qmf);
image(lena3);
title("m : 3 image");

figure(1);
subplot(3,2,2);
imagesc(lena1);
title("m : 1 imagesc");

subplot(3,2,4);
imagesc(lena2);
title("m : 2 imagesc");

subplot(3,2,6);
imagesc(lena3);
title("m : 3 imagesc");

waitforbuttonpress();

# Conclusion 
# La transformation de l'image en ondelettes permet de réduire l'image d'une taille 
# définis à l'avance tout en conservant les détails de l'image.

[qmfn,dqmf] = MakeBSFilter('Villasenor',1);

lenafbs1=FWT2_SBS(lena,k-m, qmfn,dqmf);
lenafbs2=FWT2_SBS(lena,k-m1, qmfn,dqmf);


colormap("gray");

figure(1);
subplot(2,2,1);
image(lenafbs1);
title("m : 1 image");

subplot(2,2,3);
image(lenafbs2);
title("m : 2 image");

subplot(2,2,2);
imagesc(lenafbs1);
title("m : 1 imagesc");

subplot(2,2,4);
imagesc(lenafbs2);
title("m : 2 imagesc");

#Conclusion 

