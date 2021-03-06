/**********************************************************************
 *  G_write_colors (name, mapset, colors)
 *      char *name                   name of map
 *      char *mapset                 mapset that map belongs to
 *      struct Colors *colors        structure holding color info
 *
 *  Writes the color information associated with map layer "map"
 *  in mapset "mapset" from the structure "colors".
 *
 *  returns:    1  if successful
 *             -1  on fail
 *
 * If the environment variable FORCE_GRASS3_COLORS is set (to anything at all)
 * then the output format is 3.0, even if the structure contains 4.0 rules.
 * This allows users to create 3.0 color files for export to sites which
 * don't yet have 4.0
 ***********************************************************************/
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "gis.h"
#define PRECISION 30
#define THRESHOLD .0000000000000000000000000000005
/* .5 * 10 ^(-30) */

static int write_new_colors( FILE *, struct Colors *);
static int write_rules ( FILE *, struct _Color_Rule_ *, DCELL, DCELL);
static int write_old_colors ( FILE *, struct Colors *);
static int forced_write_old_colors ( FILE *, struct Colors *);
static int format_min (char *, double);
static int format_max (char *, double);

int G_write_colors (char *name, char *mapset, struct Colors *colors)
{
    char element[512];
    char xname[512], xmapset[512];
    FILE *fd;
    int stat;

    if (G__name_is_fully_qualified (name, xname, xmapset))
    {
	if (strcmp (xmapset, mapset) != 0)
	    return -1;
	name = xname;
    }
/*
 * if mapset is current mapset, remove colr2 file (created by pre 3.0 grass)
 *    and then write original color table
 * else write secondary color table
 */
    sprintf (element, "colr2/%s", mapset);
    if (strcmp (mapset, G_mapset()) == 0)
    {
	G_remove (element, name);	/* get rid of existing colr2, if any */
	strcpy (element, "colr");
    }
    if (!(fd = G_fopen_new (element, name)))
	return -1;

    stat = G__write_colors (fd, colors) ;
    fclose (fd);
    return stat;
}

int G__write_colors ( FILE *fd, struct Colors *colors)
{
    if (getenv("FORCE_GRASS3_COLORS"))
	return forced_write_old_colors (fd, colors);
    else if (colors->version < 0)
	return write_old_colors (fd, colors);
    else
	return write_new_colors (fd, colors);
}

static int write_new_colors( FILE *fd, struct Colors *colors)
{
    char str1[100], str2[100];

    format_min(str1, (double) colors->cmin);
    format_max(str2, (double) colors->cmax);
    fprintf(fd, "%% %s %s\n", str1, str2);

    if (colors->shift)
    {
        sprintf(str2, "%.10f", (double) colors->shift);
        G_trim_decimal(str2);
	fprintf (fd, "shift:%s\n", str2);
    }
    if (colors->invert)
	fprintf (fd, "invert\n");

    if (colors->null_set)
    {
        fprintf(fd, "nv:%d", colors->null_red); 
	if (colors->null_red != colors->null_grn || colors->null_red 
             != colors->null_blu)
	    fprintf (fd, ":%d:%d", colors->null_grn, colors->null_blu);
	fprintf (fd, "\n");
    }
    if (colors->undef_set)
    {
        fprintf(fd, "*:%d", colors->undef_red); 
	if (colors->undef_red != colors->undef_grn || colors->undef_red 
             != colors->undef_blu)
	    fprintf (fd, ":%d:%d", colors->undef_grn, colors->undef_blu);
	fprintf (fd, "\n");
    }
    if (colors->modular.rules)
    {
	fprintf (fd, "%s\n","%%");
	write_rules(fd, colors->modular.rules, colors->cmin, colors->cmax);
	fprintf (fd, "%s\n","%%");
    }
    if (colors->fixed.rules)
	write_rules(fd, colors->fixed.rules, colors->cmin, colors->cmax);

    return 1;
}

