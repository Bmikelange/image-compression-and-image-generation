#include "matrice.h"
#include "dct.h"
#include "jpg.h"
#include "image.h"

/*
 * Calcul de la DCT ou de l'inverse DCT sur un petit carré de l'image.
 * On fait la transformation de l'image ``sur place'' c.a.d.
 * que le paramètre "image" est utilisé pour l'entrée et la sortie.
 *
 * DCT de l'image :  DCT * IMAGE * DCT transposée
 * Inverse        :  DCT transposée * I' * DCT
 */
void dct_image(int inverse, int nbe, Matrice *image)
{
  Matrice * DCT;
  Matrice * DCTTrans;

  Matrice * ImgSortie;

	DCT=allocation_matrice_float(nbe, nbe);
  DCTTrans=allocation_matrice_float(nbe, nbe);
  ImgSortie=allocation_matrice_float(image->height, image->width);

  coef_dct(DCT);
  transposition_matrice(DCT,DCTTrans);

  if(inverse==0)
  {
    produit_matrices_float(DCT,image,ImgSortie);
    produit_matrices_float(ImgSortie,DCTTrans,image);
  }
  else
  {
    produit_matrices_float(DCTTrans,image,ImgSortie);
    produit_matrices_float(ImgSortie,DCT,image);
  }
  liberation_matrice_float(DCT);
  liberation_matrice_float(DCTTrans);
  liberation_matrice_float(ImgSortie);
}

/*
 * Quantification/Déquantification des coefficients de la DCT
 * Si inverse est vrai, on déquantifie.
 * Attention, on reste en calculs flottant (en sortie aussi).
 */
void quantification(int nbe, int qualite, Matrice *extrait, int inverse)
{
  if(inverse==0)
  {
    for(int i=0;i<extrait->height;i++)
      for(int j=0;j<extrait->width;j++)
      {
        extrait->t[i][j]=extrait->t[i][j]/(1+(i+j+1)*qualite);
      }
  }
  else
  {
    for(int i=0;i<extrait->height;i++)
      for(int j=0;j<extrait->width;j++)
      {
        extrait->t[i][j]=extrait->t[i][j]*(1+(i+j+1)*qualite);
      }
  }
}
/*
 * ZIGZAG.
 * On fournit à cette fonction les coordonnées d'un point
 * et elle nous donne le suivant (Toujours YX comme d'habitude)
 *
 * +---+---+---+---+     +---+---+---+
 * |00 |01 |   |   |     |   |   |   |
 * | ----/ | /---/ |     | ----/ | | |
 * |   |/  |/  |/  |     |   |/  |/| |
 * +---/---/---/---+     +---/---/-|-+
 * |10/|  /|  /|   |     |  /|  /| | |
 * | / | / | / | | |     | / | / | | |
 * | | |/  |/  |/| |     | | |/  |/  |
 * +-|-/---/---/-|-+     +-|-/---/---+
 * | |/|  /|  /| | |     | |/|  /|   |
 * | / | / | / | | |     | / | ----- |
 * |   |/  |/  |/  |     |   |   |   |
 * +---/---/---/---+     +---+---+---+
 * |  /|  /|  /|   |    
 * | /---/ | /---- |    
 * |   |   |   |   |    
 * +---+---+---+---+    
 */
void zigzag(int nbe, int *y, int *x)
{
  static int sensx=0;
  static int sensy=0;
  if(*y==0 && (*x !=nbe-1))
  { 
    if(*x%2==1)
    {
      sensy=1;
      sensx=-1;
    }
    else
    {
      sensy=0;
      sensx=1;
    }
  }
  else if(*y==nbe-1 && (*x !=nbe-1))
  { 
    if(*x%2==1)
    {
      sensy=((nbe-1)%2)*(-1);
      sensx=1;
    }
    else
    {
      sensy=(1-(nbe-1)%2)*(-1);

      sensx=1;
    }
  }
  else if(*x==0)
  { 
    if(*y%2==1)
    {
      sensy=1;
      sensx=0;
    }
    else
    {
      sensy=-1;
      sensx=1;
    }   
  }
  else if(*x==nbe-1)
  { 
    if(*y%2==1)
    {
      sensy=1;
      sensx=(1-(nbe-1)%2)*(-1);
    }
    else
    {
      sensy=1;
      sensx=((nbe-1)%2)*(-1);
    }
  }
  *x+=sensx;
  *y+=sensy;
}
/*
 * Extraction d'une matrice de l'image (le résultat est déjà alloué).
 * La sous-image carrée à la position et de la taille indiquée
 * est stockée dans matrice "extrait"
 */

static void extrait_matrice(int y, int x, int nbe
			    , const struct image *entree
			    , Matrice *extrait
			    )
 {
  int i, j ;

  for(j=0;j<nbe;j++)
    for(i=0;i<nbe;i++)
      if ( j+y < entree->hauteur && i+x < entree->largeur )
	extrait->t[j][i] = entree->pixels[j+y][i+x] ;
      else
	extrait->t[j][i] = 0 ;
 }

/*
 * Insertion d'une matrice de l'image.
 * C'est l'opération inverse de la précédente.
 */

static void insert_matrice(int y, int x, int nbe
			   , Matrice *extrait
			   , struct image *sortie
			   )
 {
  int i, j ;

  for(j=0;j<nbe;j++)
    for(i=0;i<nbe;i++)
      if ( j+y < sortie->hauteur && i+x < sortie->largeur )
	{
	  if ( extrait->t[j][i] < 0 )
	    sortie->pixels[j+y][i+x] = 0 ;
	  else
	    {
	      if ( extrait->t[j][i] > 255 )
		sortie->pixels[j+y][i+x] = 255 ;
	      else
		sortie->pixels[j+y][i+x] = rint(extrait->t[j][i]) ;
	    }
	}
 }


/*
 * Compression d'une l'image :
 * Pour chaque petit carré on fait la dct et l'on stocke dans un fichier
 */
void compresse_image(int nbe, const struct image *entree, FILE *f)
 {
  static Matrice *tmp = NULL ;
  int i, j, k ;

  if ( tmp == NULL )
    {
      tmp = allocation_matrice_float(nbe, nbe) ;
    }

  for(j=0;j<entree->hauteur;j+=nbe)
    for(i=0;i<entree->largeur;i+=nbe)
      {
	extrait_matrice(j, i, nbe, entree, tmp) ;
	dct_image(0, nbe, tmp) ;
	for(k=0; k<nbe; k++)
	  assert(fwrite(tmp->t[k], sizeof(tmp->t[0][0]), nbe, f) == nbe) ;
      }
 }

/*
 * Décompression image
 * On récupère la DCT de chaque fichier, on fait l'inverse et
 * on insère dans l'image qui est déjà allouée
 */
void decompresse_image(int nbe, struct image *entree, FILE *f)
 {
  static Matrice *tmp = NULL ;
  int i, j, k ;

  if ( tmp == NULL )
    {
      tmp = allocation_matrice_float(nbe, nbe) ;
    }

  for(j=0;j<entree->hauteur;j+=nbe)
    for(i=0;i<entree->largeur;i+=nbe)
      {
	for(k=0; k<nbe; k++)
	  assert(fread(tmp->t[k], sizeof(tmp->t[0][0]), nbe, f) == nbe) ;
	dct_image(1, nbe, tmp) ;
	insert_matrice(j, i, nbe, tmp, entree) ;
      }
 }
