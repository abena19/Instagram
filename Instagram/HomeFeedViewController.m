//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Abena Ofosu on 6/27/22.
//

#import "HomeFeedViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "ComposePostViewController.h"
#import "InstagramCell.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "DateTools.h"


@interface HomeFeedViewController () <UITableViewDataSource, ComposePostViewControllerDelegate>

- (IBAction)didTapLogout:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *homeFeedTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeFeedTableView.dataSource = self;
    [self.homeFeedTableView reloadData];
    self.homeFeedTableView.rowHeight = UITableViewAutomaticDimension;
    //implementing refresh feature
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.homeFeedTableView insertSubview:refreshControl atIndex:0];
    
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {  // fetch data asynchronously
        if (posts) {
            NSLog(@"😎😎😎 Successfully loaded home feed");
            self.postArray = [NSMutableArray arrayWithArray:(NSArray*)posts];
        } else {
            NSLog(@"😫😫😫 Error getting home feed: %@", error.localizedDescription);  // handle error
        }
        [self.homeFeedTableView reloadData];
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InstagramCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstagramCell"];
    Post *post = self.postArray[indexPath.row];
    // convert pffile object to image
    PFFileObject *postImageFile = post.image;
    [postImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.postImageView.image = [UIImage imageWithData:imageData];
        }
    }];
    cell.captionTextView.text = post.caption;
    cell.usernameLabel.text = post.author.username;
    NSDate *date = post.createdAt;
    cell.timeStampLabel.text = [date shortTimeAgoSinceNow];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSLog(@"%@", self.postArray);
    return cell;
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}


- (void)didPost:(nonnull Post *)post {
    [self.postArray insertObject:post atIndex:0];
    [self.homeFeedTableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([[segue identifier] isEqualToString:@"detailSegue"]) {
        NSIndexPath *postIndexPath = [self.homeFeedTableView indexPathForCell:sender];
        Post *postToPass = self.postArray[postIndexPath.row];
        DetailsViewController *detailVC = [segue destinationViewController];  // Get the new view controller
        detailVC.post = postToPass;
        NSLog(@"%@", postToPass);
   } else {
       UINavigationController *navigationController = [segue destinationViewController];
       ComposePostViewController *composeController = (ComposePostViewController*)navigationController.topViewController;
       composeController.composeDelegate = self;
   }
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    PFQuery *postQuery = [Post query];  // construct PFQuery
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {   // fetch data asynchronously
        if (posts) {
            NSLog(@"😎😎😎 Successfully refreshed home feed");
            self.postArray = [NSMutableArray arrayWithArray:(NSArray*)posts];
            [self.homeFeedTableView reloadData];  // Reload the tableView now that there is new data
            [refreshControl endRefreshing];  // Tell the refreshControl to stop spinning
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        }];
}


- (IBAction)didTapLogout:(id)sender {
    // access scene delegate
    SceneDelegate *loginSceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    loginSceneDelegate.window.rootViewController = loginViewController;  // switching content to LoginViewController
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}

@end
