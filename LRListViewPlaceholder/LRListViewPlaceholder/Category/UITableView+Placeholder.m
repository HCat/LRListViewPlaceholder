//
//  UITableView+Placeholder.m
//  LRListViewPlaceholder
//
//  Created by hcat on 2018/6/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "UITableView+Placeholder.h"
#import "NSObject+Swizzling.h"
#import "PlaceholderView.h"
#import "NetWorkHelper.h"


@implementation UITableView (Placeholder)

#pragma mark - methods swizzing

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //有网络状态但是没有数据的状态下
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData) bySwizzledSelector:@selector(lr_reloadData)];
        
    });
}

-(void)lr_reloadData{
    
    if (self.isNotHavePlaceholder == YES) {
        //不需要被methods swizzing
        [self lr_reloadData];
        return;
    }
    
    
    if ([NetWorkHelper shareInstance].currentNetworkStatus == NotReachable ) {
        [self displayNotNetworkStatus];
        
        [self lr_reloadData];
        return;
    }
    
    [self displayNoDataStatus];
    [self lr_reloadData];
}

- (void)displayNotNetworkStatus{
    
    if (self.isNotFirstReload) {
        if (!self.v_notNetwork) {
            [self makeDefaultNotNetworkView];
        }
        if (self.v_notData) {
            [self.v_notData setHidden:YES];
            [self.v_notData removeFromSuperview];
        }
        
        self.v_notNetwork.hidden = NO;
        [self addSubview:self.v_notNetwork];
    }
    self.isNotFirstReload = YES;
}

- (void)displayNoDataStatus{
    
    if (self.isNotFirstReload) {
        if (!self.v_notData) {
            [self makeDefaultNoDataView];
        }
        
        if (self.v_notNetwork) {
            [self.v_notNetwork setHidden:YES];
            [self.v_notNetwork removeFromSuperview];
        }
        
        [self checkEmpty];
    }
    
    self.isNotFirstReload = YES;
   
}

#pragma mark - checkEmpty

- (void)checkEmpty{
    
    BOOL isEmpty = YES;
    
    id<UITableViewDataSource>dataSource = self.dataSource;
    id<UITableViewDelegate>delegate = self.delegate;
    NSInteger sections = 1;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        
        sections = [dataSource numberOfSectionsInTableView:self]-1;
    }
    
    for (NSInteger i = 0; i <= sections; i++) {
        
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i];
        //不能仅仅考虑numberofrows==0;还得考虑section!=0;rows==0;有sectionheader的时候
        UIView *sectionHeaderView = nil;
        if ([delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
            sectionHeaderView = [delegate tableView:self viewForHeaderInSection:i];
        }
        if (rows||sectionHeaderView) {
            
            isEmpty = NO;
        }
    }
    if (isEmpty) {
        //为空，添加占位图
        self.v_notData.hidden = NO;
        [self addSubview:self.v_notData];
        
    }else{
        //不为空，移除占位图
        self.v_notData.hidden = YES;
        [self.v_notData removeFromSuperview];
    }
    
}

#pragma mark - 配置默认占位视图

- (void)makeDefaultNotNetworkView{
    
    PlaceholderView *placeholderView = [[PlaceholderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    placeholderView.img_placeholder = [UIImage imageNamed:@"icon_tablePlaceholder_error"];
    placeholderView.str_placeholder = @"网络异常,点击重载";
    
    __weak typeof(self) weakSelf = self;
    [placeholderView setReloadClickBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.reloadBlock) {
            strongSelf.reloadBlock();
        }
    }];
    
    self.v_notNetwork = placeholderView;
    
}

- (void)makeDefaultNoDataView{
    
    PlaceholderView *placeholderView = [[PlaceholderView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    placeholderView.img_placeholder = [UIImage imageNamed:@"icon_tablePlaceholder_null"];
    placeholderView.str_placeholder = @"暂无内容";
    
    self.v_notData = placeholderView;
    
}
#pragma mark - set&&get
- (void)setIsNotHavePlaceholder:(BOOL)isNotHavePlaceholder{
    objc_setAssociatedObject(self, @selector(isNotHavePlaceholder), @(isNotHavePlaceholder), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isNotHavePlaceholder{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (BOOL)isNotFirstReload {
    return [objc_getAssociatedObject(self, @selector(isNotFirstReload)) boolValue];
}
- (void)setIsNotFirstReload:(BOOL)isNotFirstReload {
    objc_setAssociatedObject(self, @selector(isNotFirstReload), @(isNotFirstReload), OBJC_ASSOCIATION_ASSIGN);
}


- (UIView *)v_notNetwork {
    return objc_getAssociatedObject(self, @selector(v_notNetwork));
}
- (void)setV_notNetwork:(UIView *)v_notNetwork {
    objc_setAssociatedObject(self, @selector(v_notNetwork), v_notNetwork, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIView *)v_notData {
    return objc_getAssociatedObject(self, @selector(v_notData));
}
- (void)setV_notData:(UIView *)v_notData {
    objc_setAssociatedObject(self, @selector(v_notData), v_notData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void (^)(void))reloadBlock {
    return objc_getAssociatedObject(self, @selector(reloadBlock));
}

- (void)setReloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, @selector(reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
