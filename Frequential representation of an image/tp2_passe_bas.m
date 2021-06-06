# TP2_passe_bas
# exercice 5 
# Barros Mikel-ange 11508726

# crée un cercle pour mettre à 0 les fréquences hautes. 
# en effet les fréquences basses sont au centre de la transformée de fourrier 
# après un fftshift

X=10;
rayon=5;
imrond=zeros(X,X);

for(i=1:X)
  for(j=1:X)
    if(sqrt((X/2-i)*(X/2-i)+(X/2-j)*(X/2-j))<rayon)
      imrond(i,j)=1;
    end
  end
end

# crée des filtres passe bas
filtre2=[1  2  1; 2  4  2; 1  2  1];
filtre=[1  1  1  1  1 ; 1  4  4  4  1 ; 1  4 12  4  1 ; 1  4  4  4  1 ; 1  1  1  1  1];

#charge l'image à traiter
image= double(imread("lena.pgm"));

#applique le cercle à l'image
image_res3=conv2(image,imrond);

# applique le premier filtre à l'image 
image_res=conv2(image,filtre);
# applique le deuxième filtre à l'image
image_res2=conv2(image,filtre2);

# affiche toute les images
figure(2)
subplot(2,2,1);
imshow(image,[]);
title("image de base");
subplot(2,2,2);
imshow(image_res,[]);
title("filtre passe-bas 3*3");
subplot(2,2,3);
imshow(image_res2,[]);
title("filtre passe-bas 5*5");
subplot(2,2,4);
imshow(image_res3,[]);
title("filtrage par cercle");

# applique une decimation sur les images filtrées
imageres8=image_res(1:8:rows(image_res),1:8:columns(image_res),:);
imageres28=image_res2(1:8:rows(image_res2),1:8:columns(image_res2),:);
imageres38=image_res3(1:8:rows(image_res3),1:8:columns(image_res3),:);
image8=image_res3(1:8:rows(image),1:8:columns(image),:);

# affiche les transformées de fourrier des images décimée
figure(3)
subplot(2,2,1);
im2=fftshift(fft2(imageres28))
imshow(im2);
title("Fourrier, décimation, 5*5");
subplot(2,2,2);
im=fftshift(fft2(imageres8))
imshow(im);
title("Fourrier, décimation, 3*3");
subplot(2,2,3);
im3=fftshift(fft2(imageres38))
imshow(im3);
title("Fourrier, décimation, cercle");
subplot(2,2,4);
im4=fftshift(fft2(image8))
imshow(im4);
title("Fourrier, décimation, base");

# # commentaires du résultat, l'image de base est floutée par le cercle.
# en effet si le cercle effectue bien la mise à zéro des fréquences hautes 
# mais il va aussi réduire l'écart entre les fréquences basse.
# cela réduit les effets de moirées sur la transformée de fourrier mais l'image 
# en elle même est moins précise.
# les autres passes bas floutent beaucoup moins l'image, même si ils la floute quand même