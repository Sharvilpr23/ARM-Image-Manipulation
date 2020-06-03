#include <stdlib.h>
#include <netImage.h>

void sharpenImage( netImage *image)
{
  int i,j;
  rgbpixel **tmp;
  
  if((tmp = malloc(sizeof(rgbpixel *) * image->rows))==NULL)
    {
      fprintf(stderr,"Unable to allocate space for temporary image\n");
      exit(1);
    }
  for(i=0;i<image->rows;i++)
    if((tmp[i] = malloc(sizeof(rgbpixel) * image->cols))==NULL)
      {
	fprintf(stderr,"Unable to allocate space for temporary image\n");
	exit(1);
      }
  for( i=1; i<image->rows-1; i++)
    for( j=1; j<image->cols -1; j++ )
      {
	tmp[i][j].red = crop( 5 * image->image[i][j].red -
			      image->image[i-1][j].red -
			      image->image[i][j-1].red -
			      image->image[i][j+1].red -
			      image->image[i+1][j].red);
	tmp[i][j].green = crop( 5 * image->image[i][j].green -
			      image->image[i-1][j].green -
			      image->image[i][j-1].green -
			      image->image[i][j+1].green -
			      image->image[i+1][j].green);
	tmp[i][j].blue = crop( 5 * image->image[i][j].blue -
			      image->image[i-1][j].blue -
			      image->image[i][j-1].blue -
			      image->image[i][j+1].blue -
			      image->image[i+1][j].blue);
      }

  /* fix up the borders */
  for(i=1;i<image->rows-1;i++)
    {    
      tmp[i][0] = tmp[i][1];
      tmp[i][image->cols-1] = tmp[i][image->cols-2];
    }
  for(i=1;i<image->cols-1;i++)
    {    
      tmp[0][i] = tmp[1][i];
      tmp[image->rows-1][i] = tmp[image->rows-2][i];
    }
  /* fix up the corners */
  tmp[0][0] = tmp[1][1];
  tmp[0][image->cols-1] = tmp[1][image->cols-2];
  tmp[image->rows-1][0] = tmp[image->rows-2][1];
  tmp[image->rows-1][image->cols-1] = tmp[image->rows-2][image->cols-2];
  
  for(i=0;i<image->rows;i++)
    free(image->image[i]);
  free(image->image);
  image->image=tmp;
}
