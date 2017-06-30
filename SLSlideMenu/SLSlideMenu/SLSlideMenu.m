//
//  SLSlideMenu.m
//  SLSlideMenu
//
//  Created by Mac－pro on 17/3/14.
//  Copyright © 2017年 Songlazy All rights reserved.
//

#import "SLSlideMenu.h"
#import "SLScreenEdgePanGestureRecognizer.h"


#define menuW self.frame.size.width
#define menuH self.frame.size.height
#define navH  64
#define animationTime 0.25

@interface SLSlideMenu()

@property (nonatomic, strong) UIButton *shadowView;
@property (nonatomic, strong) UIView *menuView;


@property (nonatomic, assign) CGFloat slideOffset;

@property (nonatomic, strong) NSMutableArray *x_arr;
@property (nonatomic, strong) NSMutableArray *y_arr;


@property (nonatomic, assign) CGFloat startX;
@property (nonatomic, assign) CGFloat startY;

@property (nonatomic, strong) NSMutableArray *startX_arr;
@property (nonatomic, strong) NSMutableArray *startY_arr;


@property (nonatomic, assign) CGFloat shadowY;

@end

@implementation SLSlideMenu

+ (void)dismiss {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissSLSLideMenu" object:nil];
}

+ (void)slideMenuWithFrame:(CGRect)frame delegate:(id)delegate direction:(SLSlideMenuDirection)direction slideOffset:(CGFloat)slideOffset allowSwipeCloseMenu:(BOOL)isAllow aboveNav:(BOOL)isAbove identifier:(NSString *)identifier object:(id)object{
    
    SLSlideMenu *menu = [[SLSlideMenu alloc] initWithFrame:frame delegate:(id)delegate direction:direction slideOffset:slideOffset allowSwipeCloseMenu:isAllow aboveNav:(BOOL)isAbove identifier:identifier object:object];
    [[menu getCurrentView] addSubview:menu];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate direction:(SLSlideMenuDirection)direction slideOffset:(CGFloat)slideOffset allowSwipeCloseMenu:(BOOL)isAllow aboveNav:(BOOL)isAbove identifier:(NSString *)identifier object:(id)object {
    self = [super initWithFrame:frame];
    if (self) {
        
        _direction = direction;
        _delegate = delegate;
        _identifier = identifier;
        _x_arr = [NSMutableArray array];
        _y_arr = [NSMutableArray array];
        _startX_arr =  [NSMutableArray array];
        _startY_arr =  [NSMutableArray array];
        _object = object;
        
        CGFloat shadowY;
        if (isAbove) {
            shadowY = 0;
        } else {
            shadowY = navH;
        }
        
        UIButton *shadowView = [[UIButton alloc] initWithFrame:CGRectMake(0, shadowY, screenW, screenH)];
        shadowView.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.0];
        [[UIApplication sharedApplication].keyWindow addSubview:shadowView];
        [shadowView addTarget:self action:@selector(shadowViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
        self.shadowView = shadowView;
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = 0;
        CGFloat h = 0;
        switch (direction) {
            case SLSlideMenuDirectionRight:
                x = menuW;
                h = menuH;
                break;
            case SLSlideMenuDirectionLeft:
                h = menuH;
                break;
            case SLSlideMenuDirectionBottom:
                y = menuH;
                w = menuW;
                break;
            case SLSlideMenuDirectionTop:
                w = menuW;
                break;
            default:
                break;
        }
        
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        menuView.backgroundColor = [UIColor whiteColor];
        self.menuView = menuView;
        [shadowView addSubview:menuView];
        
        if ([self.delegate respondsToSelector:@selector(slideMenu:prepareSubviewsForMenuView:)]) {
            [self.delegate slideMenu:self prepareSubviewsForMenuView:menuView];
        }

        // 添加手势
        if (isAllow) {
            [self addGestureRecognizerForMenuView:menuView direction:direction];
        }
        
        // 动画显示menu
        [self showMenuViewWithDirection:direction slideOffset:slideOffset shadowY:(CGFloat)shadowY];

    }
    
    return self;
}

+ (void)prepareSlideMenuWithFrame:(CGRect)frame delegate:(id)delegate direction:(SLSlideMenuSwipeDirection)direction slideOffset:(CGFloat)slideOffset allowSlideMenuSwipeShow:(BOOL)isAllowSwipeShow allowSwipeCloseMenu:(BOOL)isAllowSwipeCloseMenu aboveNav:(BOOL)isAbove identifier:(NSString *)identifier object:(id)object{
    if (isAllowSwipeShow) {

        SLScreenEdgePanGestureRecognizer* screenEdgePan = [[SLScreenEdgePanGestureRecognizer alloc] init];
        screenEdgePan.userInfo = @{@"frame":NSStringFromCGRect(frame),
                                   @"delegate":delegate,
                                   @"direction":@(direction),
                                   @"slideOffset":@(slideOffset),
                                   @"isAllowSwipeCloseMenu":@(isAllowSwipeCloseMenu),
                                   @"isAbove":@(isAbove),
                                   @"identifier":identifier};
        [screenEdgePan addTarget:self action:@selector(screenEdgePanAction:)];
        switch (direction) {
            case SLSlideMenuSwipeDirectionLeft:
                screenEdgePan.edges = UIRectEdgeLeft;
                break;
            case SLSlideMenuSwipeDirectionRight:
                screenEdgePan.edges = UIRectEdgeRight;
                break;
            default:
                break;
        }
        
        [[SLSlideMenu getCurrentVc].view addGestureRecognizer:screenEdgePan];
    } else {
        
    }
}

+ (void)screenEdgePanAction:(SLScreenEdgePanGestureRecognizer *)sender {
    if (sender.edges == UIRectEdgeLeft || sender.edges == UIRectEdgeRight) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            NSLog(@"手势开始");
            [SLSlideMenu slideMenuWithFrame:CGRectFromString(sender.userInfo[@"frame"]) delegate:sender.userInfo[@"delegate"] direction:[sender.userInfo[@"direction"] integerValue] slideOffset:[sender.userInfo[@"slideOffset"] floatValue] allowSwipeCloseMenu:[sender.userInfo[@"allowSwipeCloseMenu"] boolValue] aboveNav:[sender.userInfo[@"isAbove"] boolValue] identifier:sender.userInfo[@"identifier"] object:sender.userInfo[@"object"]];
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            NSLog(@"手势进行中");
        } else {
            NSLog(@"手势结束");
        }
    }
}

