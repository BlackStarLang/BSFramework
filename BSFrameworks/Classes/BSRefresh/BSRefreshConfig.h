//
//  BSRefreshConfig.h
//  BSFrameworks
//
//  Created by 叶一枫 on 2020/11/13.
//

#ifndef BSRefreshConfig_h
#define BSRefreshConfig_h

typedef enum : NSUInteger {
    BS_STATUS_NORMAL = 0,       //  普通状态
    BS_STATUS_WILL_REFRESHING,  //  即将刷新（手势拖动达到刷新要求）
    BS_STATUS_REFRESHING,       //  正在刷新状态
} BSSTATUS;


#endif /* BSRefreshConfig_h */
