//
//  SLScreenEdgePanGestureRecognizer.m
//  SLSlideMenu
//
//  Created by Mac－pro on 17/3/16.
//  Copyright © 2017年 Songlazy. All rights reserved.
//

#import "SLScreenEdgePanGestureRecognizer.h"

@implementation SLScreenEdgePanGestureRecognizer

- (void)setUserInfos:(NSDictionary *)userInfo {
    _userInfo = userInfo;
}

- (NSDictionary *)userInfo {
    return _userInfo;
}

@end
