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

- (void)setPassword;

- (void)enterPasswd;

- (void)ResetPasswd;

- (void)save;

- (void)lock;


@end
