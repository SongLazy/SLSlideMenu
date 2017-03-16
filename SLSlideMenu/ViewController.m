//
//  ViewController.m
//  SLSlideMenu
//
//  Created by Mac－pro on 17/3/14.
//  Copyright © 2017年 Pandai. All rights reserved.
//

#import "ViewController.h"
#import "SLSlideMenu.h"

@interface ViewController () <SLSlideMenuProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SLSlideMenu prepareSlideMenuWithFrame:self.view.frame delegate:self direction:SLSlideMenuSwipeDirectionLeft slideOffset:300 allowSlideMenuSwipeShow:YES allowSwipeCloseMenu:YES aboveNav:YES identifier:@"swipeLeft"];
    [SLSlideMenu prepareSlideMenuWithFrame:self.view.frame delegate:self direction:SLSlideMenuSwipeDirectionRight slideOffset:300 allowSlideMenuSwipeShow:YES allowSwipeCloseMenu:YES aboveNav:YES identifier:@"swipeRight"];
    
}

- (IBAction)topClick:(id)sender {
    NSLog(@"topClick");

    [SLSlideMenu slideMenuWithFrame:CGRectMake(0, 64, screenW, screenH) delegate:self direction:SLSlideMenuDirectionTop slideOffset:400 allowSwipeCloseMenu:YES aboveNav:NO identifier:@"top"];
}

- (IBAction)bottomClick:(id)sender {
    NSLog(@"bottomClick");

    [SLSlideMenu slideMenuWithFrame:self.view.frame delegate:self direction:SLSlideMenuDirectionBottom slideOffset:400 allowSwipeCloseMenu:YES aboveNav:YES identifier:@"bottom"];
}

- (IBAction)rightClick:(id)sender {
    NSLog(@"rightClick");

    [SLSlideMenu slideMenuWithFrame:CGRectMake(0, 64, screenW, screenH) delegate:self direction:SLSlideMenuDirectionRight slideOffset:250 allowSwipeCloseMenu:YES aboveNav:NO identifier:@"right"];
}

- (IBAction)leftClick:(id)sender {
    NSLog(@"leftClick");
    
    [SLSlideMenu slideMenuWithFrame:self.view.frame delegate:self direction:SLSlideMenuDirectionLeft slideOffset:250 allowSwipeCloseMenu:YES aboveNav:YES identifier:@"left"];
}

- (IBAction)menuBtnClick:(id)sender {
    
    NSLog(@"menuBtnClick");

    [SLSlideMenu slideMenuWithFrame:self.view.frame delegate:self direction:SLSlideMenuDirectionRight slideOffset:250 allowSwipeCloseMenu:YES aboveNav:YES identifier:@"right1"];
}

- (void)slideMenu:(SLSlideMenu *)slideMenu prepareSubviewsForMenuView:(UIView *)menuView {
    NSLog(@"identifier:%@",slideMenu.identifier);
    // ** 如果一个方向只有一个弹窗可根据direction区分
    if (slideMenu.direction == SLSlideMenuDirectionTop) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 30)];
        lb.text = @"自定义控件1";
        lb.font = [UIFont systemFontOfSize:12];
        lb.textColor = [UIColor darkGrayColor];
        [menuView addSubview:lb];
        
    }
    
    if (slideMenu.direction == SLSlideMenuDirectionRight) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 30)];
        lb.text = @"自定义控件1";
        lb.font = [UIFont systemFontOfSize:12];
        lb.textColor = [UIColor darkGrayColor];
        [menuView addSubview:lb];
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 100, 30)];
        lb1.text = @"自定义控件2";
        lb1.font = [UIFont systemFontOfSize:12];
        lb1.textColor = [UIColor darkGrayColor];
        [menuView addSubview:lb1];
    }
    
    if (slideMenu.direction == SLSlideMenuDirectionLeft) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 30)];
        lb.text = @"自定义控件1";
        lb.font = [UIFont systemFontOfSize:12];
        lb.textColor = [UIColor darkGrayColor];
        [menuView addSubview:lb];
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 100, 30)];
        lb1.text = @"自定义控件2";
        lb1.font = [UIFont systemFontOfSize:12];
        lb1.textColor = [UIColor darkGrayColor];
        [menuView addSubview:lb1];
        
        UISearchBar *searcBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 200, 200, 50)];
        [menuView addSubview:searcBar];
        
        searcBar.barTintColor = [UIColor whiteColor];
        UIView *searchTextField = [[[searcBar.subviews firstObject] subviews] lastObject];
        searchTextField.backgroundColor = [UIColor yellowColor];
    }
    
    if (slideMenu.direction == SLSlideMenuDirectionBottom) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(70, 200, 100, 40)];
        btn.backgroundColor = [UIColor purpleColor];
        [btn addTarget:self  action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn];
    }
    
    
    // ** 如果一个方向有多个弹窗，可设置identifier来区分
    if ([slideMenu.identifier isEqualToString:@"right"]) {
        menuView.backgroundColor = [UIColor yellowColor];
    }
    if ([slideMenu.identifier isEqualToString:@"right1"]) {
        menuView.backgroundColor = [UIColor greenColor];
    }
    if ([slideMenu.identifier isEqualToString:@"swipeRight"]) {
        menuView.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)btnClick {
    NSLog(@"btnClick");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
