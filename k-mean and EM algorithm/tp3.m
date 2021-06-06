#Barros mikel-ange
#Tp1 véctorisé

#k-means algorithm

gmm2d=load("classif_data/gmm2d.asc");

img=double(imread("textures_data/text4.png"));

imgrow=rows(img);
imgcol=columns(img);
gmm2d=reshape(img,imgrow*imgcol,3);

data= zeros(rows(gmm2d), columns(gmm2d)+1);
data(:,1: columns(gmm2d))=gmm2d;
k = 5;

value =randperm(rows(gmm2d));

centroide= zeros(k,columns(gmm2d));
labelPres= zeros(rows(gmm2d),1);
convergence = 0;

for(i=1:k)
  data(value(i),3)=i;
  centroide(i,:)=data(value(i),1:columns(gmm2d));
endfor;

do
  labelPres=data(:,columns(gmm2d)+1);
  for(i=1:rows(data))
    minvalue=norm(data(i,1:columns(gmm2d)) - centroide(1,:) , 2 );
    minindice=1;
    for(j=2:k)
      if(minvalue>norm(data(i,1:columns(gmm2d)) - centroide(j,:) , 2 ))
          minvalue=norm(data(i,1:columns(gmm2d)) - centroide(j,:) , 2 );
          minindice=j;
      endif
    endfor
    data(i,columns(gmm2d)+1)=minindice;
  endfor
  centroidepres=centroide;
  for(i=1:k)
    centroidtemp=sum(data(data(:,columns(gmm2d)+1)==i,:));
    centroide(i,:)=centroidtemp(1:columns(gmm2d))/(centroidtemp(columns(gmm2d)+1)/i);
  endfor
  if(labelPres == data(:,columns(gmm2d)+1));
    convergence = 1;
  endif
  
until (convergence)

figure(1);
if(columns(gmm2d)==2)
  scatter(data(:,1),data(:,2),[],data(:,3));
else
  scatter3(data(:,1),data(:,2),data(:,3),[],data(:,4));
endif


if(columns(gmm2d)==3)
  figure(2);

  for(i=1:k)
    gmm2d(data(:,columns(gmm2d)+1)==i,1)=centroide(i,1);
    gmm2d(data(:,columns(gmm2d)+1)==i,2)=centroide(i,2);
    gmm2d(data(:,columns(gmm2d)+1)==i,3)=centroide(i,3);
  endfor


  img= reshape(gmm2d,imgcol,imgrow,3);
  imshow(uint8(img));
endif


