
#include <netImage.h>
#include <stdlib.h>

static int saturate(int x)
{
  if(x < 0)
    return 0;
  if(x > 255)
    return 255;
  return x;
}

/* Apply the smooth mask to create a new array.  Free the original
   and return the new array */
static unsigned char **smooth_gray( unsigned char **a, int rows,int cols)
{
  int i,j,sum;
  unsigned char **tmp;

  // allocate new image data
  tmp = malloc(rows * sizeof(unsigned char *));
  for( i=0; i<rows; i++)
    tmp[i] = malloc(cols * sizeof(unsigned char));


  for( i=1; i<rows-1; i++)
    for( j=1; j<cols -1; j++ )
      {
        sum = 4*(int)a[i][j] +
          2*((int)a[i-1][j]+a[i+1][j]+a[i][j-1]+a[i][j+1])+ 
          ((int)a[i-1][j-1]+a[i+1][j-1]+a[i+1][j-1]+a[i+1][j+1]);

        tmp[i][j] = saturate(sum/16);
      }
  
  /* fix up the corners */
  tmp[0][0] = (4*(int)a[0][0] + 2*(a[1][0]+a[0][1]) + a[1][1])/9;

  tmp[0][cols-1] = (4*(int)a[0][cols-1] +
                    2*((int)a[1][cols-1]+a[0][cols-2]) + a[1][cols-2])/9;

  tmp[rows-1][0] = (4*(int)a[rows-1][0] +
                    2*((int)a[rows-2][0]+a[rows-1][1]) + a[rows-2][1])/9;

  tmp[rows-1][cols-1] = (4*(int)a[rows-1][cols-1] +
                         2*((int)a[rows-2][cols-1]+a[rows-1][cols-2]) +
                         a[rows-2][cols-2])/9;


  /* fix up the vertical borders */
  for(i=1;i<rows-1;i++)
    {    
      tmp[i][0] = (4*(int)a[i][0] +
                   2*((int)a[i-1][0] + a[i][1] + a[i+1][0])+
                   ((int)a[i-1][1] + a[i+1][1]))/12;
      
      tmp[i][cols-1] = (4*(int)a[i][cols-1] +
                        2*((int)a[i-1][cols-1] + a[i][cols-2] + a[i+1][cols-1])+
                        ((int)a[i-1][cols-2] + a[i+1][cols-2]))/12;
    }
  
  /* fix up the horizontal borders */
  for(i=1;i<cols-1;i++)
    {    
      tmp[0][i] = (4*(int)a[0][i] +
                   2*((int)a[0][i-1] + a[1][i] + a[0][i+1])+
                   ((int)a[1][i-1] + a[1][i+1]))/12;
      
      tmp[rows-1][i] = (4*(int)a[rows-1][i] +
                        2*((int)a[rows-1][i-1] + a[rows-2][i] + a[rows-1][i+1])+
                        ((int)a[rows-2][i-1] + a[rows-2][i+1]))/12;
    }
  
    
  for( i=0; i<rows; i++)
    free(a[i]);
  free(a);
  return tmp;

}


/* Apply the smooth mask to create a new array.  Free the original
   and return the new array */
