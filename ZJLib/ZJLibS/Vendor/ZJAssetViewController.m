//
//  ZJAssetViewController.m
//  ZJUtils
//
//  Created by 朱佳伟 on 15/3/13.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJAssetViewController.h"
#import "ZJAssetViewCell.h"
#import "ZJ.h"
#import "ZJAssetPickerController.h"

@interface ZJAssetViewController ()<ZJAssetViewCellDelegate>{
    int columns;
    
    float minimumInteritemSpacing;
    float minimumLineSpacing;
    
    BOOL unFirst;
}

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end

#define kThumbnailNumPerLine 4
#define kThumbnailLength    ([UIScreen mainScreen].bounds.size.width - 8) / kThumbnailNumPerLine
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)

#define kAssetViewCellIdentifier           @"AssetViewCellIdentifier"

@implementation ZJAssetViewController

- (id)init
{
    self = [super init];
    if (self) {
//        ZJAssetPickerController *vc = (ZJAssetPickerController *)self.navigationController;
//        _indexPathsForSelectedItems = [NSMutableArray arrayWithArray:vc.indexPathsForSelectedItems];
        
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            //        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 2.0, 0, 2.0);
            
            minimumInteritemSpacing = 3;
            minimumLineSpacing = 3;
            
        }
        else
        {
            //        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
            
            minimumInteritemSpacing = 2;
            minimumLineSpacing = 2;
        }
        
        if (self = [super init])
        {
            if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
                [self setEdgesForExtendedLayout:UIRectEdgeNone];
            
            //        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            //            [self setContentSizeForViewInPopover:kPopoverContentSize];
        }
        
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!unFirst) {
        columns=floor(self.view.frame.size.width/(kThumbnailSize.width + minimumInteritemSpacing));
        
        [self setupAssets];
        
        unFirst=YES;
    }
}

#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        //        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        minimumInteritemSpacing = 3;
        minimumLineSpacing = 3;
    }
    else
    {
        //        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        minimumInteritemSpacing = 2;
        minimumLineSpacing = 2;
    }
    
    columns = floor(self.view.frame.size.width/(kThumbnailSize.width+minimumInteritemSpacing));
    
    [self.tableView reloadData];
}

#pragma mark - Setup

- (void)setupViews
{
    self.tableView.backgroundColor = BackGroundColor;
}

- (void)setupButtons
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage colorImage:NavBarColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.titleTextAttributes = [ZJUIKit textAttributesWithFont:kFontDefNavTitle colorDef:kColorDefNavTitle shadowDef:kColorDefClear];
    
    //设置导航栏的leftButton
    self.navigationItem.leftBarButtonItem = [ZJUtil barBackBtnWithTarget:self action:@selector(popBackMe)];
}

//返回相册界面
- (void)popBack{
    
}

- (void)setupAssets
{
    CGFloat offset = 0;
    if (IS_IOS9) {
        offset = 64;
    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - offset) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.view.frame.size.width, 44)];
    [view setBackgroundColorWithDef:kColorF];
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [line setBackgroundColorWithDef:kColorE];
    [view addSubview:line];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IS_IOS7)
    {
        _btnOK = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 65, 6, 61, 32)];
    }
#endif
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
    }
    else
    {
        _btnOK = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 65, 6, 61, 32)];
    }
    
    //点击按钮，回到主发布页面
//    [_btnOK setBackgroundImage:[UIImage colorImage:ColorOfIndictor] forState:UIControlStateNormal];
//    [_btnOK setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)self.indexPathsForSelectedItems.count] forState:UIControlStateNormal];
    [_btnOK setTitle:@"完成" forState:UIControlStateNormal];
    _btnOK.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btnOK setTitleColor:[ZJColor colorWithDef:kColorA] forState:UIControlStateNormal];
    [_btnOK setTitleColor:[ZJColor colorWithDef:kColorE] forState:UIControlStateDisabled];
    [_btnOK addTarget:self action:@selector(finishPickingAssets) forControlEvents:UIControlEventTouchUpInside];
    
    //    [_btnView setTitle:@"预览" forState:UIControlStateNormal];
    //    [_btnView addTarget:self action:@selector(finishPickingAssets) forControlEvents:UIControlEventTouchUpInside];
    //    _btnView .titleLabel.font = [UIFont systemFontOfSize:16];
    //    [_btnView setEnabled:NO];
    [view addSubview:_btnOK];
    
