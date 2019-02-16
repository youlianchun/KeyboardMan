//
//  bk_import.h
//  BKeyboard
//
//  Created by YLCHUN on 2018/7/9.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#ifndef bk_import_h
#define bk_import_h

#define _BK_ATTR_USED __attribute__((used))
#define _BK_IMPORT_HEAD(__class__) _import_##__class__
#define _BK_IMPORT(__import__) extern void __import__(void) NS_UNAVAILABLE; __import__()
#define BK_IMPORT_EXTERN(__class__) _BK_ATTR_USED static void __import_##__class__() NS_UNAVAILABLE {_BK_IMPORT(_BK_IMPORT_HEAD(__class__));}
#define BK_IMPORT_IMPLEMENTATION(__class__) void _BK_IMPORT_HEAD(__class__)() {}

#endif /* bk_import_h */
