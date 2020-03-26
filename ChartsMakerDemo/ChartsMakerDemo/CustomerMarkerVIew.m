//
//  CustomerMarkerVIew.m
//  ChartsMakerDemo
//
//  Created by cui on 2020/3/26.
//  Copyright © 2020 ZhiBan. All rights reserved.
//

#import "CustomerMarkerVIew.h"

@interface CustomerMarkerVIew ()

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation CustomerMarkerVIew
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.bgImgView = [[UIImageView alloc] init];
    self.bgImgView.image = [UIImage imageNamed:@"bbd_image_bgview"];
    [self addSubview:self.bgImgView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.contentLabel];
    
    self.bgImgView.frame = self.bounds;
    self.contentLabel.frame = CGRectMake(20, 16, 90, 20);
}


- (void)setMarkerViewWithX:(NSInteger)x y:(NSInteger)y{
    self.contentLabel.text = [NSString stringWithFormat:@"x:%ld,y:%ld",x,y];
}

@end
