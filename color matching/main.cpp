#define _CRT_SECURE_NO_WARNINGS 1
#include <vector>

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#include <iostream>

#include <stdlib.h>
#include <time.h> 

double dot(double u,double v,double w, double x, double y, double z)
{
	return u * x + v * y + w * z;
}


double clamp(double x)
{
	if((unsigned char) x >= 255)
	{
		if(x>=255)
		{
			return 255;
		}
		if(x<=0)
		{
			return 0;
		}
	}
	return x;
	
}

void algo_to_implement(std::vector<double> & image,std::vector<double> image2, int W, int H)
{
	for(int z=0;z<200;z++)
	{
		double u=rand()/(double)RAND_MAX-0.5;
		double v=rand()/(double)RAND_MAX-0.5;
		double w=rand()/(double)RAND_MAX-0.5;
		double norm = std::sqrt(u*u+v*v+w*w);
		u=u/norm;
		v=v/norm;
		w=w/norm; 
		std::vector<std::pair<double ,int>> PI2;
		std::vector<std::pair<double ,int>> PI1;
		int j=0;
		for (int i = 0; i < H; i++) {
			for (int j = 0; j < W; j++) {
				PI1.push_back(std::pair<double,int>(dot(u,v,w,image[(i*W+j)*3],image[(i*W+j)*3+1],image[(i*W+j)*3+2]),(i*W+j)*3));
				PI2.push_back(std::pair<double,int>(dot(u,v,w,image2[(i*W+j)*3],image2[(i*W+j)*3+1],image2[(i*W+j)*3+2]),(i*W+j)*3));
			}
		}
		std::sort(PI1.begin(),PI1.end());
		std::sort(PI2.begin(),PI2.end());

		for (int i = 0; i < H; i++) {
			for (int j = 0; j < W; j++) {
				float value=PI2[i*W+j].first-PI1[i*W+j].first;
				image[PI1[i*W+j].second] += u*value;
				image[PI1[i*W+j].second+1] += v*value;
				image[PI1[i*W+j].second+2] += w*value;
			}
		}
		std::cout<<z<<std::endl;
	}
	for (int i = 0; i < H; i++) {
		for (int j = 0; j < W; j++) {
			image[i*W+j*3] = clamp(image[i*W+j*3]);
			image[i*W+j*3+1] = clamp(image[i*W+j*3+1]);
			image[i*W+j*3+2] = clamp(image[i*W+j*3+2]);
		}
	}
}


int main() {

	srand (time(NULL));
	int W, H, C;
	int W2, H2,C2;
	
	//stbi_set_flip_vertically_on_load(true);
	unsigned char *image = stbi_load("entree1.jpg",
                                 &W,
                                 &H,
                                 &C,
                                 STBI_rgb);
	std::vector<double> image_double(W*H*3);

	unsigned char *image2 = stbi_load("entree2.jpg",
                                 &W2,
                                 &H2,
                                 &C2,
                                 STBI_rgb);
								 
	std::vector<double> image_double2(W*H*3);

	for (int i=0; i<W*H*3; i++)
	{
		image_double[i] = image2[i];
		image_double2[i] = image[i];
	}

	algo_to_implement(image_double,image_double2,W,H);
	
	std::vector<unsigned char> image_result(W*H * 3, 0);
	for (int i = 0; i < H; i++) {
		for (int j = 0; j < W; j++) {

			image_result[(i*W + j) * 3 + 0] = image_double[(i*W+j)*3+0];
			image_result[(i*W + j) * 3 + 1] = image_double[(i*W+j)*3+1];
			image_result[(i*W + j) * 3 + 2] = image_double[(i*W+j)*3+2];
		}
	}
	stbi_write_png("sortie.png", W, H, 3, &image_result[0], 0);

	return 0;
}