static int write_rules (
    FILE *fd,
    struct _Color_Rule_ *crules,
    DCELL dmin,
    DCELL dmax /* overall min and max data values in color table */
)
{
    struct _Color_Rule_ *rule;
    char str[100];

/* find the end of the rules list */
    rule = crules;
    while (rule->next)
	rule = rule->next;

/* write out the rules in reverse order */
    for ( ; rule; rule = rule->prev)
    {
	if(rule->low.value == dmin)
	   format_min(str, (double) rule->low.value);
        else
	{
	   sprintf(str, "%.10f", (double) rule->low.value);
	   G_trim_decimal(str);
        }
	fprintf (fd, "%s:%d", str, (int) rule->low.red);
	if (rule->low.red != rule->low.grn || rule->low.red != rule->low.blu)
	    fprintf (fd, ":%d:%d", rule->low.grn, rule->low.blu);
        /* even if low==high, write second end when the high is dmax */
	if (rule->high.value == dmax || rule->low.value != rule->high.value)
	{
	    if(rule->high.value == dmax)
	         format_max(str, (double) rule->high.value);
            else
	    {
	         sprintf(str, "%.10f", (double) rule->high.value);
	         G_trim_decimal(str);
            }
	    fprintf (fd, " %s:%d", str, (int) rule->high.red);
	    if (rule->high.red != rule->high.grn || rule->high.red != rule->high.blu)
		fprintf (fd, ":%d:%d", rule->high.grn, rule->high.blu);
	}
	fprintf (fd, "\n");
    }

    return 0;
}

static int write_old_colors ( FILE *fd, struct Colors *colors)
{
    int i,n;

    fprintf (fd, "#%ld first color\n", (long)colors->fixed.min) ;
    if(colors->null_set)
    { 
         fprintf (fd, "%d %d %d\n",
     	     (int)colors->null_red,
	     (int)colors->null_grn,
     	     (int)colors->null_blu);
    }
    else fprintf (fd, "255 255 255\n");  /* white */

    n = colors->fixed.max - colors->fixed.min + 1;

    for (i=0; i < n; i++)  
    {
	fprintf ( fd, "%d", (int)colors->fixed.lookup.red[i]);
	if (colors->fixed.lookup.red[i] != colors->fixed.lookup.grn[i] 
	||  colors->fixed.lookup.red[i] != colors->fixed.lookup.blu[i])
	    fprintf ( fd, " %d %d",
		(int)colors->fixed.lookup.grn[i],
		(int)colors->fixed.lookup.blu[i]) ;
	fprintf (fd, "\n");
    }

    return 1;
}

static int forced_write_old_colors ( FILE *fd, struct Colors *colors)
{
    int red,grn,blu;
    CELL cat;

    fprintf (fd, "#%ld first color\n", (long)colors->cmin) ;
    G_get_color ((CELL)0, &red, &grn, &blu, colors);
    fprintf (fd, "%d %d %d\n", red, grn, blu);

    for (cat = colors->cmin; cat <= colors->cmax; cat++)
    {
	G_get_color (cat, &red, &grn, &blu, colors);
	fprintf ( fd, "%d", red);
	if (red != grn || red != blu)
	    fprintf ( fd, " %d %d", grn, blu);
	fprintf (fd, "\n");
    }

    return 1;
}

static int format_min (char *str, double dval)
{
   double dtmp;
   sprintf(str, "%.*f", PRECISION, dval);
   G_trim_decimal(str);
   sscanf(str, "%lf", &dtmp);
   if(dtmp!=dval) /* if  no zeros after decimal point were trimmed */
   {
       sprintf(str, "%.*f", PRECISION, dval - THRESHOLD);
       /* because precision is probably higher than PRECISION */
   }

   return 0;
}

static int format_max (char *str, double dval)
{
   double dtmp;
   sprintf(str, "%.*f", PRECISION, dval);
   G_trim_decimal(str);
   sscanf(str, "%lf", &dtmp);
   if(dtmp!=dval) /* if  no zeros after decimal point were trimmed */
   {
       sprintf(str, "%.*f", PRECISION, dval + THRESHOLD);
       /* because precision is probably higher than PRECISION */
   }

   return 0;
}
