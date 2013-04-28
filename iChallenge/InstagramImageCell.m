//
//  InstagramImageCell.m
//  iChallenge
//
//  Created by Toxa on 4/27/13.
//
//

#import "InstagramImageCell.h"

@implementation InstagramImageCell
@synthesize media = _media;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setMedia:(HSInstagramLocationMedia *)media {
    _media = media;
    NSLog(@"loading %@", _media.thumbnailUrl);
    [self.imageView setImageWithURL:[NSURL URLWithString:_media.thumbnailUrl]];
}
@end
