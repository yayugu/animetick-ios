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

typedef enum {
    kCellStateCenter,
    kCellStateRight
} SWCellState;

@class ATSwipableTableViewCell;

@protocol SWTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(ATSwipableTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
@end

@interface ATSwipableTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *rightUtilityButtons;
@property (nonatomic) id <SWTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;
- (void)showRightUtilityButtonsAnimated:(BOOL)animated;

@end

@interface NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;

@end
