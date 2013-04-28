//
//  ViewController.m
//  iChallenge
//
//  Created by Toxa on 4/27/13.
//
//

#import "ViewController.h"
#import "HSInstagramLocationMedia.h"
#import "InstagramImageCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "HoleView.h"

@implementation ViewController
float cellSize, scale;
UIImageView *bigPhoto;
UIActivityIndicatorView *ai = nil;

@synthesize locationId = _locationId;
@synthesize images = _images;
@synthesize instagramCollectionView = _instagramCollectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationId = @"8638689";
    
    [self.instagramCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    [HSInstagramLocationMedia getLocationMediaWithId:self.locationId block:^(NSArray *records) {
        [ai stopAnimating];
        self.images = records;
        [self.instagramCollectionView reloadData];
    }];
}
-(void)viewDidAppear:(BOOL)animated {
    ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    ai.center = self.view.center;
    ai.hidesWhenStopped = YES;
    [ai startAnimating];
    [self.view addSubview:ai];
}
- (void)viewDidUnload {
    [self setInstagramCollectionView:nil];
    [super viewDidUnload];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    cellSize = self.instagramCollectionView.frame.size.width/2.0 - 5;
    return CGSizeMake(cellSize, cellSize);
}
/*- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InstagramImageCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"InstagramCell" forIndexPath:indexPath];
    if (indexPath.row >= self.images.count) return nil;
    CGRect aFrame = CGRectMake(0, 0, cellSize, cellSize);
    cell.frame = aFrame;
    cell.media = [self.images objectAtIndex:indexPath.row];
    cell.imageView.frame = aFrame;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HSInstagramLocationMedia *media = [self.images objectAtIndex:indexPath.row];
    bigPhoto = [[UIImageView alloc] init];
    [bigPhoto setImageWithURL: [NSURL URLWithString:media.standardUrl]];
    [self capturePhoto:nil];
}
-(void)capturePhoto:(UIButton *)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    HoleView* overlayView = [[HoleView alloc] initWithFrame:picker.view.frame];
    overlayView.rectSize = cellSize;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [picker.view addSubview: overlayView];
    
    [self presentModalViewController:picker animated:NO];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    scale = image.size.width/self.view.frame.size.width;
    CGRect r = CGRectMake(0, 0, cellSize*scale, cellSize*scale);
    r.origin = CGPointMake((image.size.height-r.size.height)/2, (image.size.width-r.size.width)/2);
    image = [self imageByCombiningImage:bigPhoto.image withImage:image byRect:r];
    [self dismissModalViewControllerAnimated:NO];

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setMessageBody:@"" isHTML:NO];
        //[mailer setToRecipients:[NSArray arrayWithObject:@"toxa23@gmail.com"]];
        [mailer setSubject:@"Take a look!"];
        [mailer addAttachmentData:UIImageJPEGRepresentation(image, 0.9) mimeType:@"image/jpeg" fileName:@"Instagrammed"];
        
        [self presentViewController:mailer animated:YES completion:^{}];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Failure"
                                                        message:@"Your device doesn't support in-app email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage byRect:(CGRect) rect {
    UIImage *image = nil;
    
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(firstImage.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(firstImage.size);
    }
    [firstImage drawAtPoint:CGPointMake(0, 0)];
    CGImageRef ref = CGImageCreateWithImageInRect(secondImage.CGImage, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
    UIImage *img = [UIImage imageWithCGImage:ref scale: secondImage.scale orientation:secondImage.imageOrientation];
    rect.size.width = rect.size.width / scale;
    rect.size.height = rect.size.height / scale;
    CGRect r = CGRectMake(firstImage.size.width - rect.size.width - 20, 20, rect.size.width, rect.size.height);
    [img drawInRect:r];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
