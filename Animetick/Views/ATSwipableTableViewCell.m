//
//  ATSwipableTableViewCell.m
//  Animetick
//
//  Created by yayugu on 2013/10/20.
//  Copyright (c) 2013年 yayugu. All rights reserved.
//

#import "ATSwipableTableViewCell.h"
#import "ATTableViewCellButtonView.h"

typedef enum {
    kCellStateCenter,
    kCellStateRight
} SWCellState;

@interface ATSwipableTableViewCell () <UIScrollViewDelegate>

// The state of the cell within the scroll view, can be left, right or middle
@property (nonatomic) SWCellState cellState;

@property (nonatomic, strong) ATTableViewCellButtonView *scrollViewButtonViewRight;

// Scroll view to be added to UITableViewCell
@property (nonatomic, weak) UIScrollView *cellScrollView;

// Used for row height and selection
@property (nonatomic, weak) UITableView *containingTableView;

@property (nonatomic) BOOL shrinked;

@property (nonatomic) BOOL animating;

@end

@implementation ATSwipableTableViewCell

#pragma mark Initializers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView rightUtilityButtons:(NSArray *)rightUtilityButtons
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = self.frame;
        self.frame = frame;
        self.rightUtilityButtons = rightUtilityButtons;
        self.containingTableView = containingTableView;
        self.highlighted = NO;
        [self initializer];
    }
    
    return self;
}

- (void)initializer
{
    // Set up the views that will hold the utility buttons
    ATTableViewCellButtonView *scrollViewButtonViewRight = [[ATTableViewCellButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];
    self.scrollViewButtonViewRight = scrollViewButtonViewRight;
    scrollViewButtonViewRight.frame = [self scrollViewButtonViewRightFrame];
    [self.contentView addSubview:scrollViewButtonViewRight];

    // Set up scroll view that will host our cell content
    UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.bounds.size.height)];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
    [cellScrollView addGestureRecognizer:tapGestureRecognizer];
    
    self.cellScrollView = cellScrollView;

    cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], self.bounds.size.height);
    cellScrollView.contentOffset = [self scrollViewContentOffset];
    cellScrollView.delegate = self;
    cellScrollView.showsHorizontalScrollIndicator = NO;
    cellScrollView.scrollsToTop = NO;
    
    // Populate the button views with utility buttons
    [scrollViewButtonViewRight populateUtilityButtons];
    
    // Create the content view that will live in our scroll view
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.bounds.size.height)];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.cellScrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    [self.contentView addSubview:cellScrollView];
    
    self.shrinked = NO;
    self.animating = NO;
}

#pragma mark Selection

- (void)scrollViewPressed:(id)sender
{
    if(_cellState == kCellStateCenter) {
        // Selection hack
        if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [_containingTableView indexPathForCell:self];
            [self.containingTableView.delegate tableView:_containingTableView didSelectRowAtIndexPath:cellIndexPath];
        }
        // Highlight hack
        if (!self.highlighted) {
            self.scrollViewButtonViewRight.hidden = YES;
            NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
            [self setHighlighted:YES];
        }
    } else {
        // Scroll back to center
        [self hideUtilityButtonsAnimated:YES];
    }
}

- (void)timerEndCellHighlight:(id)sender
{
    if (self.highlighted) {
        self.scrollViewButtonViewRight.hidden = NO;
        [self setHighlighted:NO];
    }
}

#pragma mark UITableViewCell overrides

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.scrollViewContentView.backgroundColor = backgroundColor;
}

#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(id)sender
{
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerRightUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
    }
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated
{
    // Scroll back to center
    [self.cellScrollView setContentOffset:CGPointMake(0, 0) animated:animated];
    [self expandDraggableArea];
    _cellState = kCellStateCenter;
}

- (void)showRightUtilityButtonsAnimated:(BOOL)animated
{
    [self revealRightUtiliyButtonsWithOverrun:nil finished:nil context:nil];
    _cellState = kCellStateRight;
}

#pragma mark - Animation helpers

