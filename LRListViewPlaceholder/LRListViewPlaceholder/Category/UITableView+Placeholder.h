//
//  UITableView+Placeholder.h
//  LRListViewPlaceholder
//
//  Created by hcat on 2018/6/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(Placeholder)

/**
 *  isNotFirstReload属性用于解决第一次加载的时候系统自动调用一次reloadData的问题。
 *  默认NO, 默认不用配置,第一次加载之后自动设置为YES.
 */
@property (nonatomic, assign) BOOL isNotFirstReload;

/**
 *  用于配置是否需要占位图，默认NO,表示需要占位图
 */
@property (nonatomic, assign) BOOL isNotHavePlaceholder;

/**
 *  用于外部设置无数据占位图,如果没有设置，则使用默认无数据占位图
 */
@property (nonatomic, strong) UIView *v_notData;

/**
 *  用于外部设置无网络占位图,如果没有设置，则使用默认无网络占位图
 */
@property (nonatomic, strong) UIView *v_notNetwork;

/**
 *  用于无网络占位图时点击重载数据
 */
@property (nonatomic, copy)   void (^reloadBlock)(void);


@end
