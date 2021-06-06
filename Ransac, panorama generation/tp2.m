#Barros mikel-ange
#Tp2


#exercice 1


image1=imread("regression_data/keble_a.jpg");
image2=imread("regression_data/keble_b.jpg");
image3=imread("regression_data/keble_c.jpg");

figure(1);
imshow(image1);
figure(2);
imshow(image2);


pair1=zeros(1,2,2);
pair2=zeros(1,2,2);
pair3=zeros(1,2,2);
pair4=zeros(1,2,2);

pair1(1,1,1)=658;
pair1(1,1,2)=287;
pair1(1,2,1)=366;
pair1(1,2,2)=289;

pair2(1,1,1)=642;
pair2(1,1,2)=360;
pair2(1,2,1)=347;
pair2(1,2,2)=361;


 
pair3(1,1,1)=681;
pair3(1,1,2)=359;
pair3(1,2,1)=386;
pair3(1,2,2)=361;

pair4(1,1,1)=342;
pair4(1,1,2)=56;
pair4(1,2,1)=50;
pair4(1,2,2)=39;

# chaque point i de a est associée à un point j de b par une matrice H
# tel que  b(j)=H*a(i)
# m*h^T=0



r1x = [pair1(1,1,1),pair1(1,1,2),1,0,0,0,-pair1(1,2,1)*pair1(1,1,1),-pair1(1,2,1)*pair1(1,1,2),-pair1(1,2,1)];
r1y = [0,0,0,pair1(1,1,1),pair1(1,1,2),1,-pair1(1,2,2)*pair1(1,1,1),-pair1(1,2,2)*pair1(1,1,2),-pair1(1,2,2)];
r2x = [pair2(1,1,1),pair2(1,1,2),1,0,0,0,-pair2(1,2,1)*pair2(1,1,1),-pair2(1,2,1)*pair2(1,1,2),-pair2(1,2,1)];
r2y = [0,0,0,pair2(1,1,1),pair2(1,1,2),1,-pair2(1,2,2)*pair2(1,1,1),-pair2(1,2,2)*pair2(1,1,2),-pair2(1,2,2)];
r3x = [pair3(1,1,1),pair3(1,1,2),1,0,0,0,-pair3(1,2,1)*pair3(1,1,1),-pair3(1,2,1)*pair3(1,1,2),-pair3(1,2,1)];
r3y = [0,0,0,pair3(1,1,1),pair3(1,1,2),1,-pair3(1,2,2)*pair3(1,1,1),-pair3(1,2,2)*pair3(1,1,2),-pair3(1,2,2)];
r4x = [pair4(1,1,1),pair4(1,1,2),1,0,0,0,-pair4(1,2,1)*pair4(1,1,1),-pair4(1,2,1)*pair4(1,1,2),-pair4(1,2,1)];
r4y = [0,0,0,pair4(1,1,1),pair4(1,1,2),1,-pair4(1,2,2)*pair4(1,1,1),-pair4(1,2,2)*pair4(1,1,2),-pair4(1,2,2)];


M=[r1x ; r1y ; r2x ; r2y ; r3x ; r3y ; r4x ; r4y];

[U S V] =svd(M);

h=V(:,columns(V));

H=[h(1,1) h(2,1) h(3,1) ; h(4,1) h(5,1) h(6,1) ; h(7,1) h(8,1) h(9,1)];


new_Image=vgg_warp_H(image1,H, 'nearest',[-500,1100,-200,800]);
for(i=1:1000)
  for(j=1:1500)
    if(i-200>=1 && i-200<rows(image2)-1 && j-500>=1 &&j-500<columns(image2)-1)
      if(new_Image(i,j)==0)
        new_Image(i,j,:)=image2(i-200,j-500,:);
      end    
    end
  end
end
figure(3);
imshow(new_Image);

#exercice 2

data=load("regression_data/matchesab.txt");
data2=load("regression_data/match2.txt");

