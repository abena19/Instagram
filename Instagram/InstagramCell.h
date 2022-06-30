//
//  InstagramCell.h
//  Instagram
//
//  Created by Abena Ofosu on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InstagramCellDelegate;

@interface InstagramCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) id<InstagramCellDelegate> delegate;
@property (strong, nonatomic) Post *post;

- (void)setPost;

@end

@protocol InstagramCellDelegate
- (void)instagramCell:(InstagramCell *) instagramCell didTapUserProfile: (PFUser *)user;
@end

NS_ASSUME_NONNULL_END
