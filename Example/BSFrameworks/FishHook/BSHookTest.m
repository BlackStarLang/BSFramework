//
//  BSHookTest.m
//  BSInject
//
//  Created by zongheng on 2023/3/31.
//  Copyright © 2023 blackstar_lang@163.com. All rights reserved.
//

#import "BSHookTest.h"
//#import "fishhook.h"

//typedef int (*ptrace_ptr_t)(int _request,pid_t _pid, caddr_t _addr,int _data);
//static ptrace_ptr_t orig_ptrace = NULL;

@implementation BSHookTest

//int (*ptrace_org)(int _request, pid_t _pid, caddr_t _addr, int _data);
//
//int my_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data){
//    if(_request != 31){
//        return orig_ptrace(_request,_pid,_addr,_data);
//    }
//    return 0;
//}
//
//__attribute__((constructor)) void hook(void) {
//    rebind_symbols((struct rebinding[1]){{"ptrace", my_ptrace, (void*)&orig_ptrace}},1);
//}

@end