- (void)revealRightUtiliyButtonsWithOverrun:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.animating = YES;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:0
                     animations:^{
                         self.cellScrollView.contentSize = (CGSize){
                             .width = CGRectGetWidth(self.bounds) + [self utilityButtonsPadding] + 100,
                             .height = self.cellScrollView.contentSize.height,
                         };
                         self.cellScrollView.contentOffset = CGPointMake([self utilityButtonsPadding] + 20, 0);
                         
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(revealRightUtiliyButtons:finished:context:)];
                     }
                     completion:nil];
}

- (void)revealRightUtiliyButtons:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:0
                     animations:^{
                         self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], self.bounds.size.height);
                         self.cellScrollView.contentOffset = CGPointMake([self utilityButtonsPadding], 0);
                     }
                     completion:^(BOOL finished){
                         [self shrinkDraggableArea];
                         self.animating = NO;
                     }];
}

#pragma mark - Overriden methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.bounds.size.height);
    self.scrollViewButtonViewRight.frame = [self scrollViewButtonViewRightFrame];
    
    // FIXME: きたねえし、なんでこれやらないと正しく動かないかわからねえ
    self.scrollViewContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.bounds.size.height);
    ((UIView*)(self.scrollViewContentView.subviews[0])).frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.bounds.size.height);
    
    if (!self.cellScrollView.dragging && !self.cellScrollView.decelerating && !self.animating) {
        if (_cellState == kCellStateCenter) {
            [self setCellScrollViewExpandedSize];
        } else {
            [self setCellScrollViewShrinkedSize];
        }
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self expandDraggableArea];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
                return;
            }
            break;
        case kCellStateRight:
            if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
                return;
            }
            break;
        default:
            break;
    }
    CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
    if (targetContentOffset->x > rightThreshold) {
        [self scrollToRight:targetContentOffset];
    } else {
        [self scrollToCenter:targetContentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    switch (_cellState) {
        case kCellStateCenter:
            break;
        case kCellStateRight:
            [self shrinkDraggableArea];
            break;
    }
}

#pragma mark - Internal methods

- (void)scrollToRight:(inout CGPoint *)targetContentOffset
{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset
{
    targetContentOffset->x = 0;
    _cellState = kCellStateCenter;
}

- (CGFloat)rightUtilityButtonsWidth
{
    return [_scrollViewButtonViewRight utilityButtonsWidth];
}

- (CGFloat)utilityButtonsPadding
{
    return [_scrollViewButtonViewRight utilityButtonsWidth];
}

- (CGPoint)scrollViewContentOffset
{
    return CGPointMake(0, 0);
}

- (CGRect)scrollViewButtonViewRightFrame
{
    return ((CGRect) {
        .origin.x = CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth],
        .origin.y = 0,
        .size.width = [self rightUtilityButtonsWidth],
        .size.height = self.bounds.size.height,
    });
}

- (void)setCellScrollViewExpandedSize
{
    self.cellScrollView.frame = (CGRect){
        .origin = self.cellScrollView.frame.origin,
        .size.width = self.bounds.size.width,
        .size.height = self.bounds.size.height,
    };
    self.cellScrollView.contentSize = (CGSize){
        .width = self.bounds.size.width + [self utilityButtonsPadding],
        .height = self.bounds.size.height,
    };
}

- (void)setCellScrollViewShrinkedSize
{
    self.cellScrollView.frame = (CGRect){
        .origin = self.cellScrollView.frame.origin,
        .size.width = self.bounds.size.width - [self utilityButtonsPadding],
        .size.height = self.bounds.size.height,
    };
    self.cellScrollView.contentSize = (CGSize){
        .width = self.bounds.size.width,
        .height = self.bounds.size.height,
    };
}

- (void)expandDraggableArea
{
    if (!self.shrinked) return;
    [self setCellScrollViewExpandedSize];
    self.cellScrollView.contentOffset = (CGPoint){
        .x = [self utilityButtonsPadding],
        .y = 0,
    };
    self.shrinked = NO;
}

- (void)shrinkDraggableArea
{
    [self setCellScrollViewShrinkedSize];
    self.shrinked = YES;
}

@end


