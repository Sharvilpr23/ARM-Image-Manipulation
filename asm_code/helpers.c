#include <stdlib.h>
#include <netImage.h>

rgbpixel ** fixSharpenBorders(rgbpixel **pix, int rows, int cols)
{
    for( int i = 1; i < rows - 1; ++i )
    {
      pix[i][0] = pix[i][1];
      pix[i][cols-1] = pix[i][cols-2];

      if ( i < cols - 1 )
      {
        pix[0][i] = pix[1][i];
        pix[rows-1][i] = pix[rows-2][i];
      }
    } 
    
  pix[0][0] = pix[1][1];
  pix[0][cols-1] = pix[1][cols-2];
  pix[rows-1][0] = pix[rows-2][1];
  pix[rows-1][cols-1] = pix[rows-2][cols-2];

  return pix;
}

unsigned char **allocate_pixel_array(int rows, int cols)
{
  unsigned char **array;
  int i;
  if((array = malloc(sizeof(unsigned char *)*rows))==NULL)
    {
      fprintf(stderr,"Unable to allocate space for input image\n");
      exit(1);
    }
  for(i=0;i<rows;i++)
    if((array[i] = malloc(sizeof(unsigned char)*cols))==NULL)
      {
fprintf(stderr,"Unable to allocate space for input image\n");
exit(1);
      }
  return array;
}

rgbpixel **allocate_struct_array(int rows, int cols)
{
    rgbpixel **array;
    int i;
   
    if((array = malloc(sizeof(rgbpixel *)* rows )) == NULL )  
    {
      fprintf(stderr,"Unable to allocate space for input image\n");
      exit(1);

    }

    for ( i = 0; i < rows; ++i )
    {

if( (array[i] = malloc(sizeof(rgbpixel )* cols )) == NULL )  
{
   fprintf(stderr,"Unable to allocate space for input image\n");
   exit(1);

}
    }

    return array;
}

void free_array( char unsigned **image, int rows )
{
    for ( int i = 0; i < rows; ++i )
    {
free(image[i]);
    }
   
    free(image);
}

op_list * add_op(op_list* list,op_t operation, char *argument)
{
  op_list *new_op = malloc(sizeof(op_list));
  new_op->operation = operation;
  new_op->argument = argument;
  new_op->next = NULL;

  if(list == NULL)
    return new_op;
  
  if(list->next == NULL)
    list->next = new_op;
  else
    add_op(list->next,operation,argument);

  return list;
}



blend_list * add_file(blend_list* list,char *strength, char *filename)
{
  blend_list *new_file = malloc(sizeof(blend_list));
  new_file->filename = filename;
  new_file->strength = strength;
  new_file->next = NULL;

  if(list == NULL)
    return new_file;
  
  if(list->next == NULL)
    list->next = new_file;
  else
    add_file(list->next, strength, filename);

  return list;
}



int crop( int value )
{
    if( value < 0 )
        return 0;
    if( value > 255 )
        return 255;
    return value;
}

