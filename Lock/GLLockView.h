//
//  GLLockView.h
//  Lock
//
//  Created by Lei on 11/16/13.
//  Copyright (c) 2013 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLLockViewDelegate <NSObject>

- (void)lockViewResult:(NSString *)result;

@end

@interface GLLockView : UIView

@property (nonatomic , weak) id<GLLockViewDelegate> delegate;

@property (nonatomic, strong) UILabel *displayTextLabe;

@end
