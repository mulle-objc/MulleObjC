#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


static void   fail( char *format, ...)
{
   va_list   args;

   va_start( args, format);
   mulle_vfprintf( stderr, format, args);
   va_end( args);
   exit( 1);
}

int  main()
{
   NSAutoreleasePool   *root;
   NSAutoreleasePool   *pool;
   NSAutoreleasePool   *parent;

   root = [NSAutoreleasePool mulleDefaultAutoreleasePool];
   if( ! root)
      fail( "1. Expected pool not found\n");
   [root mulleSetNameUTF8String:"root"];

   parent = [NSAutoreleasePool mulleParentAutoreleasePool];
   if( parent)
      fail( "2. Unexpected parent pool \"%s\" found\n", [parent mulleNameUTF8String]);

   @autoreleasepool
   {
      parent = [NSAutoreleasePool mulleParentAutoreleasePool];
      if( parent != root)
         fail( "3. Unexpected parent pool \"%s\" found\n", [parent mulleNameUTF8String]);
      pool = [NSAutoreleasePool mulleDefaultAutoreleasePool];
      if( ! pool)
         fail( "4. Expected pool not found\n");
      if( pool == parent)
         fail( "5. Unexpected parent pool \"%s\" found\n", [pool mulleNameUTF8String]);
      [pool mulleSetNameUTF8String:"a"];

      @autoreleasepool
      {
         parent = [NSAutoreleasePool mulleParentAutoreleasePool];
         if( parent != pool)
            fail( "6. Unexpected parent pool \"%s\" found\n", [parent mulleNameUTF8String]);

         pool = [NSAutoreleasePool mulleDefaultAutoreleasePool];
         if( ! pool)
            fail( "7. Expected pool not found\n");
         if( pool == parent)
            fail( "8. Unexpected parent pool \"%s\" found\n", [pool mulleNameUTF8String]);
      }
   }
   return( 0);
}
