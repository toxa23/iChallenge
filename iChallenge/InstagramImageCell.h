//
//  InstagramImageCell.h
//  iChallenge
//
//  Created by Toxa on 4/27/13.
//
//

#import <UIKit/UIKit.h>
#import "HSInstagramLocationMedia.h"
#import "UIImageView+AFNetworking.h"

@interface InstagramImageCell : UICollectionViewCell
@property (nonatomic, strong) HSInstagramLocationMedia *media;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@end
