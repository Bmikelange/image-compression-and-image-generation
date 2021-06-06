#Barros mikel-ange
#Tp1 véctorisé

Image_entree = imread("textures_data/text0.png");

function [resultx,resulty] = meilleurPixel(B,mask,n1,taille_sortie)
  px = 0;
  py = 0;
  temp = conv2(B,mask,'same');
  temp(B!=1) = inf;
  temp = temp(n1+1:taille_sortie+n1,n1+1:taille_sortie+n1);
  [vx,vy] = find(temp == min(min(temp)));
  inti=randi(rows(vx),1);
  resultx = vx(inti)+n1;
  resulty = vy(inti)+n1;
end

function patch = creationPatch(px,py,I,n1)
   patch = I(px-n1:px+n1,py-n1:py+n1,:);
end

function [patch_x,patch_y,distmin,dist_totale] = calcul_distance(patchBase,Image_entree,n1)
  distmin = inf;
  dist_totale = zeros(rows(Image_entree)-2*n1,columns(Image_entree)-2*n1);
  for(x = n1+1:columns(Image_entree)-n1)
    for(y = n1+1:rows(Image_entree)-n1)
      newpatch = creationPatch(x,y,Image_entree,n1);
      newpatch(!(patchBase(:,:,:)))=0;
      dist = sum(sum(sum((newpatch-patchBase).^2)));
      if (dist <= distmin)
        distmin = dist;
        patch_x = x;
        patch_y = y;
      endif
      dist_totale(x-n1,y-n1) = dist;
    endfor
  endfor
end

function ensemble_patch =  meilleurs_patchs(distmin,dist_totale,epsilon,n1)
  [patch_x,patch_y] = find(dist_totale<=(1+epsilon)*distmin);
  ensemble_patch = [patch_x+n1 patch_y+n1];
end

n = 20;
taille_sortie = 32 ;
epsilon = 0.001;
l=n;
rn=round(n/2);
fn=floor(n/2);
x=randi([1,rows(Image_entree)-l],1);
y=randi([1,columns(Image_entree)-l],1);
taille_image = taille_sortie + 2*rn;
I = zeros(taille_image,taille_image,3);
B = ones(taille_image,taille_image);
maskbase = ones(n,n);
pair = not(mod(l,2));
e = floor(l/2);
if(pair)
  I(taille_image/2-e:taille_image/2+e-1,taille_image/2-e:taille_image/2+e-1,:) = Image_entree(x:x+l-1,y:y+l-1,:);
  B(taille_image/2-e:taille_image/2+e-1,taille_image/2-e:taille_image/2+e-1) = 0;
else
  I(taille_image/2-e:taille_image/2+e,taille_image/2-e:taille_image/2+e,:) = Image_entree(x-l:x+l,y-l:y+l,:);
  B(taille_image/2-e:taille_image/2+e,taille_image/2-e:taille_image/2+e) = 0;
endif

Pixels_restants = taille_sortie*taille_sortie-l*l;

while(Pixels_restants >0)
  [resultx,resulty] = meilleurPixel(B, maskbase,rn,taille_sortie);
  
  patch = creationPatch(resultx,resulty,I,fn);
  
  [patch_x,patch_y,distmin,dist_totale] = calcul_distance(patch,Image_entree,fn);
  ensemble_patch = meilleurs_patchs(distmin,dist_totale,epsilon,fn);
  patch_choisi = ensemble_patch(randperm(rows(ensemble_patch),1),:);
  B(resultx,resulty)=0;
  I(resultx,resulty,:)=Image_entree(patch_choisi(1),patch_choisi(2),:);
  Pixels_restants = Pixels_restants - 1
end

  
  Imresult=I(rn+1:taille_sortie+rn,rn+1:taille_sortie+rn,:);
  imshow(uint8(Imresult));