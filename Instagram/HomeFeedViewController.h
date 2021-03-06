//
//  HomeFeedViewController.h
//  Instagram
//
//  Created by Abena Ofosu on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "ComposePostViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeFeedViewController : UIViewController <UITableViewDataSource, ComposePostViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *postArray;

@end

NS_ASSUME_NONNULL_END
