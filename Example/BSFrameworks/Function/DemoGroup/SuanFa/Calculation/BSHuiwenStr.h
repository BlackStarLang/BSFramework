//
//  BSHuiwenStr.h
//  BSFrameworks_Example
//
//  Created by 叶一枫 on 2020/12/21.
//  Copyright © 2020 blackstar_lang@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSHuiwenStr : NSObject

// 判断一个字符串是否含有大于等于4位的回文字符串，
// 有则返回 YES ，没有返回NO
/**
 * 思路：一个字符串是否含有4位或4位以上的回文字符串
 * 首先应该考虑需要做几种判断：首先回文字符串可以是单数的，也可以是双数的
 * 单数 如 abcba ，双数如 abba ，那么再看 abcdcba 和 abccba ，不难发现
 * 只要有 4位的回文 或者 5位的回文，就肯定包含回文字符串
 * 因为 6位的回文也包含4位的回文， 7位的回文 也包含 5位的回文，
 * 然后我们只需要将字符串查分成 4位和5位两种，判断是否是回文即可
 *
 * 如 abcba ，拆成4位的是 ：abcb,bcba 两个，5位就只有一个 abcba
 * abcdcba ，拆成4位的是 ：abcd bcdc cdcb dcba ，5位的是 abcdc bcdcb cdcba
 * 其中 bcdcb是回文
 */
-(BOOL)isHuiwenWithStr:(NSString *)str;


@end

NS_ASSUME_NONNULL_END
