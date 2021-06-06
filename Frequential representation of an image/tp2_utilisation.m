#tp2_utilisation
# exercice 6
# Barros Mikel-ange 11508726


# afin d'agrandir une image, nous pouvons supposer qu'il suffit d'aggrandir
# la transformée de fourrier. Comme toutes les informations sur l'image sont déja connus.
# et que l'on ne veut pas ajouter d'artefact on rajoute des informations nulles.
# on va donc agrandir la transformée de fourrier en l'entourant de 0.

image=double(imread("lena.pgm"));

fourriertransform=fftshift(fft2(image));

imagetransform=zeros(rows(fourriertransform)+500,columns(fourriertransform)+500);
imagetransform(251:rows(fourriertransform)+250,251:columns(fourriertransform)+250)=fourriertransform;

imageresultat=ifft2(imagetransform);


# pour la réduction c'est l'inverse il suffit de réduire la transformée de fourrier

imageReduite=fourriertransform(126:rows(fourriertransform)-125,126:columns(fourriertransform)-125);
imageresultat2=ifft2(imageReduite);

figure(1);
subplot(1,3,1);
imshow(image,[]);
title("image de base");
subplot(1,3,2);
imshow(abs(imageresultat),[]);
title("image agrandie");
subplot(1,3,3);
imshow(abs(imageresultat2),[]);
title("image reduite");
