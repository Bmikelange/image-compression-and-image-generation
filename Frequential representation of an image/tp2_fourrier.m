# TP2_Fourrier
# exercice 3
# Barros Mikel-ange 11508726

# Définis la taille de mon image
X=600;
Y=400;

# Définis la distance a laquelle sont placé mes points par rapport
# au centre
d=10;

# Définis l'angles selon a lequel sont placé mes points par rapport
# au centre
teta= deg2rad(135);

#crée mon image
imPoints=zeros(X,X);

#positionne les deux points sur l'image
imPoints(X/2+int16(cos(teta)*d),X/2+int16(sin(teta)*d))=1;
imPoints(X/2-int16(cos(teta)*d),X/2-int16(sin(teta)*d))=1;



# Effectue la transformée de fourrier inverse des points
imFourrier=ifft2(imPoints);
ImAjuste=log(1+80*abs(imFourrier));

# Affiche l'image de la transformée de fourrier inverse
figure(1);
subplot(1,3,1);
imshow(ImAjuste,[]);
title("Transformée de fourrier");
# Affiche la représentation 3d de la transformée de fourrier inverse
subplot(1,3,2);
mesh(ImAjuste);
title("mesh de la transformée");
# Affiche l'image
subplot(1,3,3);
imshow(imPoints);
title("image de base");

waitforbuttonpress();

# commentaire du résultat

# le résultat obtenu est un sinus dépendant de la position des deux points
# ainsi que de l'écart entre les deux points positionnés sur l'image de base. 
# en faisant varier d on augmente la fréquence du sinus
# en faisant varier teta on change l'angle du sinus et la manière dont il est affiché
rayon =50;


#dessine un rond au centre de l'image

imrond=zeros(X,X);

for(i=1:X)
  for(j=1:X)
    if(sqrt((X/2-i)*(X/2-i)+(X/2-j)*(X/2-j))<rayon)
      imrond(i,j)=1;
    end
  end
end

#effectue la transformée de fourrier inverse de l'image
imFourrier2=fftshift(ifft2(imrond));
ImAjuste2=log(1+50*abs(imFourrier2));
# Affiche l'image de la transformée de fourrier inverse
figure(1);
subplot(1,3,1);
imshow(ImAjuste2,[]);
title("Transformée de fourrier");
# Affiche la représentation 3d de la transformée de fourrier inverse
subplot(1,3,2);
mesh(ImAjuste2);
title("mesh de la transformée");
# Affiche l'image
subplot(1,3,3);
imshow(imrond);
title("image de base");

waitforbuttonpress();

# Commentaire du résultat

# pour un disque la transformée de fourrier inverse est un disque
# entouré de cercle d'énergie moins importante. Plus le cercle en entrée est grand
# plus le cercle de la transformée inverse sera petit.

# ouvre une image pour en récuperer sa phase et son module 
testMP = imread("lena.pgm");

#effectue la tranformée de fourrier de l'image
imFourrierlena=fftshift(fft2(testMP));
module=abs(imFourrierlena);
phase=angle(imFourrierlena);
figure(1);
# affiche le module de l'image
subplot(1,3,1);
imshow(log(1+50*module),[]);
title("module");
# Affiche la phase de l'image
subplot(1,3,2);
imshow(phase,[]);
title("phase");
# Affiche l'image
subplot(1,3,3);
imshow(testMP);
title("image");

waitforbuttonpress();

#recrée l'image à partir de sa phase et de son module
#imagefinale=zeros(rows(phase),columns(phase));
#for(i=1:rows(phase))
#  for(j=1:columns(phase))
#    imagefinale(i,j)=module(i,j)*exp(1i*phase(i,j));
#  end
#end

#affiche l'image recréée
#figure(6);
#imshow(log(1+50*ifft2(imagefinale)),[]);

#crée une phase aléatoire
phasealea=rand(columns(phase),rows(phase));

figure(1);
subplot(1,3,1);
imshow(log(1+50*module),[]);
title("module");
subplot(1,3,2);
imshow(phasealea,[]);
title("phase");

