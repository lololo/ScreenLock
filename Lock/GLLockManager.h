//
//  GLLockManager.h
//  Lock
//
//  Created by Lei on 11/18/13.
//  Copyright (c) 2013 Lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLLockManager : NSObject
+ (GLLockManager *)Share;
//- (void)showLockView;

/*! 设置密码 */
- (void)setPassword;

/*! 输入密码 */
- (void)enterPasswd;

/*! 重设密码 */
- (void)ResetPasswd;

- (void)save;

- (void)lock;
@end
