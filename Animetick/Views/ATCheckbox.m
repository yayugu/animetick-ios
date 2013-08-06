//
//  ATCheckbox.m
//  Animetick
//
//  Created by yayugu on 2013/08/06.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATCheckbox.h"

@interface ATCheckbox ()

@property (nonatomic, strong) UILabel *checkLabel;

@end

@implementation ATCheckbox

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.checkLabel = [[UILabel alloc] initWithFrame:self.frame];
        [self addSubview:self.checkLabel];
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if (checked) {
        self.checkLabel.text = @"✔";
    } else {
        self.checkLabel.text = @"";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