//    //选择的照片数量
    _btnNumOfSelect = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 75, 12, 20, 20)];
    [_btnNumOfSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnNumOfSelect.userInteractionEnabled = NO;
    [_btnNumOfSelect setTitleForAllState:[NSString stringWithFormat:@"%ld", self.indexPathsForSelectedItems.count]];
    _btnNumOfSelect.titleLabel.font = kFontDefTitle_15;
    [_btnNumOfSelect setBackgroundColorWithDef:kColorA];
    [_btnNumOfSelect roundedViewWithRadius:10];
//    _notificationHub = [[RKNotificationHub alloc]initWithView:view];
//    [_notificationHub setCircleAtFrame:CGRectMake(self.view.frame.size.width - 80, 9.5, 25, 25)];
//    [_notificationHub setCircleColor:[ZJColor colorWithDef:kColorA] labelColor:[UIColor whiteColor]];
//    _notificationHub.countLabelFont = kFontDefTitle_17;
//    [_notificationHub setCount:self.indexPathsForSelectedItems.count];
//    [_notificationHub moveCircleByX:50 Y:12];
    if (self.indexPathsForSelectedItems.count == 0) {
        [_btnNumOfSelect setHidden:YES];
        [_btnOK setEnabled:NO];
    }else{
        [_btnNumOfSelect setHidden:NO];
        [_btnOK setEnabled:YES];
    }
    [view addSubview:_btnNumOfSelect];
    [self.view addSubview:view];
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.numberOfPhotos = 0;
    self.numberOfVideos = 0;
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            [self.assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
        }
        
        else if (self.assets.count > 0)
        {
            [self.tableView reloadData];
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ceil(self.assets.count*1.0/columns)  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - UITableView DataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == ceil(self.assets.count*1.0/columns)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor blackColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        NSString *title;
        
        if (_numberOfVideos == 0)
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片", nil), (long)_numberOfPhotos];
        else if (_numberOfPhotos == 0)
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 部视频", nil), (long)_numberOfVideos];
        else
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片, %ld 部视频", nil), (long)_numberOfPhotos, (long)_numberOfVideos];
        
        cell.textLabel.text = title;
        return cell;
    }
    
    
    NSMutableArray *tempAssets=[[NSMutableArray alloc] init];
    for (int i = 0; i < columns; i++) {
        if ((indexPath.row*columns+i)<self.assets.count) {
            [tempAssets addObject:[self.assets objectAtIndex:indexPath.row*columns+i]];
        }
    }
    
    static NSString *CellIdentifier = kAssetViewCellIdentifier;
    ZJAssetPickerController *picker = (ZJAssetPickerController *)self.navigationController;
    
    ZJAssetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZJAssetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    
    //    if (indexPath.row==ceil(self.assets.count*1.0/columns)) {
    [cell bind:tempAssets selectionFilter:picker.selectionFilter minimumInteritemSpacing:minimumInteritemSpacing minimumLineSpacing:minimumLineSpacing columns:columns assetViewX:minimumInteritemSpacing / 2];
    //    }else{
    //        [cell bind:tempAssets selectionFilter:picker.selectionFilter minimumInteritemSpacing:minimumInteritemSpacing minimumLineSpacing:minimumLineSpacing columns:columns assetViewX:(self.tableView.frame.size.width-kThumbnailSize.width*tempAssets.count-minimumInteritemSpacing*(tempAssets.count-1))/2];
    //    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceil(self.assets.count*1.0/columns)+1;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==ceil(self.assets.count*1.0/columns)) {
        return 44;
    }
    return kThumbnailSize.height+minimumLineSpacing;
}


#pragma mark - ZAssetViewCell Delegate

- (BOOL)shouldSelectAsset:(ALAsset *)asset with:(BOOL)select
{
    ZJAssetPickerController *vc = (ZJAssetPickerController *)self.navigationController;
    BOOL selectable = [vc.selectionFilter evaluateWithObject:asset];
    if (!select) {
        if (_indexPathsForSelectedItems.count >= vc.maximumNumberOfSelection) {
            if (vc.delegate !=nil && [vc.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)]) {
                [vc.delegate assetPickerControllerDidMaximum:vc];
            }
        }
    }
    
    return (selectable && _indexPathsForSelectedItems.count < vc.maximumNumberOfSelection);
}

