//
//  ATSwipableTableViewCell.h
//  Animetick
//
//  Created by yayugu on 2013/10/20.
//  Copyright (c) 2013年 yayugu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 90

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

@class ATSwipableTableViewCell;

@protocol SWTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(ATSwipableTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
@end

@interface ATSwipableTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *rightUtilityButtons;
@property (nonatomic) id <SWTableViewCellDelegate> delegate;

// Views that live in the scroll view
@property (nonatomic, weak) UIView *scrollViewContentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;
- (void)showRightUtilityButtonsAnimated:(BOOL)animated;

@end
