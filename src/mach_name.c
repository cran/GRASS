#include <unistd.h>
#include "gis.h"
/* this routine returns a name for the machine
 * it returns the empty string, if this info
 * not available (it never returns a NULL pointer)
 *
 * the name is stored in a static array and the pointer to this
 * array is returned.
 *
 * the contents of this array are reset upon each call
 *
 */

#include "config.h"

#ifdef HAVE_SYS_UTSNAME_H
#include <sys/utsname.h>
static struct utsname attname;
#endif

char *
G__machine_name()
{
    static char name[128];

    *name = 0;

#ifdef HAVE_GETHOSTNAME
    gethostname(name, sizeof(name));
    name[sizeof(name)-1] = 0;	/* make sure null terminated */
#else
#ifdef HAVE_UNAME
    uname (&attname);
    strcpy (name, attname.nodename);
#endif
#endif

    return (name);
}
