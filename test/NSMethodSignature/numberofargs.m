#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


static struct _table
{
   char  *type;
   int   n;
} test_data[] =
{
   { "@@:", 2 },
   { "@16@0:8", 2 },
   { "@\"NSString\"16@0:8", 2 },

   { "@@:@@", 4 },
   { "@16@0:8@16@24", 4 },
   { "@\"NSString\"16@\"NSString\"0:8@\"NSString\"16@\"NSString\"24", 4 },
   0, 0
};


int  main( void)
{
   NSMethodSignature   *signature;
   struct _table       *p;

   for( p = test_data; p->type; p++)
   {
      signature = [NSMethodSignature signatureWithObjCTypes:p->type];
      if( [signature numberOfArguments] != p->n)
         printf( "Failed %s\n", p->type);
   }

   return( 0);
}
