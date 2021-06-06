# TP2_aliasing
# exercice 4 
# Barros Mikel-ange 11508726

X=600;

lena = imread("lena.pgm");
lenadec2=lena(1:2:columns(lena),1:2:rows(lena));
lenadec4=lena(1:4:columns(lena),1:4:rows(lena));
lenadec8=lena(1:8:columns(lena),1:8:rows(lena));

# affiche les images aliasée
figure(1);
subplot(2,2,1);
imshow(lena);
subplot(2,2,2);
imshow(lenadec2);
subplot(2,2,3);
imshow(lenadec4);
subplot(2,2,4);
imshow(lenadec8);

waitforbuttonpress();

# affiche les transformées de fourrier des images de lena aliasée

flena = fftshift(fft2(lena));
flenadec2=fftshift(fft2(lenadec2));
flenadec4=fftshift(fft2(lenadec4));
flenadec8=fftshift(fft2(lenadec8));

figure(2);
subplot(2,2,1);
imshow(flena);
subplot(2,2,2);
imshow(flenadec2);
subplot(2,2,3);
imshow(flenadec4);
subplot(2,2,4);
imshow(flenadec8);

waitforbuttonpress();

# Charge une nouvelle image
imagetest=imread("peppers.bmp");

imagetest2=imagetest(1:2:rows(imagetest),1:2:columns(imagetest),:);
imagetest4=imagetest(1:4:rows(imagetest),1:4:columns(imagetest),:);
imagetest8=imagetest(1:8:rows(imagetest),1:8:columns(imagetest),:);

figure(1);
subplot(2,2,1);
imshow(imagetest,[]);
subplot(2,2,2);
imshow(imagetest2,[]);
subplot(2,2,3);
imshow(imagetest4,[]);
subplot(2,2,4);
imshow(imagetest8,[]);

waitforbuttonpress();

fimagetest = fftshift(fft2(imagetest));
fimagetestdec2=fftshift(fft2(imagetest2));
fimagetestdec4=fftshift(fft2(imagetest4));
fimagetestdec8=fftshift(fft2(imagetest8));

figure(2);
subplot(2,2,1);
imshow(fimagetest);
subplot(2,2,2);
imshow(fimagetestdec2);
subplot(2,2,3);
imshow(fimagetestdec4);
subplot(2,2,4);
imshow(fimagetestdec8);

waitforbuttonpress();

# Charge une troisième image

imagemoiree=double(imread("moiree.jpg"));

imagemoiree2=imagemoiree(1:2:rows(imagemoiree),1:2:columns(imagemoiree),:);
imagemoiree4=imagemoiree(1:4:rows(imagemoiree),1:4:columns(imagemoiree),:);
imagemoiree8=imagemoiree(1:8:rows(imagemoiree),1:8:columns(imagemoiree),:);

figure(1);
subplot(2,2,1);
imshow(imagemoiree,[]);
subplot(2,2,2);
imshow(imagemoiree2,[]);
subplot(2,2,3);
imshow(imagemoiree4,[]);
subplot(2,2,4);
imshow(imagemoiree8,[]);

waitforbuttonpress();

fimagemoiree = fftshift(fft2(imagemoiree));
fimagemoireedec2=fftshift(fft2(imagemoiree2));
fimagemoireedec4=fftshift(fft2(imagemoiree4));
fimagemoireedec8=fftshift(fft2(imagemoiree8));

figure(2);
subplot(2,2,1);
imshow(fimagemoiree);
subplot(2,2,2);
imshow(fimagemoireedec2);
subplot(2,2,3);
imshow(fimagemoireedec4);
subplot(2,2,4);
imshow(fimagemoireedec8);

waitforbuttonpress();


# Commentaires

# plus la décimation est importante plus on remarque un effet d'escalier sur l'image
# cet effet appelé alaising est du au fait que les pentes ne sont pas rendue de manière
# assez précise par l'image
# sur les transformées de fourrier cela se remarque par un résultat bien moins précis et 
# moins nuancé ainsi qu'un effet de moiré.
# la forme de la transformée de fourrier reste cependant similaire quelque soit l'aliasing 
# on assiste ici à un repliement spectral de l'image