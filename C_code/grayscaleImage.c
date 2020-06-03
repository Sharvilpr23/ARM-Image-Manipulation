
#include <netImage.h>
#include <stdlib.h>


static minMax get_bounds(unsigned char **a,int rows,int cols)
{
  int i,j;
  minMax mm = {255,0};
  for(i=0;i<rows;i++)
    for(j=0;j<cols;j++)
      {
        if(a[i][j]<mm.min)
          mm.min=a[i][j];
        if(a[i][j]>mm.max)
          mm.max=a[i][j];
      }
  return mm;
}

minMax grayscaleImage( netImage *image)
{
  int row,col;
  if((image->magicNumber == '3') || (image->magicNumber == '6'))
    {
      image->grayimage = malloc(image->rows * sizeof(unsigned char *));
      for(row = 0; row < image->rows; row++)
	image->grayimage[row] = malloc(image->cols * sizeof(unsigned char));
      for(row = 0; row < image->rows; row++)
	for(col = 0; col < image->cols; col++)
	  image->grayimage[row][col] =
	    image->image[row][col].red * 0.21 +
	    image->image[row][col].green * 0.72 +
	    image->image[row][col].blue * 0.07;
      image->magicNumber -= '1';
    }
  return get_bounds(image->grayimage,image->rows,image->cols);
}
