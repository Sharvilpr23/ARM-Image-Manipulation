#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>

#include <netImage.h>

struct option options[] = {
  {"brighten", 1, NULL, 'b'},
  {"negate", 0, NULL, 'n'},
  {"sharpen", 0,  NULL, 'p'},
  {"smooth", 0, NULL, 's'},
  {"grayscale", 0,  NULL, 'g'},
  {"contrast", 0,  NULL, 'c'},
  {"subsample", 1, NULL, 'm'},
  {"blend", 0, NULL, 'd'},
  {"binary", 0, NULL, 'y'},
  {"ascii", 0, NULL, 'a'},
  {"output", 1, NULL, 'o'},
  {"help", 0, NULL, 'h'},
  {0}
};

char *description[] = {
  "    Brighten the image.  The required argument must be a number\n"
  "    between 0 and 255 specifying the amount by which the brightness"
  "    should be changed.",
  
  "    Create a negative image.",

  "    Sharpen the image.",

  "    Smooth the image.",

  "    Convert to grayscale.",

  "    Maximize contrast.",

  "    Subsample an image.  The required argument must be an integer\n"
  "    specifying the square root of the number of input pixels that\n"
  "    are combined to form an output pixel.",

  "    Blend two or more images.  At least two input file names must be\n"
  "    provided, and all of the images must be the same size.  The\n"
  "    filename of each image must be preceded by a number between 0.0\n"
  "    and 1.0 indicating the 'strength' of that image in the resulting\n"
  "    blended image.",

  "    Output in binary.  Default is to output in same format as the input,\n"
  "    or ASCII if blending.",

  "    Output in ASCII.  Default is to output in same format as the input,\n"
  "    or ASCII if blending.",

  "    <arg> is the name of the output file.  If no name is given, output\n"
  "    is written to stdout,",
  "",
  ""
};



void usage(char *name)
{
  int i;
  printf("\nUSAGE: ");
  printf("%s <command> [[strength] input_file].. [-o output_file]\n",name);
  printf("  where command is one of:\n\n");
  for(i=0;options[i].name!=NULL;i++)
    {
      if(options[i].has_arg==1)
	printf("  --%s <arg> or -%c <arg>\n",options[i].name, options[i].val );
      else
	printf("  --%s or -%c\n",options[i].name, options[i].val );
      printf("%s\n\n",description[i]);
    }
  exit(1);
}

void blend_err()
{
  fprintf(stderr,"You cannot combine blending "
	  "with other operations\n");
  exit(1);
}

