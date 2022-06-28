//
//  PhotoMapViewController.m
//  Instagram
//
//  Created by Abena Ofosu on 6/28/22.
//

#import "PhotoMapViewController.h"
#import "SceneDelegate.h"
#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "Post.h"

@interface PhotoMapViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *captionView;

- (IBAction)didtapCancel:(id)sender;
- (IBAction)didTapShare:(id)sender;

@end

@implementation PhotoMapViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.postImage setImage:editedImage];
    // self.postImage.image = [self resizeImage:editedImage withSize:(60, 60)];
    // Do something with the images (based on your use case)
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
    [Post postUserImage:self.postImage.image withCaption:self.captionView.text withCompletion: ^(BOOL succeeded, NSError * _Nullable error)
    {
        if(error){
             NSLog(@"Error posting: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully posted the following caption: %@", self.captionView.text);
        }
    }];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didtapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
    
@end
