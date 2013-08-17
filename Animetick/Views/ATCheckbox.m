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
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor blackColor];
        
        CGRect frame = {
            .origin.x = 0,
            .origin.y = 0,
            .size = self.frame.size
        };
        self.checkLabel = [[UILabel alloc] initWithFrame:frame];
        self.checkLabel.backgroundColor = [UIColor clearColor];
        self.checkLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.checkLabel];
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if (checked) {
        self.checkLabel.text = @"watched";
    } else {
        self.checkLabel.text = @"watch";
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
