//
//  mulle_sprintf_object.h
//  MulleObjCValueFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#ifndef mulle_sprintf_object_h__
#define mulle_sprintf_object_h__

#include "include.h"

/**
 * @brief Provides custom sprintf conversion for Objective-C objects
 *
 * This module extends sprintf functionality to handle Objective-C objects
 * with special formatting options.
 *
 * - Provides colorized output when enabled and requested
 * - Handles nil object cases
 * - Supports a '#' modifier for colorized output
 *
 * * The selection chooses between these two methods based on:
 * 1. Whether the '#' modifier was used (info->memory.hash_found)
 * 2. Whether colorization is globally enabled
 *
 * Object Methods:
 *
 * - `UTF8String` Returns a UTF-8 encoded string.
 *    The "%@" conversion uses the standard -UTF8String which can lock. This is
 *    what eventually will call -description.
 *
 * - `colorizedUTF8String`    Returns a UTF-8 encoded string with color.
 *    This special method must be suitable for debugging, so it's important
 *    that "%#@" does not lock. This is supposed to be used in all format
 *    strings that does logging and introspection (po). -colorizedUTF8String
 *    will eventually call -nonLockingUTF8String which will provide the
 *    uncolored string.
 *
 * Colorization is controlled by environment variables:
 * - `NO_COLOR`: Disables color output
 * - `MULLE_NO_COLOR=YES`: Disables color output
 * - `TERM=dumb`: Disables color output
 *
 * @note Automatically registers object conversion functions at library initialization
 */

MULLE_OBJC_GLOBAL
void  mulle_sprintf_register_object_functions( struct mulle_sprintf_conversion *tables);

#endif
