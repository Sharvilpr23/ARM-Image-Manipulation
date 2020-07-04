#include <stdlib.h>
#include <netImage.h>

rgbpixel ** fix_borders(rgbpixel **temp, int rows, int cols)
{
	for(int i  = 1; i < rows - 1; ++i)
	{
		temp[i][0] = temp[i][1];
		temp[i][cols - 1] = temp[i][cols - 2];

		if(i < cols - 1)
		{
			temp[0][i] = temp[1][i];
			temp[rows - 1][i] = temp[rows - 2][i];
		}
	}
	temp[0][0] = temp[1][1];
	temp[0][cols - 1] = temp[1][cols - 2];
	temp[rows - 1][0] = temp[rows - 2][1];
	temp[rows - 1][cols - 1] = temp[rows - 2][cols - 2];

	return temp;
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