int main(int argc, char **argv)
{
  int c,i;
  char *argument;
  char *ofname = NULL;
  int option_index = 0;
  op_t op;
  FILE *ofile,*ifile;
  int blending = 0;
  int num_ops = 0;
  op_list *ops = NULL;
  op_list *next_op;
  blend_list *input_files = NULL;
  netImage *processed_image;


  while((c = getopt_long (argc, argv, "b:npsgcm:dyao:h", options,
  			  &option_index)) >= 0)
    {
      switch(c)
        {
        case 'b':
	  if(blending)
	    blend_err();
	  num_ops++;
	  op = BRIGHTEN;
	  argument = strdup(optarg);
	  for(i=0;i<strlen(argument);i++)
	    if(!isdigit(argument[i]))
	      {
		fprintf(stderr,"-b or --brighten must "
			"be followed by a number.\n");
		exit(1);
	      }
	  printf("You want to brighten.\n");
          break;
        case 'n':
	  if(blending)
	    blend_err();
	  num_ops++;
	  op = NEGATE;
	  argument = NULL;
	  printf("You want to negate.\n");
          break;
        case 'p':
	  if(blending)
	    blend_err();
	  num_ops++;
	  op = SHARPEN;
	  argument = NULL;
	  printf("You want to sharpen.\n");
          break;
        case 's':
	  if(blending)
	    blend_err();
	  num_ops++;
	  op = SMOOTH;
	  argument = NULL;
	  printf("You want to smooth.\n");
          break;
        case 'g':
	  if(blending)
	    blend_err();
	  num_ops++;
	  op = GRAYSCALE;
	  argument = NULL;
	  printf("You want to grayscale.\n");
          break;
        case 'c':
	  if(blending)
	    blend_err();
	  num_ops++;
	  op = CONTRAST;
	  argument = NULL;
	  printf("You want to contrast.\n");
          break;
        case 'm':
	  if(blending)
	    blend_err();
	  num_ops++;
	  op = SUBSAMPLE;
	  argument = strdup(optarg);
	  for(i=0;i<strlen(argument);i++)
	    if(!isdigit(argument[i]))
	      {
		fprintf(stderr,"-s or --subsample must "
			"be followed by a number.\n");
		exit(1);
	      }
	  printf("You want to subsample by %s.\n",argument);
          break;
        case 'd':
	  if(num_ops>0)
	    blend_err();
	  blending=1;
	  op = BLEND;
	  printf("You want to blend.\n");
          break;
	case 'y':
	  op = BINARY;
	  argument = NULL;
	  printf("Output in binary.\n");
	  break;
	case 'a':
	  op = ASCII;
	  argument = NULL;
	  printf("Output in ASCII.\n");
	  break;
        case 'o':
	  ofname = strdup(optarg);
	  //printf("You want output in %s.\n",ofname);
	  break;
        case '?':
        case 'h':
        default:
          usage(argv[0]);
          exit(1);
          break;
        }
      
      if(strchr("bnpsgcm",c)!=NULL)
      	ops = add_op(ops, op, argument);

}
  
  if(!num_ops && !blending)
    usage(argv[0]);

  if(ofname == NULL)
    ofile = stdout;
  else
    if((ofile = fopen(ofname,"w")) == NULL)
      {
	fprintf(stderr,"%s: Unable to open output file.  ",argv[0]);
	perror(NULL);
	exit(1);
      }
 
  /* any remaining arguments must be input files */

  if(blending)
    {
      if(((argc-optind) %2)||((argc-optind) < 4))
	{
	  fprintf(stderr,"Wrong number of file arguments. You must specify\n"
		  "at least two input file names, and each file name\n"
		  "must be preceeded by a number between 0.0 and 1.0.\n");
	  exit(1);
	}
      for(i=optind;i<argc;i+=2)
	input_files = add_file(input_files,argv[i],argv[i+1]);
      processed_image = blendImages(input_files);
    }
  else
    if((argc-optind) > 1)
      {
	fprintf(stderr,"Too many input files specified: ");
	for(i=optind;i<argc;i++)
	  fprintf(stderr,"%s ",argv[i]);
	exit(1);
      }
    else
      {
	if((argc-optind) == 0)
	  ifile = stdin;
	else
	  // open the input file
	  if((ifile = fopen(argv[optind],"r")) == NULL)
	    {	
	      fprintf(stderr,"%s: Unable to open input file.  ",argv[0]);
	      perror(NULL);
	      exit(1);
	    }
	processed_image = readImage(ifile);
	for(next_op = ops; next_op != NULL; next_op=next_op->next)
	  {
	    printf("performing op %d\n",next_op->operation);
	    switch(next_op->operation)
	      {
	      case BRIGHTEN:
		brightenImage(processed_image,next_op->argument);
		break;
	      case NEGATE:
		negateImage(processed_image);
		break;
	      case SHARPEN:
		sharpenImage(processed_image);
		break;
	      case SMOOTH:
		smoothImage(processed_image);
		break;
	      case GRAYSCALE:
		grayscaleImage(processed_image);
		break;
	      case CONTRAST:contrastImage(processed_image);
		break;
	      case SUBSAMPLE:
		subsampleImage(processed_image,next_op->argument);
	      case BINARY:
		switch(processed_image->magicNumber)
		  {
		  case '1':
		    processed_image->magicNumber = '4';
		    break;
		  case '2':
		    processed_image->magicNumber = '5';
		    break;
		  case '3':
		    processed_image->magicNumber = '6';
		    break;
		  }
		break;
	      case ASCII:
		switch(processed_image->magicNumber)
		  {
		  case '4':
		    processed_image->magicNumber = '1';
		    break;
		  case '5':
		    processed_image->magicNumber = '2';
		    break;
		  case '6':
		    processed_image->magicNumber = '3';
		    break;
		  }
		break;
	      default:
		break;
	      }
	  }
      }
  writeImage(ofile, processed_image);

  if(ofname != NULL)
    fclose(ofile);

  return 0;
}

