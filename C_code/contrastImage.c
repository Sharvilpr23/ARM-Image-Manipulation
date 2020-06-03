#include <stdio.h>
#include <netImage.h>


void contrastImage( netImage *image)
{
  int i,j;
  minMax values;
  double scale;

  values = grayscaleImage( image );
  if( values.max == values.min )
    scale = 1.0;
  else
    scale = 255.0 / ( values.max - values.min );

  for( i=0; i<image->rows; i++)
    for( j=0; j<image->cols; j++)
      image->grayimage[i][j] = 
	crop( (int)(scale*((int)image->grayimage[i][j] - 
			   (int)values.min )) + .5);
			     
}


