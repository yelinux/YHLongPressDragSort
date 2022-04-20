//
//  YHViewController.m
//  YHLongPressDragSort
//
//  Created by ye_linux@126.com on 04/20/2022.
//  Copyright (c) 2022 ye_linux@126.com. All rights reserved.
//

#import "YHViewController.h"
#import "YHLongPressDragSortVC.h"
#import "YHNestLongPressDragSortVC.h"
#import "YHCollectionDemoVC.h"
#import "YHTableViewDemoVC.h"

@interface YHViewController ()

@end

@implementation YHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)click0:(id)sender {
    YHLongPressDragSortVC *vc = [[YHLongPressDragSortVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)click1:(id)sender {
    YHNestLongPressDragSortVC *vc = [[YHNestLongPressDragSortVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)click2:(id)sender {
    YHCollectionDemoVC *vc = [[YHCollectionDemoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)click3:(id)sender {
    YHTableViewDemoVC *vc = [[YHTableViewDemoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
