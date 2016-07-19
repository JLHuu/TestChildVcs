//
//  ParentViewController.m
//  TestChildVcs
//
//  Created by knmk0002 on 16/7/19.
//  Copyright © 2016年 knmk0002. All rights reserved.
//

#import "ParentViewController.h"
#import "FViewController.h"
#import "SViewController.h"
#import "TViewController.h"
@interface ParentViewController ()
@property(nonatomic,strong)UISegmentedControl *control;
@property(nonatomic,strong)FViewController *fvc;
@property(nonatomic,strong)SViewController *svc;
@property(nonatomic,strong)TViewController *tvc;
@property(nonatomic,strong)BaseViewController *currentvc;// 当前子视图vc
@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _control = [[UISegmentedControl alloc] initWithItems:@[@"FVC",@"SVC",@"TVC"]];
    _control.backgroundColor = [UIColor grayColor];
    _control.frame = CGRectMake((CGRectGetWidth(self.view.frame)-150)/2, 30, 150, 30);
    [_control addTarget:self action:@selector(ChangedSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_control];
    [_control setSelectedSegmentIndex:0];//默认第一个
    _fvc = [[FViewController alloc] init];
    [_fvc.view setFrame:self.view.bounds];
    _svc = [[SViewController alloc] init];
    _tvc = [[TViewController alloc] init];
    [self addChildViewController:_fvc];// 默认是第一个vc
    [self.view addSubview:_fvc.view];
    _currentvc = _fvc;
    [self.view bringSubviewToFront:_control];
}
- (void)ChangedSegment:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0 && _currentvc != _fvc) {
        [self transitionVC:_currentvc toVC:_fvc];
    }
    if (sender.selectedSegmentIndex == 1 && _currentvc != _svc) {
        [self transitionVC:_currentvc toVC:_svc];
    }
    if (sender.selectedSegmentIndex == 2 && _currentvc != _tvc) {
        [self transitionVC:_currentvc toVC:_tvc];
    }
}

- (void)transitionVC:(BaseViewController *)currentvc toVC:(BaseViewController *)newvc
{
    // 加入子视图vc才可交换
    [self addChildViewController:newvc];
    // 子视图vc交换
    [self transitionFromViewController:currentvc toViewController:newvc duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:^(BOOL finished) {
        if (finished) {//交换完成
            // 移除老的vc推出新的vc
            [newvc didMoveToParentViewController:self];
            [currentvc willMoveToParentViewController:nil];
            [currentvc removeFromParentViewController];
            self.currentvc = newvc;
        }else{// 交换失败
            // 移除newvc
            self.currentvc = currentvc;
            [newvc willMoveToParentViewController:nil];
            [newvc removeFromParentViewController];
        }
    }];
    [self.view bringSubviewToFront:_control];
}

@end
