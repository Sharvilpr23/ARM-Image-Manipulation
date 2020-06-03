#include <stdlib.h>
#include <netImage.h>


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