static rgbpixel **smooth_rgb( rgbpixel **a, int rows,int cols)
{
  int i,j,sum;
  rgbpixel **tmp;

  // allocate new image data
  tmp = malloc(rows * sizeof(rgbpixel *));
  for( i=0; i<rows; i++)
    tmp[i] = malloc(cols * sizeof(rgbpixel));

  // do the interior pixels
  for( i=1; i<rows-1; i++)
    for( j=1; j<cols -1; j++ )
      {
        sum = 4*(int)a[i][j].red +
          2*((int)a[i-1][j].red +a[i+1][j].red +a[i][j-1].red+a[i][j+1].red)+ 
          ((int)a[i-1][j-1].red+a[i+1][j-1].red+a[i+1][j-1].red+a[i+1][j+1].red);
        tmp[i][j].red = saturate(sum/16);

        sum = 4*(int)a[i][j].green +
          2*((int)a[i-1][j].green +a[i+1][j].green +a[i][j-1].green+a[i][j+1].green)+ 
          ((int)a[i-1][j-1].green+a[i+1][j-1].green+a[i+1][j-1].green+a[i+1][j+1].green);
        tmp[i][j].green = saturate(sum/16);

        sum = 4*(int)a[i][j].blue +
          2*((int)a[i-1][j].blue +a[i+1][j].blue +a[i][j-1].blue+a[i][j+1].blue)+ 
          ((int)a[i-1][j-1].blue+a[i+1][j-1].blue+a[i+1][j-1].blue+a[i+1][j+1].blue);
        tmp[i][j].blue = saturate(sum/16);
      }
  
  /* fix up the corners */
  tmp[0][0].red = (4*(int)a[0][0].red + 2*(a[1][0].red+a[0][1].red) + a[1][1].red)/9;

  tmp[0][cols-1].red = (4*(int)a[0][cols-1].red +
                    2*((int)a[1][cols-1].red+a[0][cols-2].red) + a[1][cols-2].red)/9;

  tmp[rows-1][0].red = (4*(int)a[rows-1][0].red +
                    2*((int)a[rows-2][0].red+a[rows-1][1].red) + a[rows-2][1].red)/9;

  tmp[rows-1][cols-1].red = (4*(int)a[rows-1][cols-1].red +
                         2*((int)a[rows-2][cols-1].red+a[rows-1][cols-2].red) +
                         a[rows-2][cols-2].red)/9;

  /* fix up the vertical borders */
  for(i=1;i<rows-1;i++)
    {    
      tmp[i][0].red = (4*(int)a[i][0].red +
                   2*((int)a[i-1][0].red + a[i][1].red + a[i+1][0].red)+
                   ((int)a[i-1][1].red + a[i+1][1].red))/12;
      
      tmp[i][cols-1].red = (4*(int)a[i][cols-1].red +
                        2*((int)a[i-1][cols-1].red + a[i][cols-2].red + a[i+1][cols-1].red)+
                        ((int)a[i-1][cols-2].red + a[i+1][cols-2].red))/12;
    }
  
  /* fix up the horizontal borders */
  for(i=1;i<cols-1;i++)
    {    
      tmp[0][i].red = (4*(int)a[0][i].red +
                   2*((int)a[0][i-1].red + a[1][i].red + a[0][i+1].red)+
                   ((int)a[1][i-1].red + a[1][i+1].red))/12;
      
      tmp[rows-1][i].red = (4*(int)a[rows-1][i].red +
                        2*((int)a[rows-1][i-1].red + a[rows-2][i].red + a[rows-1][i+1].red)+
                        ((int)a[rows-2][i-1].red + a[rows-2][i+1].red))/12;
    }
  
  /* fix up the corners */
  tmp[0][0].green = (4*(int)a[0][0].green + 2*(a[1][0].green+a[0][1].green) + a[1][1].green)/9;

  tmp[0][cols-1].green = (4*(int)a[0][cols-1].green +
                    2*((int)a[1][cols-1].green+a[0][cols-2].green) + a[1][cols-2].green)/9;

  tmp[rows-1][0].green = (4*(int)a[rows-1][0].green +
                    2*((int)a[rows-2][0].green+a[rows-1][1].green) + a[rows-2][1].green)/9;

  tmp[rows-1][cols-1].green = (4*(int)a[rows-1][cols-1].green +
                         2*((int)a[rows-2][cols-1].green+a[rows-1][cols-2].green) +
                         a[rows-2][cols-2].green)/9;

  /* fix up the vertical borders */
  for(i=1;i<rows-1;i++)
    {    
      tmp[i][0].green = (4*(int)a[i][0].green +
                   2*((int)a[i-1][0].green + a[i][1].green + a[i+1][0].green)+
                   ((int)a[i-1][1].green + a[i+1][1].green))/12;
      
      tmp[i][cols-1].green = (4*(int)a[i][cols-1].green +
                        2*((int)a[i-1][cols-1].green + a[i][cols-2].green + a[i+1][cols-1].green)+
                        ((int)a[i-1][cols-2].green + a[i+1][cols-2].green))/12;
    }
  
  /* fix up the horizontal borders */
  for(i=1;i<cols-1;i++)
    {    
      tmp[0][i].green = (4*(int)a[0][i].green +
                   2*((int)a[0][i-1].green + a[1][i].green + a[0][i+1].green)+
                   ((int)a[1][i-1].green + a[1][i+1].green))/12;
      
      tmp[rows-1][i].green = (4*(int)a[rows-1][i].green +
                        2*((int)a[rows-1][i-1].green + a[rows-2][i].green + a[rows-1][i+1].green)+
                        ((int)a[rows-2][i-1].green + a[rows-2][i+1].green))/12;
    }
  
  /* fix up the corners */
  tmp[0][0].blue = (4*(int)a[0][0].blue + 2*(a[1][0].blue+a[0][1].blue) + a[1][1].blue)/9;

  tmp[0][cols-1].blue = (4*(int)a[0][cols-1].blue +
                    2*((int)a[1][cols-1].blue+a[0][cols-2].blue) + a[1][cols-2].blue)/9;

  tmp[rows-1][0].blue = (4*(int)a[rows-1][0].blue +
                    2*((int)a[rows-2][0].blue+a[rows-1][1].blue) + a[rows-2][1].blue)/9;

  tmp[rows-1][cols-1].blue = (4*(int)a[rows-1][cols-1].blue +
                         2*((int)a[rows-2][cols-1].blue+a[rows-1][cols-2].blue) +
                         a[rows-2][cols-2].blue)/9;

  /* fix up the vertical borders */
  for(i=1;i<rows-1;i++)
    {    
      tmp[i][0].blue = (4*(int)a[i][0].blue +
                   2*((int)a[i-1][0].blue + a[i][1].blue + a[i+1][0].blue)+
                   ((int)a[i-1][1].blue + a[i+1][1].blue))/12;
      
      tmp[i][cols-1].blue = (4*(int)a[i][cols-1].blue +
                        2*((int)a[i-1][cols-1].blue + a[i][cols-2].blue + a[i+1][cols-1].blue)+
                        ((int)a[i-1][cols-2].blue + a[i+1][cols-2].blue))/12;
    }
  
  /* fix up the horizontal borders */
  for(i=1;i<cols-1;i++)
    {    
      tmp[0][i].blue = (4*(int)a[0][i].blue +
                   2*((int)a[0][i-1].blue + a[1][i].blue + a[0][i+1].blue)+
                   ((int)a[1][i-1].blue + a[1][i+1].blue))/12;
      
      tmp[rows-1][i].blue = (4*(int)a[rows-1][i].blue +
                        2*((int)a[rows-1][i-1].blue + a[rows-2][i].blue + a[rows-1][i+1].blue)+
                        ((int)a[rows-2][i-1].blue + a[rows-2][i+1].blue))/12;
    }
  
  for( i=0; i<rows; i++)
    free(a[i]);
  free(a);
  return tmp;

}


void smoothImage( netImage *image)
{
   switch(image->magicNumber)
    {
    case '3':
    case '6':
      image->image = smooth_rgb(image->image,image->rows,image->cols);
      break;
    case '2':
    case '4':
      image->grayimage = smooth_gray(image->grayimage,image->rows,image->cols);
      break;
    default:
      fprintf(stderr,"Error smoothing unknown image type\n");
      exit(1);
    }

}
