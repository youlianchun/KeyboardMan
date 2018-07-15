//
//  ATProxyImport.h
//  ATProxy
//
//  Created by YLCHUN on 2018/7/9.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#ifndef ATProxyImport_h
#define ATProxyImport_h

#define _AT_ATTR_USED __attribute__((used))
#define _AT_IMPORT_HEAD(__class__) _import_##__class__
#define _AT_IMPORT(__import__) extern void __import__(void) NS_UNAVAILABLE; __import__()
#define AT_IMPORT_EXTERN(__class__) _AT_ATTR_USED static void __import_##__class__() NS_UNAVAILABLE {_AT_IMPORT(_AT_IMPORT_HEAD(__class__));}
#define AT_IMPORT_IMPLEMENTATION(__class__) void _AT_IMPORT_HEAD(__class__)() {}

#endif /* ATProxyImport_h */
