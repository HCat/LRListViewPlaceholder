//
//  SurePlaceholderView.h
//  AppPlaceholder
//
//  Created by Hcat on 2018/6/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderView : UIView
/**
 *  占位视图的Image
 */
@property (nonatomic, strong) UIImage *img_placeholder;

/**
 *  占位视图的String
 */
@property (nonatomic, copy) NSString *str_placeholder;

/**
 *  视图点击事件点击之后的block
 */
@property (nonatomic, copy) void(^reloadClickBlock)(void);

@end
