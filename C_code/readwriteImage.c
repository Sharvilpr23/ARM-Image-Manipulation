#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <netImage.h>


netImage *readImage(FILE *inf)
{
  netImage *image;
  int i, j;
  int tmpred, tmpgreen, tmpblue;
  char nextchar;
  
  if((image = malloc(sizeof(netImage)))==NULL)
    {
      fprintf(stderr,"Unable to allocate space for input image\n");
      exit(1);
    }
  image->comment = NULL;
  image->grayimage = NULL;
  image->image = NULL;
  image->rows = 0;
  image->cols = 0;
  image->bpp = 0;
  image->magicNumber='0';
  nextchar = fgetc(inf);
  if(nextchar != 'P')
    {
      fprintf(stderr,"Input file is not a netpbm image\n");
      exit(1);
    }
  nextchar = fgetc(inf);
  if((nextchar != '3')&&(nextchar != '6'))
    {
      fprintf(stderr,"Input file is not a color Portable Pix Map file\n");
      exit(1);
    }
  image->magicNumber = nextchar;
  // find next non-whitespace
  while(isspace(nextchar = fgetc(inf)));
  // strip out comment lines
  if(nextchar == '#')
    {
      i = 0;
      image->comment = malloc(i+2);
      while(nextchar=='#')
	{
	  image->comment[i] = nextchar;
	  while((nextchar = fgetc(inf)) != '\n')
	    {
	      i++;
	      image->comment = realloc(image->comment, i+2);
	      image->comment[i]=nextchar;
	    }
	  i++;
	  image->comment = realloc(image->comment, i+2);
	  image->comment[i]=nextchar;
	  nextchar = fgetc(inf);
	  if(nextchar=='#')
	    {
	      i++;
	      image->comment = realloc(image->comment, i+2);
	      image->comment[i]=nextchar;
	    }
	}
      image->comment[i+1] = 0;
    }
  if(ungetc(nextchar, inf) == EOF)
    {
      fprintf(stderr,"Error reading input file header\n");
      exit(1);
    }
  if(fscanf(inf,"%d%d%d",&(image->cols),
	    &(image->rows),
	    &(image->bpp))!=3)
		
    {
      fprintf(stderr,"Error reading input file header\n");
      exit(1);
    }
  while((nextchar = fgetc(inf)) != '\n');

  if((image->image = malloc(sizeof(char *)*image->rows))==NULL)
    {
      fprintf(stderr,"Unable to allocate space for input image\n");
      exit(1);
    }
      
  for(i=0;i<image->rows;i++)
    {
      if((image->image[i] = malloc(sizeof(rgbpixel)*image->cols))==NULL)
	{
	  fprintf(stderr,"Unable to allocate space for input image\n");
	  exit(1);
	}
      switch(image->magicNumber)
	{
	case '3':
	  for( j=0; j<image->cols; j++)
	    {
	      if(fscanf(inf,"%d%d%d",&tmpred, &tmpgreen, &tmpblue)!=3)
		{
		  fprintf(stderr,"Unable to read all of image data\n");
		  exit(1);
		}
	      image->image[i][j].red = tmpred;
	      image->image[i][j].green = tmpgreen;
	      image->image[i][j].blue = tmpblue;
	    }
	  break;
	case '6':
	  if(fread(image->image[i],sizeof(rgbpixel),image->cols,inf)!=
	     image->cols)
	    {
	      fprintf(stderr,"Unable to read all of image data\n");
	      exit(1);
	    }
	  break;
	}
    }
  return image;
}

void writeImage(FILE *outf, netImage *image)
{
  int i,j;
  if(fprintf(outf,"P%c\n",
	     image->magicNumber) < 1)
    {
      fprintf(stderr,"Unable to write to output file.  ");
      perror(NULL);
      exit(1);
    }
  if(image->comment != NULL)
    if(fprintf(outf,"%s",image->comment) < 1)
    {
      fprintf(stderr,"Unable to write to output file.  ");
      perror(NULL);
      exit(1);
    }
  if(fprintf(outf,"%d %d\n%d\n",
	     image->cols,image->rows, image->bpp) < 3)
    {
      fprintf(stderr,"Unable to write to output file.  ");
      perror(NULL);
      exit(1);
    }
  if(image->magicNumber == '2') /* ASCII grayscale */
    {
      for(i=0;i<image->rows;i++)
	for(j=0;j<image->cols;j++)
	  if(fprintf(outf,"%d\n",image->grayimage[i][j])<1)
	    {
	      fprintf(stderr,"Unable to write to output file.  ");
	      perror(NULL);
	      exit(1);
	    }
    }
  else if(image->magicNumber == '3') /* ASCII color */
    {
      for(i=0;i<image->rows;i++)
	for(j=0;j<image->cols;j++)
	  if(fprintf(outf,"%d %d %d\n",
		     image->image[i][j].red,
		     image->image[i][j].green,
		     image->image[i][j].blue)< 3)
	    {
	      fprintf(stderr,"Unable to write to output file.  ");
	      perror(NULL);
	      exit(1);
	    }
    }
  else if(image->magicNumber == '5') /* binary grayscale */
    {
      for(i=0;i<image->rows;i++)
	if(fwrite(image->grayimage[i],image->cols,1,outf)<0)
	  {
	    fprintf(stderr,"Unable to write to output file.  ");
	    perror(NULL);
	    exit(1);
	  }
    }
  else if(image->magicNumber == '6') /* binary color */
    {
      for(i=0;i<image->rows;i++)
	if(fwrite(image->image[i],sizeof(rgbpixel),image->cols,outf)<0)
	  {
	    fprintf(stderr,"Unable to write to output file.  ");
	    perror(NULL);
	    exit(1);
	  }
    }
}


