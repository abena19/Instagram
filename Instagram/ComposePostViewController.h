//
//  PhotoMapViewController.h
//  Instagram
//
//  Created by Abena Ofosu on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposePostViewControllerDelegate
- (void)didPost:(Post *)post;
@end

@interface ComposePostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) id<ComposePostViewControllerDelegate> composeDelegate;
- (IBAction)didTapPhoto:(UITapGestureRecognizer *)sender;



@end

NS_ASSUME_NONNULL_END
