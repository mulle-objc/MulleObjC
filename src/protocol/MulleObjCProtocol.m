#import "MulleObjCProtocol.h"

#import "NSObjectProtocol.h"


PROTOCOLCLASS_IMPLEMENTATION( MulleObjCImmutable)

- (id) copy
{
   return( [self retain]);
}


- (id) copyWithZone:(void *) zone
{
   return( [self retain]);
}


PROTOCOLCLASS_END()
