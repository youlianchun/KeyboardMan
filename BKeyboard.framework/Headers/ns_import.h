//
//  ns_import.h
//  BKeyboard
//
//  Created by YLCHUN on 2018/7/9.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#ifndef ns_import_h
#define ns_import_h

#define _NS_ATTR_USED __attribute__((used))
#define _NS_IMPORT_HEAD(__class__) _import_##__class__
#define _NS_IMPORT(__import__) extern void __import__(void) NS_UNAVAILABLE; __import__()
#define NS_IMPORT_EXTERN(__class__) _NS_ATTR_USED static void __import_##__class__() NS_UNAVAILABLE {_NS_IMPORT(_NS_IMPORT_HEAD(__class__));}
#define NS_IMPORT_IMPLEMENTATION(__class__) void _NS_IMPORT_HEAD(__class__)() {}

#endif /* ns_import_h */
