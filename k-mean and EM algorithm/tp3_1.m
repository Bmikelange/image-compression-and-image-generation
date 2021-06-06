#Barros mikel-ange
#Tp2

#EM algorithme

gmm2d=load("classif_data/gmm2d.asc");

img=double(imread("textures_data/text4.png"));

imgrow=rows(img);
imgcol=columns(img);
gmm2d=reshape(img,imgrow*imgcol,3);

convergence=0;

value =randperm(rows(gmm2d));

d=columns(gmm2d);
k=4;

moy=zeros(k,d);
sigma=zeros(d,d,k);

for(i=1:k)
  sigma(:,:,i)=cov(gmm2d);
  moy(i,:)=gmm2d(value(i),:);
endfor

Pi(1:k)=1/k;
Q=zeros(rows(gmm2d),k);

function Gaussian = ret(Pi, sigma, moy, gmm2d,i,j)
  c=gmm2d(j,:)-moy(i,:);
  iS=inv(sigma(:,:,i));
  v=exp((-0.5)*(c)*iS*transpose(c));
  g=sigma(:,:,i);
  Gaussian2d=(1/sqrt(det(g)))*v;
  Gaussian=(Pi(i)*Gaussian2d);
endfunction

w=0;
while(convergence==0)
  steps = w
  #STEP E 
  for(i=1:k)
    for(j=1:rows(gmm2d))
      Q(j,i)=ret(Pi,sigma,moy,gmm2d,i,j);
    endfor
  endfor
  Q=Q./sum(Q,2);
  
  #STEP M
  #PI
  Pi=mean(Q,1);
  #MOY
  moyprec=moy;
  for(i=1:k)
    m=sum(Q(:,i));
    s=zeros(1,d);
    for(j=1:rows(gmm2d))
      s=s+gmm2d(j,:)*Q(j,i);
    endfor;
    moy(i,:)=s/m;
  endfor
  #SIGMA
  for(i=1:k)
    m=sum(Q(:,i));
    s=zeros(d,d);
    for(j=1:rows(gmm2d))
      moyenneVal=gmm2d(j,:) - moy(i,:);
      s = s +  transpose(moyenneVal) * moyenneVal * Q(j,i);
    endfor
    sigma(:,:,i)=s/m;
  endfor
  if(sum(sum(abs(moyprec-moy)))<=0.01)
    convergence=1;
  endif
  w=w+1;
endwhile

[maxx label]=max(Q,[],2);

figure(1);

if(columns(gmm2d)==2)
  scatter(gmm2d(:,1),gmm2d(:,2),[],label);
else
  scatter3(gmm2d(:,1),gmm2d(:,2),gmm2d(:,3),[],label);
endif


if(columns(gmm2d)==3)
  for(i=1:rows(gmm2d))
    gmm2d(i,:)=moy(label(i),:);
  endfor

  figure(2);

  imgsortie= reshape(gmm2d,imgcol,imgrow,3);
  imshow(uint8(imgsortie));
endif