- (void)showMenuViewWithDirection:(SLSlideMenuDirection)direction slideOffset:(CGFloat)slideOffset shadowY:(CGFloat)shadowY {
    _shadowY = shadowY;
    CGRect frame = self.menuView.frame;
    
    if (direction == SLSlideMenuDirectionRight) {
        
        frame.origin.x = menuW - slideOffset;
        frame.size.width = slideOffset;
        
    } else if (direction == SLSlideMenuDirectionLeft) {
        
        frame.size.width = slideOffset;
        [self.menuView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect subFrame = obj.frame;
            [_x_arr addObject:@(subFrame.origin.x)];
            CGFloat x_temp = [[_x_arr objectAtIndex:idx] floatValue];
            // 距离右边的距离
            CGFloat l = frame.size.width - x_temp - subFrame.size.width;
            subFrame.origin.x =  0 - l - subFrame.size.width;
            [_startX_arr addObject:@(subFrame.origin.x)];
            obj.frame = subFrame;
        }];
        
    } else if (direction == SLSlideMenuDirectionBottom) {
        
        frame.origin.y = menuH - slideOffset;
        frame.size.height = slideOffset;
        
    } else { // top
        
        frame.size.height = slideOffset;
        [self.menuView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect subFrame = obj.frame;
            [_y_arr addObject:@(subFrame.origin.y)];
            CGFloat y_temp = [[_y_arr objectAtIndex:idx] floatValue];
            // 距离上边的距离
            CGFloat l = frame.size.width - y_temp - subFrame.size.width;
            subFrame.origin.y =  0 - l - subFrame.size.width;
            [_startY_arr addObject:@(subFrame.origin.y)];
            obj.frame = subFrame;
        }];
        
    }
    
    [UIView animateWithDuration:animationTime animations:^{
        
        self.menuView.frame = frame;
        
        if (direction == SLSlideMenuDirectionLeft) {
            [self.menuView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect subFrame = obj.frame;
                subFrame.origin.x = [[_x_arr objectAtIndex:idx] floatValue];
                obj.frame = subFrame;
            }];
        }
        
        if (direction == SLSlideMenuDirectionTop) {
            [self.menuView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect subFrame = obj.frame;
                subFrame.origin.y = [[_y_arr objectAtIndex:idx] floatValue];
                obj.frame = subFrame;
            }];
        }
        
        self.shadowView.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.4];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissNoti) name:@"dismissSLSLideMenu" object:nil];
}

- (void)dismissNoti {
    [self shadowViewDidClick:nil];
}

- (void)shadowViewDidClick:(UIButton *)sender {
    
    
    
    CGRect frame = self.menuView.frame;
    
    switch (self.direction) {
        case SLSlideMenuDirectionRight:
            frame.origin.x = menuW;
            frame.size.width = 0;
            break;
        case SLSlideMenuDirectionLeft:
            frame.size.width = 0;
            break;
        case SLSlideMenuDirectionBottom:
            frame.origin.y = menuH ;
            frame.size.height = 0;
            break;
        case SLSlideMenuDirectionTop:
            frame.size.height = 0;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:animationTime animations:^{
        self.menuView.frame = frame;
        if (self.direction == SLSlideMenuDirectionLeft) {

            [self.menuView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect subFrame = obj.frame;
                subFrame.origin.x = [[_startX_arr objectAtIndex:idx] floatValue];
                obj.frame = subFrame;
            }];
        }
        
        if (self.direction == SLSlideMenuDirectionTop) {
            [self.menuView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect subFrame = obj.frame;
                subFrame.origin.y = [[_startY_arr objectAtIndex:idx] floatValue];
                obj.frame = subFrame;
            }];
        }
        
        self.shadowView.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.shadowView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissSLSLideMenu" object:nil];
    }];
}

- (void)addGestureRecognizerForMenuView:(UIView *)menuView direction:(SLSlideMenuDirection)direction {
    UISwipeGestureRecognizer * recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(shadowViewDidClick:)];
    
    UISwipeGestureRecognizerDirection gestureRecognizerDirection;
    
    switch (direction) {
        case SLSlideMenuDirectionRight:
            gestureRecognizerDirection = UISwipeGestureRecognizerDirectionRight;
            break;
        case SLSlideMenuDirectionLeft:
            gestureRecognizerDirection = UISwipeGestureRecognizerDirectionLeft;
            break;
        case SLSlideMenuDirectionBottom:
            gestureRecognizerDirection = UISwipeGestureRecognizerDirectionDown;
            break;
        case SLSlideMenuDirectionTop:
            gestureRecognizerDirection = UISwipeGestureRecognizerDirectionUp;
            break;
        default:
            break;
    }
    
    [recognizer setDirection:(gestureRecognizerDirection)];
    [menuView addGestureRecognizer:recognizer];
}

// 获取当前控制器的view
- (UIView *)getCurrentView {
    return [self getCurrentVC].view;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (UIViewController *)getCurrentVc
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
