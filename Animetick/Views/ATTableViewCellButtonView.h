//
//  ATTableViewCellButtonView.h
//  Animetick
//
//  Created by yayugu on 2013/10/20.
//  Copyright (c) 2013年 yayugu. All rights reserved.
//

@class ATSwipableTableViewCell;

@interface ATTableViewCellButtonView : UIView

@property (nonatomic, strong) NSArray *utilityButtons;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, weak) ATSwipableTableViewCell *parentCell;
@property (nonatomic) SEL utilityButtonSelector;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(ATSwipableTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;
- (CGFloat)utilityButtonsWidth;
- (void)populateUtilityButtons;


@end