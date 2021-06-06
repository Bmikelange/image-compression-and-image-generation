#include "image.h"


/*
 * Lecture d'une ligne du fichier.
 * On saute les lignes commençant par un "#" (commentaire)
 * On simplifie en considérant que les lignes ne dépassent pas MAXLIGNE
 */

void lire_ligne(FILE *f, char *ligne)
{
    char n = fgetc(f);
    while(n =='#')
    {
        char ntemp=fgetc(f);
        while(ntemp != '\n')
        {
            ntemp =fgetc(f);
        }
        n =fgetc(f);
    }
    int count =0;
    while(n != '\n' && count < MAXLIGNE-1)
    {
        ligne[count]=n;
        n=fgetc(f);
        count++;
    }
    ligne[count]=n;
}

/*
 * Allocation d'une image
 */

struct image* allocation_image(int hauteur, int largeur)
{

    struct image * im=malloc(sizeof(struct image));
    im->hauteur=hauteur;
    im->largeur=largeur;
    im->pixels=malloc(hauteur*sizeof(unsigned char *));
    for(int i=0;i<hauteur;i++)
    {
        im->pixels[i]=malloc(largeur*sizeof(unsigned char));
    }
    return im; /* pour enlever un warning du compilateur */
}

/*
 * Libération image
 */

void liberation_image(struct image* image)
{
    for(int i=0;i<image->hauteur;i++)
    {
        free(image->pixels[i]);
    }
    free(image->pixels);
    free(image);
}

/*
 * Allocation et lecture d'un image au format PGM.
 * (L'entête commence par "P5\nLargeur Hauteur\n255\n"
 * Avec des lignes de commentaire possibles avant la dernière.
 */

struct image* lecture_image(FILE *f)
{
    int hauteur, largeur;
    char * c=malloc(MAXLIGNE*sizeof(char));
    lire_ligne(f,c);
    lire_ligne(f,c);
    sscanf(c,"%d %d", &largeur, &hauteur);
    lire_ligne(f,c);
    struct image * image = allocation_image(hauteur,largeur);
    for(int i=0;i<hauteur;i++)
    {
        for(int j=0;j<largeur;j++)
        {
            image->pixels[i][j]=fgetc(f);
        }
    }

return image ; /* pour enlever un warning du compilateur */
}

/*
 * Écriture de l'image (toujours au format PGM)
 */

void ecriture_image(FILE *f, const struct image *image)
{
    fprintf(f,"P5\n%d %d\n255\n",image->largeur, image->hauteur);
    for(int i=0;i<image->hauteur;i++)
    {
        for(int j=0;j<image->largeur;j++)
        {
            fputc(image->pixels[i][j],f);
        }
    }
}
