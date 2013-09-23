#import <UIKit/UIKit.h>

typedef void (^ATAlertViewShowCompletion)(NSUInteger buttonIndex);

@interface ATAlertView : UIAlertView

- (id)initWithTitle:(NSString*)title
            message:(NSString*)message
  cancelButtonTitle:(NSString*)cancelButtonTitle
  otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)showWithCompletion:(ATAlertViewShowCompletion)completion;

@end
