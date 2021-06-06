#include "bases.h"
#include "matrice.h"
#include "dct.h"

/*
 * La fonction calculant les coefficients de la DCT (et donc de l'inverse)
 * car la matrice de l'inverse DCT est la transposée de la matrice DCT
 *
 * Cette fonction prend beaucoup de temps.
 * il faut que VOUS l'utilisiez le moins possible (UNE SEULE FOIS)
 *
 * FAITES LES CALCULS EN "double"
 *
 * La valeur de Pi est : M_PI
 *
 * Pour ne pas avoir de problèmes dans la suite du TP, indice vos tableau
 * avec [j][i] et non [i][j].
 */

void coef_dct(Matrice *table)
{
	double sizeTable = sqrt(table->width);
	double sqrt2=sqrt(2);
	double todivide=2*table->width;
	for(int i=0;i<table->height;i++)
	{
		table->t[0][i]=1/sizeTable;
		double tomultiplie=2*i+1;
		for(int j=1;j<table->width; j++)
		{
			table->t[j][i]=(sqrt2/sizeTable)*cos(j*M_PI*(tomultiplie/todivide));
		}
	}
}

/*
 * La fonction calculant la DCT ou son inverse.
 *
 * Cette fonction va être appelée très souvent pour faire
 * la DCT du son ou de l'image (nombreux paquets).
 */

void dct(int   inverse,		/* ==0: DCT, !=0 DCT inverse */
	 int nbe,		/* Nombre d'échantillons  */
	 const float *entree,	/* Le son avant transformation (DCT/INVDCT) */
	 float *sortie		/* Le son après transformation */
	 )
{
	Matrice * DCT;
	DCT=allocation_matrice_float(nbe, nbe);
	coef_dct(DCT);
	if(inverse==0)
		produit_matrice_vecteur(DCT,entree,sortie);
	else
	{
		Matrice * DCTINV;
		DCTINV=allocation_matrice_float(nbe, nbe);
		transposition_matrice(DCT,DCTINV);
		produit_matrice_vecteur(DCTINV,entree,sortie);
		liberation_matrice_float(DCTINV);
	}
	liberation_matrice_float(DCT);
}
