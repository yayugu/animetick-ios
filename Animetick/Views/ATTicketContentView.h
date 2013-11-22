//
//  ATTicketContentView.h
//  Animetick
//
//  Created by yayugu on 2013/10/19.
//  Copyright (c) 2013年 yayugu. All rights reserved.
//

@class ATTicket;

@interface ATTicketContentView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) ATTicket *ticket;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *channel;
@property (weak, nonatomic) IBOutlet UILabel *startAt;
@property (weak, nonatomic) IBOutlet UILabel *nearDateLabel;

@end
