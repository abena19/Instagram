//
//  InstagramCell.m
//  Instagram
//
//  Created by Abena Ofosu on 6/28/22.
//

#import "InstagramCell.h"
#import "DateTools.h"
#import "Post.h"
#import <Parse/Parse.h>
#import "DateTools.h"

@implementation InstagramCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setPost {
    // convert pffile object to image
    PFFileObject *postImageFile = self.post.image;
    [postImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.postImageView.image = [UIImage imageWithData:imageData];
        }
    }];
    self.captionTextView.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    NSDate *date = self.post.createdAt;
    self.timeStampLabel.text = [date shortTimeAgoSinceNow];
}

@end
