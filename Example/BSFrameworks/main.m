//
//  main.m
//  BSFrameworks
//
//  Created by blackstar_lang@163.com on 03/28/2020.
//  Copyright (c) 2020 blackstar_lang@163.com. All rights reserved.
//

@import UIKit;
#import "BSAppDelegate.h"

//修改宏定义
#ifndef STAR_END_DEBUG
    #define STAR_END_DEBUG 15
#endif

#ifndef STAR_END_DEBUG_ADD
    #define STAR_END_DEBUG_ADD 16
#endif

int main(int argc, char * argv[])
{
    @autoreleasepool {
//        extern int ptrace(int request, pid_t pid, caddr_t addr, int data);
//        ptrace(STAR_END_DEBUG + STAR_END_DEBUG_ADD, 0, 0, 0);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([BSAppDelegate class]));
    }
}
