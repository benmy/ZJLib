//
//  ZJBaseViewController.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/12.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJBaseViewController.h"
#import "ARCMacros.h"

@interface ZJBaseViewController ()

@property (nonatomic, SAFE_ARC_STRONG) UIView *viewResignInputResponder;
@property (nonatomic, SAFE_ARC_STRONG) NSMutableArray *inputResponders;

- (void)addInputResponder:(UIResponder *)aResponder;
- (void)removeInputResponder:(UIResponder *)aResponder;
- (NSMutableArray *)inputResponders;

@end

@implementation ZJBaseViewController
@synthesize inputResponders = _inputResponders;
@synthesize viewResignInputResponder = _viewResignInputResponder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self removeAllInputResponders];
    SAFE_ARC_RELEASE(_inputResponders);
    SAFE_ARC_RELEASE(_viewResignInputResponder);
    
    SAFE_ARC_SUPER_DEALLOC();
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    {
        self.viewResignInputResponder = [[UIView alloc] initWithFrame:self.view.frame];
        [_viewResignInputResponder setTop:0];
        self.viewResignInputResponder.userInteractionEnabled = YES;
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAllInputResponders)];
        [self.viewResignInputResponder addGestureRecognizer:gr];
        [self.view insertSubview:_viewResignInputResponder atIndex:0];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear:%s", object_getClassName(self));
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear:%s", object_getClassName(self));
    
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeAllInputResponders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)removeAllInputResponders
{
    if (_inputResponders != nil)
    {
        NSMutableArray *ret = [NSMutableArray array];
        for (UIResponder *ir in _inputResponders)
        {
            [ret addObject:ir];
        }
        
        for (UIResponder *ir in ret)
        {
            [ir resignFirstResponder];
        }
        
        [_inputResponders removeAllObjects];
        _viewResignInputResponder.userInteractionEnabled = NO;
    }
}

- (void)addInputResponder:(UIResponder *)aResponder
{
    if (_inputResponders == nil)
    {
        self.inputResponders = [NSMutableArray array];
    }
    [_inputResponders addObject:aResponder];
    _viewResignInputResponder.userInteractionEnabled = YES;
}

- (void)removeInputResponder:(UIResponder *)aResponder
{
    if (_inputResponders != nil)
    {
        [aResponder resignFirstResponder];
        [_inputResponders removeObject:aResponder];
        if (_inputResponders.count == 0)
        {
            _viewResignInputResponder.userInteractionEnabled = NO;
        }
    }
}

- (NSMutableArray *)inputResponders
{
    if (_inputResponders == nil)
    {
        self.inputResponders = [NSMutableArray array];
    }
    return _inputResponders;
}

@end