//选择照片
- (void)didSelectAsset:(ALAsset *)asset
{
    [_indexPathsForSelectedItems addObject:asset];
    
    ZJAssetPickerController *vc = (ZJAssetPickerController *)self.navigationController;
    vc.indexPathsForSelectedItems = _indexPathsForSelectedItems;
    
    if (vc.delegate != nil && [vc.delegate respondsToSelector:@selector(assetPickerController:didSelectAsset:)])
        [vc.delegate assetPickerController:vc didSelectAsset:asset];
    
    [self setButtonEnable];
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];
//    [_notificationHub increment];
//    [_notificationHub pop];
}

//取消选中照片
- (void)didDeselectAsset:(ALAsset *)asset
{
    if (![_indexPathsForSelectedItems containsObject:asset]){
        for (ALAsset* assetO in _indexPathsForSelectedItems) {
            if ([assetO.description isEqualToString:asset.description]) {
                [_indexPathsForSelectedItems removeObject:assetO];
                break;
            }
        }
    }else{
        [_indexPathsForSelectedItems removeObject:asset];
    }
    
    ZJAssetPickerController *vc = (ZJAssetPickerController *)self.navigationController;
    vc.indexPathsForSelectedItems = _indexPathsForSelectedItems;
    
    if (vc.delegate!=nil&&[vc.delegate respondsToSelector:@selector(assetPickerController:didDeselectAsset:)])
        [vc.delegate assetPickerController:vc didDeselectAsset:asset];
    
    [self setButtonEnable];
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];
//    [_notificationHub decrement];
}

//设置完成按钮状态
- (void)setButtonEnable{
    if (_indexPathsForSelectedItems.count > 0) {
        [_btnOK setEnabled:YES];
    }else{
        [_btnOK setEnabled:NO];
    }
}
#pragma mark - Title

- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count > 0) {
        [_btnNumOfSelect setHidden:NO];
        [_btnNumOfSelect setTitle:[NSString stringWithFormat:@"%ld", indexPaths.count] forState:UIControlStateNormal];
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
        anim.fromValue = [NSValue valueWithCGSize:CGSizeMake(10, 10)];
        anim.toValue = [NSValue valueWithCGSize:CGSizeMake(20, 20)];
        anim.springBounciness = 10;
        anim.springSpeed = 8;
        [_btnNumOfSelect pop_addAnimation:anim forKey:@"selectPhotoAnimation"];
    }else{
        [_btnNumOfSelect setHidden:YES];
    }
//    [_btnOK setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)indexPaths.count] forState:UIControlStateNormal];
    //    self.title = @"相机胶卷";
    //    // Reset title to group name
    //    if (indexPaths.count == 0)
    //    {
    //        // self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    //        self.title = @"相机胶卷";
    //        return;
    //    }
    
    //    BOOL photosSelected = NO;
    //    BOOL videoSelected  = NO;
    //
    //    for (int i=0; i<indexPaths.count; i++) {
    //        ALAsset *asset = indexPaths[i];
    //
    //        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
    //            photosSelected  = YES;
    //
    //        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    //            videoSelected   = YES;
    //
    //        if (photosSelected && videoSelected)
    //            break;
    //
    //    }
    //
    //    NSString *format;
    //
    //    if (photosSelected && videoSelected)
    //        format = NSLocalizedString(@"已选择 %ld 个项目", nil);
    //
    //    else if (photosSelected)
    //        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 张照片", nil) : NSLocalizedString(@"已选择 %ld 张照片 ", nil);
    //
    //
    //    else if (videoSelected)
    //        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 部视频", nil) : NSLocalizedString(@"已选择 %ld 部视频 ", nil);
    
    //self.title = [NSString stringWithFormat:format, (long)indexPaths.count];
}


#pragma mark - Actions

- (void)finishPickingAssets
{
    ZJAssetPickerController *picker = (ZJAssetPickerController *)self.navigationController;
    
    if (_indexPathsForSelectedItems.count < picker.minimumNumberOfSelection) {
        if (picker.delegate != nil && [picker.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)]) {
            [picker.delegate assetPickerControllerDidMaximum:picker];
        }
    }
    
    if ([picker.delegate respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)])
        [picker.delegate assetPickerController:picker didFinishPickingAssets:_indexPathsForSelectedItems];
    
    //    if (picker.isFinishDismissViewController) {
    //        [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    //    }
}

@end