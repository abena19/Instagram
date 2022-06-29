//
//  DetailsViewController.m
//  Instagram
//
//  Created by Abena Ofosu on 6/29/22.
//

#import "DetailsViewController.h"
#import "Post.h"
#import "DateTools.h"
#import <Parse/Parse.h>

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UITextView *detailCaptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailTimestampLabel;

@end

@implementation DetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // convert pffile object to image
    PFFileObject *postImageFile = self.post.image;
    [postImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
        if (!error) {
            self.detailImageView.image = [UIImage imageWithData:imageData];
            self.detailCaptionTextView.text = self.post.caption;
            self.detailTimestampLabel.text = [self.post.createdAt shortTimeAgoSinceNow];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        NSLog(@"%@", self.post.createdAt);
    }];
}

@end
