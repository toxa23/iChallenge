//
//  ViewController.h
//  iChallenge
//
//  Created by Toxa on 4/27/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSString *locationId;
@property (nonatomic, strong) NSArray* images;
@property (strong, nonatomic) IBOutlet UICollectionView *instagramCollectionView;

@end
