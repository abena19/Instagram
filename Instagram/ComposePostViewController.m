//
//  PhotoMapViewController.m
//  Instagram
//
//  Created by Abena Ofosu on 6/28/22.
//

#import "ComposePostViewController.h"
#import "SceneDelegate.h"
#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "Post.h"


@interface ComposePostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

- (IBAction)didtapCancel:(id)sender;
- (IBAction)didTapShare:(id)sender;

@end

@implementation ComposePostViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];  // Get edited image from UIImagePickerController
    [self.postImage setImage:editedImage];
    // Dismiss UIImagePickerController to go back to home feed view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (IBAction)didTapShare:(id)sender {
    Post *post = [Post postUserImage:self.postImage.image withCaption:self.captionField.text withCompletion: ^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
             NSLog(@"Error posting: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully posted the following caption: %@", self.captionField.text);
        }
    }];
    [self.composeDelegate didPost:post];
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)didtapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
    
- (IBAction)didTapPhoto:(UITapGestureRecognizer *)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // checking that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
@end