#recrée l'image à partir du module et de la phase aléatoire
imagefinal=zeros(columns(phasealea),rows(phasealea));
for(i=1:columns(phasealea))
  for(j=1:rows(phasealea))
    imagefinal(i,j)=module(i,j)*exp(1i*phasealea(i,j));
  end
end

subplot(1,3,3);
imshow(log(1+50*ifft2(imagefinal)),[]);
title("image reconstituée");

waitforbuttonpress();

# commentaire
# l'image créée avec une phase aléatoire à les même couleur
# que l'image de base mais les formes sont perdus on peut donc
# supposer que la phase conserve les informations sur la forme du dessins 


#crée un module constant
moduleconst=ones(columns(module),rows(module));

figure(1);
subplot(1,3,1);
imshow(log(1+50*moduleconst),[]);
title("module");
subplot(1,3,2);
imshow(phase,[]);
title("phase");

#recrée l'image à partir du module et de la phase constante
imagefinalMC=zeros(columns(moduleconst),rows(moduleconst));
for(i=1:columns(phase))
  for(j=1:rows(phase))
    imagefinalMC(i,j)=moduleconst(i,j)*exp(1i*phase(i,j));
  end
end

subplot(1,3,3);
imshow(log(1+50*ifft2(imagefinalMC)),[]);
title("image reconstituée");
waitforbuttonpress();

# commentaire
# l'image créée avec un module constant à la couleur constante du module. on peut 
# cependant remarquer que la forme de l'image originale est préservée et clairement
# visible même avec une phase constante. 

#crée une phase constante
phaseconst=ones(columns(phase),rows(phase));

figure(1);
subplot(1,3,1);
imshow(log(1+50*module),[]);
title("module");
subplot(1,3,2);
imshow(phaseconst,[]);
title("phase");

#recrée l'image à partir du module et de la phase constante
imagefinalPC=zeros(columns(phaseconst),rows(phaseconst));
for(i=1:columns(phaseconst))
  for(j=1:rows(phaseconst))
    imagefinalPC(i,j)=module(i,j)*exp(1i*phaseconst(i,j));
  end
end

subplot(1,3,3);
imshow(log(1+50*ifft2(imagefinalPC)),[]);
title("image reconstituée");
waitforbuttonpress();

# commentaire
# l'image créée avec une phase constante ressemble beaucoup à l'image crée avec une
# phase aléatoire. on conserve les couleurs mais on pert l'agencement


# commentaire
# l'image créée avec une phase aléatoire à les même couleur
# que l'image de base mais les formes sont perdus on peut donc
# supposer que la phase conserve les informations sur la forme du dessins 

# ouvre une deuxième image pour en récuperer sa phase et son module 
peppers = imread("peppers.bmp");

# récupère le module et la phase de la transformée de fourrier de la deuxième image
imFourrierpeppers=fftshift(fft2(peppers));
modulepeppers=abs(imFourrierpeppers);
phasepeppers=angle(imFourrierpeppers);

#recrée les images en inversant leurs phases
imagefinallena=zeros(columns(phase),rows(phase));
for(i=1:columns(phase))
  for(j=1:rows(phase))
    imagefinallena(i,j)=modulepeppers(i,j)*exp(1i*phase(i,j));
  end
end


imagefinalpeppers=zeros(columns(peppers),rows(phasepeppers));
for(i=1:columns(phase))
  for(j=1:rows(phase))
    imagefinalpeppers(i,j)=module(i,j)*exp(1i*phasepeppers(i,j));
  end
end

#affiche les images
figure(1);
subplot(1,2,1);
imshow(log(1+50*ifft2(imagefinallena)),[]);
subplot(1,2,2);
imshow(log(1+50*ifft2(imagefinalpeppers)),[]);

#les images pour lesquelles on à inversé les phases ont gardés les bonnes couleur
# mais ont l'aspect, au niveau des formes, de l'autre image.
# on peut donc en conclure que l'hypothèse précédente comme quoi la phase contient 
# l'information de position est vraie


