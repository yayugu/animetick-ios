//
//  ATTicketContentView.h
//  Animetick
//
//  Created by yayugu on 2013/10/19.
//  Copyright (c) 2013年 yayugu. All rights reserved.
//

@class ATTicket;

@interface ATTicketContentView : UIView

@property (strong, nonatomic) ATTicket *ticket;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nearDateLabel;

@end
