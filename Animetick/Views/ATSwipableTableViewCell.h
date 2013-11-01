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
- (void)animateToDisappearContentViewCompletion:(void (^)(BOOL finished))completion;



// 一時的にこっちに
@property (nonatomic, weak) UIView *cellView;

// Scroll view to be added to UITableViewCell
@property (nonatomic, weak) UIScrollView *cellScrollView;

// The cell's height
@property (nonatomic) CGFloat height;

// Views that live in the scroll view
@property (nonatomic, weak) UIView *scrollViewContentView;


@end

@interface NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;

@end
