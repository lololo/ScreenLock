//
//  GLLockManager.m
//  Lock
//
//  Created by Lei on 11/18/13.
//  Copyright (c) 2013 Lei. All rights reserved.
//

#import "GLLockManager.h"
#import "GLLockView.h"
#import "GLDatabase.h"

typedef enum{
    kLockModeNone,
    kLockModeSet,
    kLockModeEnter,
    kLockModeReset
} kLockMode;

 NSString *const filename = @"info";

@interface GLLockManager()<
GLLockViewDelegate,
NSCoding
>
{
    // 需要输入密码的次数
    NSInteger needEnterTime;
    
    //
    BOOL isSetNewPassword;
}
@property (nonatomic, strong) NSString *sPassWd;
@property (nonatomic, strong) GLLockView *lockView;
@property kLockMode mode;
@end

@implementation GLLockManager

static GLLockManager *share;

+ (GLLockManager *)Share
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        share = loadData(filename);
        if (!share) {
            share = [[self alloc] init];
        }
    });
    return share;
}

- (id)init
{
    self = [super init];
    if (self) {
        //self.sPassWd = @"038";
        isSetNewPassword = NO;
    }
    return self;
}
- (void)showLockView
{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    GLLockView *vLock = [[GLLockView alloc] initWithFrame:window.bounds];
    [vLock setDelegate:self];
    [window addSubview:vLock];
    self.lockView = vLock;
}

- (void)hiddenLockView
{
    if (_lockView) {
        [_lockView removeFromSuperview];
        _lockView = nil;
    }
}


- (void)setPassword
{
    needEnterTime = 2;
    self.mode = kLockModeSet;
    [self showLockView];
    self.lockView.displayTextLabe.text = @"请设置密码";
}

- (void)setPasswordFinish
{
    [self hiddenLockView];
}

- (void)enterPasswd
{
    self.mode = kLockModeEnter;
    [self showLockView];
    self.lockView.displayTextLabe.text = @"请输入密码";
}

- (void)enterpasswdFinsih:(BOOL)success
{
    if (success) {
        [self hiddenLockView];
    }
}

- (void)ResetPasswd
{
    self.mode = kLockModeReset;
    needEnterTime = 3;
    [self showLockView];
    self.lockView.displayTextLabe.text = @"请输入原密码";
}

- (void)save
{
    saveData(self, filename);
}

- (void)lock
{
   if (self.sPassWd)
   {
       [self enterPasswd];
   }
   else{
       [self setPassword];
   }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sPassWd forKey:@"Password"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.sPassWd = [aDecoder decodeObjectForKey:@"Password"];
    }
    return self;
}

#pragma mark - Lock View Delegate

- (void)lockViewResult:(NSString *)result
{
    if (!result) {
        return;
    }
    switch (self.mode) {
        case kLockModeNone:
            break;
        case kLockModeSet:
        {
            if (needEnterTime == 2) {
                self.lockView.displayTextLabe.text = @"请再次输入密码";
                self.sPassWd = result;
                needEnterTime--;
            }
            else if (needEnterTime == 1) {
                if ([self.sPassWd isEqualToString:result]) {
                    self.lockView.displayTextLabe.text = @"密码设置完成";
                    [self save];
                    [self setPasswordFinish];
                    needEnterTime--;
                }
                else {
                    self.lockView.displayTextLabe.text = @"两次输入密码不符，重新输入";
                    needEnterTime = 2;
                    self.sPassWd = nil;
                }
            }
            break;
        }
        case kLockModeEnter:
        {
            if ([self.sPassWd isEqualToString:result]) {
                [self enterpasswdFinsih:YES];
            }
            else {
                [self enterpasswdFinsih:NO];
                self.lockView.displayTextLabe.text = @"输入错误,重新输入";
            }
            break;
        }
        case kLockModeReset:
        {
            
            if (needEnterTime == 3) {
                if ([self.sPassWd isEqualToString:result]) {
                    self.lockView.displayTextLabe.text = @"请输入新密码";
                    needEnterTime--;
                    self.mode = kLockModeSet;
                }
                else {
                    
                }
            }
            
            break;
        }
        default:
            break;
    }
    
}

@end
