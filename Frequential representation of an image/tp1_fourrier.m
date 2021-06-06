# TP1 Fourrier
# exercice 2
# Barros Mikel-ange 11508726

# Définis la taille de mon image
X=600;
Y=400;
# Crée un réctangle noir au dimension de l'image
im1=zeros(X,Y);
# Dessine un rectangle blanc sur l'image noir
im1(X/2-X/4:X/2+X/4-1,Y/2-Y/4:Y/2+Y/4-1)=1;
# Applique la transformée de fourrier sur l'image créée
imfourrier=fftshift(fft2(im1));
# Affiche l'image de la transformée de fourrier
# Ajuste le contraste et affiche les valeurs selont un logarithme
ImAjuste=log(1+80*abs(imfourrier));
figure(1);
subplot(1,3,1);
imshow(ImAjuste);
title("Transformée de fourrier");
# Affiche la représentation 3d de la transformée de fourrier
subplot(1,3,2);
mesh(ImAjuste);
title("mesh de la transformée");
# Affiche l'image
subplot(1,3,3);
imshow(im1);
title("image de base");

waitforbuttonpress();

# Commentaires du résultat

# Le résultat obtenu est un sinus cardinal. En effet l'image 2d de base
# représente une porte et la transformée de fourrier d'une porte est
# un sinus cardinal.

# Crée un deuxième rectangle noir au dimension de l'image
im1bis=zeros(X,Y);
# Dessine un rectangle blanc sur l'image noir à une autre position que précédemment
im1bis(1:X/4,1:Y/4)=1;
# Applique la transformée de fourrier sur l'image créée
imfourrierbis=fftshift(fft2(im1bis));
# Ajuste le contraste et affiche les valeurs selont un logarithme
ImAjusteBis=log(1+80*abs(imfourrierbis));
# Affiche l'image de la transformée de fourrier
figure(1);
subplot(1,3,1);
imshow(ImAjusteBis);
title("Transformée de fourrier");
# Affiche la représentation 3d de la transformée de fourrier
subplot(1,3,2);
mesh(ImAjusteBis);
title("mesh de la transformée");
# Affiche l'image
subplot(1,3,3);
imshow(im1bis);
title("image de base");

waitforbuttonpress();

# Commentaires du résultat

# le résultat obtenu reste un sinus cardinal. Cependant valeurs observées sont 
# sensiblement différentes par rapport a la première porte observée

# Crée un troisième rectangle noir au dimension de l'image
im1ter=zeros(X,Y);
# Rempli le rectangle de points blancs
im1ter(1:3:X,1:3:Y)=1;
# Applique la transformée de fourrier sur l'image créée
imfourrierter=fftshift(fft2(im1ter));
# Affiche l'image de la transformée de fourrier
# Ajuste le contraste et affiche les valeurs selont un logarithme
ImAjusteter=log(1+80*abs(imfourrierter));
figure(1);
subplot(1,3,1);
imshow(ImAjusteter);
title("Transformée de fourrier");
# Affiche la représentation 3d de la transformée de fourrier
subplot(1,3,2);
mesh(ImAjusteter);
title("mesh de la transformée");
# Affiche l'image
subplot(1,3,3);
imshow(im1ter);
title("image de base");

waitforbuttonpress();

# Commentaires du résultat

# le résultat obtenue par la transformée de fourrier est un peigne de dirac 2d.
# En effet l'image de départ était elle aussi un peigne de dirac et la 
# transformée de fourrier d'un peigne de dirac reste un peigne de dirac.

# Crée une gaussienne 2d

im1qua=ones(X,X);

for(i=1:X)
  for(j=1:X)
    im1qua(i,j)=255*exp(-((i-X/2)*(i-X/2)/16+(j-X/2)*(j-X/2)/16));
  end
end

# Applique la transformée de fourrier sur l'image créée
imfourrierqua=fftshift(fft2(im1qua));
# Affiche l'image de la transformée de fourrier
# Ajuste le contraste et affiche les valeurs selont un logarithme
ImAjustequa=log(1+80*abs(imfourrierqua));
figure(1);
subplot(1,3,1);
imshow(ImAjustequa);
title("Transformée de fourrier");
# Affiche la représentation 3d de la transformée de fourrier
subplot(1,3,2);
mesh(ImAjustequa);
title("mesh de la transformée");
# Affiche l'image
subplot(1,3,3);
imshow(im1qua);
title("image de base");

# Commentaires du résultat

# le résultat obtenu est un gaussien plus grand que le gaussien. ce résultat est
# cohérent avec ce que l'on à vu en cours

# Après cette prise en main on peut conclure que les résultats des transformées
# de fourrier obtenue sur des signaux 1d sont également valable sur les 
# signaux 2d
