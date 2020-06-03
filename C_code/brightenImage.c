
#include <netImage.h>

void brightenImage( netImage *image, char *arg)
{
  int value,row,col;
  if((image->magicNumber == '3') || (image->magicNumber == '6'))
    {
      for(row = 0; row < image->rows; row++)
	for(col = 0; col < image->cols; col++)
	  {
	    value = image->image[row][col].red + *arg;
	    if(value < 0)
	      value = 0;
	    if(value > 255)
	      value = 255;
	    image->image[row][col].red = value;

	    value = image->image[row][col].green + *arg;
	    if(value < 0)
	      value = 0;
	    if(value > 255)
	      value = 255;
	    image->image[row][col].green = value;

	    value = image->image[row][col].blue + *arg;
	    if(value < 0)
	      value = 0;
	    if(value > 255)
	      value = 255;
	    image->image[row][col].blue = value;
	  }
    }
  else
    {
      for(row = 0; row < image->rows; row++)
	for(col = 0; col < image->cols; col++)
	  {
	    value = image->grayimage[row][col] + *arg;
	    if(value < 0)
	      value = 0;
	    if(value > 255)
	      value = 255;
	    image->grayimage[row][col] = value;
	  }
    }
}
 
