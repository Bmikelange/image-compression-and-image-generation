#include "bit.h"
#include <stdio.h>

/*
 * Retourne le nombre de bits utilisé pour coder l'entier
 * Voici quelques chiffres :
 * v=0 --> 0 bit  car sa représentation binaire est : ""
 * v=1 --> 1 bit  car sa représentation binaire est : "1"
 * v=2 --> 2 bits car sa représentation binaire est : "10"
 * v=3 --> 2 bits car sa représentation binaire est : "11"
 * v=4 --> 3 bits car sa représentation binaire est : "100"
 *
 * (Vous perdez des points de TP si vous utilisez une fonction travaillant
 * avec des nombres flottants)
 */

unsigned int nb_bits_utile(unsigned long v)
{
	int i=0;
	while(v)
	{
		v=v/2;
		i++;
	}
	return i ; /* pour enlever un warning du compilateur */
}

/*
 * Cette fonction retourne un entier ne contenant qu'un seul bit à 1.
 * La position de ce bit a 1 est indiqué par le paramètre.
 *
 *  Position   Valeur binaire   Valeur decimale
 *     0       0...00000001           1
 *     1       0...00000010           2
 *     .       ............          ..
 *     7       0...10000000         128
 *     .       ............        ....
 *     .       ............        ....
 *
 * La choix de numérotation de droite à gauche été faite car
 * la numérotation des bits ne change pas en fonction de la taille de l'entier.
 *
 * En fait, cette fonction est équivalente à "pow(2,position)"
 * (Vous perdez des points de TP si vous utilisez une fonction travaillant
 * avec des nombres flottants)
 */

unsigned long pow2(Position_Bit position)
{
	return (unsigned long) 1 << position;
}

/*
 * Cette fonction retourne le bit "n" d'un entier.
 * La valeur retournée sera un booléen : Vrai ou Faux
 *
 * prend_bit(2,0) ==> 0
 * prend_bit(2,1) ==> 1
 * prend_bit(2,2) ==> 0
 */

Booleen prend_bit(unsigned long c,	     /* L'entier où on prend le bit */
		  Position_Bit position	     /* La position du bit pris */
		  )
{
	return (c & pow2(position)) != 0; /* pour enlever un warning du compilateur */
}

/*
 * Idem pour le stockage, on stocke la valeur "bit" à la position indiquée.
 * Si "bit" est à Faux            on met le bit à 0
 * Si "bit" est différent de Faux on met le bit à 1
 */

unsigned long pose_bit(unsigned long c,	      /* Entier à modifier */
		       Position_Bit position, /* Position du bit à modifié */
		       Booleen      bit	      /* Nouvelle valeur du bit */
		       )
{
	return bit==0?c & ~pow2(position):
				   c | pow2(position); /* pour enlever un warning du compilateur */
}
