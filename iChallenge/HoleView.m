//
//  HoleView.m
//  iChallenge
//
//  Created by Toxa on 4/28/13.
//
//

#import "HoleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HoleView
@synthesize rectSize = _rectSize;

- (id)initWithFrame:(CGRect)frame {
    frame.size.height = frame.size.height - 100;
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setOpaque:NO];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect r1, r2, r;
    int thickness = (rect.size.width-_rectSize)/2.0;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 255.0, 255.0, 255.0, 0.5);
    //CGContextSetLineWidth(contextRef, thickness);
    r1 = rect;
    r1.size.height = (rect.size.height - _rectSize) / 2.0;
    CGContextFillRect(contextRef, r1);
    r2 = r1;
    r2.origin.y = rect.size.height - r2.size.height;
    CGContextFillRect(contextRef, r2);
    r = rect;
    r.size.width = thickness;
    r.origin.y = r1.size.height;
    r.size.height = r2.origin.y - r.origin.y;
    CGContextFillRect(contextRef, r);
    r.origin.x = rect.size.width - r.size.width;
    CGContextFillRect(contextRef, r);
}

@end