function data = add_Data(data,k)
  add=zeros(1,4);
  for(i=1:k)
    add(1)=randi(5000);
    add(2)=randi(5000);
    add(3)=randi(5000);
    add(4)=randi(5000);
    data=[data;add];
  endfor
endfunction

function M = computeM(ensemble_points,nbpoints)
  M=zeros(2*nbpoints,9);
  k=1;
  for(i=1:nbpoints)
    a=ensemble_points(i,1:2);
    b=ensemble_points(i,3:4);
    M(k,:)=[a(1),a(2),1,0,0,0,-b(1)*a(1),-b(1)*a(2),-b(1)];
    M(k+1,:)=[0,0,0,a(1),a(2),1,-b(2)*a(1),-b(2)*a(2),-b(2)];
    k+=2;
  endfor
endfunction

function [bonmodel,bonpoints,bonneerreur] = ransac(data,n,k,t,d)
  i=0;
  bonpoints=zeros(rows(data),4);
  bonneerreur=inf;
  bonmodel=zeros(3,3);
  while(i<k)
    value =randperm(rows(data));
    nbvalueBase=randi([n,n*3]);
    points_aleatoire=data(value(1:nbvalueBase),:);
    ensemble_points=points_aleatoire;
    M= computeM(ensemble_points,nbvalueBase);
    [U S V] =svd(M);
    h=V(:,columns(V));
    H=[h(1,1) h(2,1) h(3,1) ; h(4,1) h(5,1) h(6,1) ; h(7,1) h(8,1) h(9,1)];
    count=0;
    ensemble_points=zeros(rows(data),4);
    for(j=1:rows(data))
      a=ones(3,1);
      a(1:2)=data(j,1:2);
      b=data(j,3:4);
      bcomp=H*a;
      bcomp2=transpose(bcomp(1:2)/bcomp(3));
      if(norm( b - bcomp2(1:2) , 2 )<t);
        ensemble_points(count+1,:)=data(j,:);
        count++;
      endif
    endfor
    ensemble_points=ensemble_points(1:count,:);
    if(count>d)
      M= computeM(ensemble_points,count);
      [U S V] =svd(M);
      h=V(:,columns(V));
      H2=[h(1,1) h(2,1) h(3,1) ; h(4,1) h(5,1) h(6,1) ; h(7,1) h(8,1) h(9,1)];
      error=0;
      for(j=1:rows(data))
        a=ones(3,1);
        a(1:2)=data(j,1:2);
        b=data(j,3:4);
        bcomp=H2*a;
        bcomp2=transpose(bcomp(1:2)/bcomp(3));
        error+=b-bcomp2(1:2).^2;
      endfor
      error=error/count;
      if(error<bonneerreur)
        bonneerreur=error;
        bonmodel=H2;
        bonpoints=ensemble_points;
      endif
    endif
    i++;
  end
endfunction

#data= add_Data(data,1000);

[bonmodel,bonpoints,bonneerreur]=ransac(data,5,10,0.5,100);
 
new_Image=vgg_warp_H(image1,bonmodel, 'nearest',[-500,1600,-200,800]);

for(i=1:1000)
  for(j=1:2100)
    if(i-200>=1 && i-200<rows(image2)-1 && j-500>=1 &&j-500<columns(image2)-1)
      if(new_Image(i,j)==0)
        new_Image(i,j,:)=image2(i-200,j-500,:);
      end    
    end
  end
end


figure(4);
imshow(new_Image); 

[bonmodel2,bonpoints2,bonneerreur2]=ransac(data2,5,10,0.5,100);

new_Image2=vgg_warp_H(image3,bonmodel2, 'nearest',[-500,1600,-200,800]);

for(i=1:1000)
  for(j=1:2100)
    if(new_Image2(i,j)==0)
      new_Image2(i,j,:)=new_Image(i,j,:);
    end    
  end
end

figure(5);
imshow(new_Image2); 
