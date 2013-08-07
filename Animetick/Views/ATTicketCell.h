//
//  ATTicketCell.h
//  Animetick
//
//  Created by yayugu on 2013/08/04.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

@class ATCheckbox;

@interface ATTicketCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *channel;
@property (weak, nonatomic) IBOutlet UILabel *startAt;
@property (weak, nonatomic) IBOutlet ATCheckbox *watchButton;

@end
