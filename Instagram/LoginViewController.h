//
//  LoginViewController.h
//  Instagram
//
//  Created by Abena Ofosu on 6/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)registerUser:(id)sender;
- (IBAction)loginUser:(id)sender;

@end

NS_ASSUME_NONNULL_END
