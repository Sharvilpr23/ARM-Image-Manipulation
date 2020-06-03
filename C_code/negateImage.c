

#include <netImage.h>

void negateImage( netImage *image)
{
  {
    int row,col;
    if((image->magicNumber == '3') || (image->magicNumber == '6'))
      {
	for(row = 0; row < image->rows; row++)
	  for(col = 0; col < image->cols; col++)
	    {
	      image->image[row][col].red = 255 - image->image[row][col].red;
	      image->image[row][col].green = 255 - image->image[row][col].green;
	      image->image[row][col].blue = 255 - image->image[row][col].blue;
	    }
      }
    else
      {
	for(row = 0; row < image->rows; row++)
	  for(col = 0; col < image->cols; col++)
	    image->grayimage[row][col] = 255 - image->grayimage[row][col];
      }
  }
}

