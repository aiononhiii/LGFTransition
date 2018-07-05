//
//  LGFCountDownButton.m
//  LGFOCTool
//
//  Created by apple on 2017/5/7.
//  Copyright © 2017年 来国锋. All rights reserved.
//

#import "LGFCountDownButton.h"
#import "LGFOCTool.h"

@interface LGFCountDownButton ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@end

@implementation LGFCountDownButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.lgf_Label];
    self.lgf_IsGray = YES;
    self.clipsToBounds = YES;
    self.lgf_Label.text = self.titleLabel.text;
    self.lgf_DefaultColor = self.backgroundColor;
    self.lgf_SelectColor = [UIColor lightGrayColor];
    [self setTitle:@"" forState:UIControlStateNormal];
    self.lgf_SelectTextColor = [UIColor darkGrayColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lgf_Label.frame = self.bounds;
}

- (UILabel *)lgf_Label {
    if (!_lgf_Label) {
        _lgf_Label = [[UILabel alloc] init];
        _lgf_Label.textColor = self.titleLabel.textColor;
        _lgf_Label.font = [UIFont fontWithName:@"Helvetica" size:15];
        _lgf_Label.textAlignment = NSTextAlignmentCenter;
    }
    return _lgf_Label;
}

- (void)lgf_TimeFailBeginFrom:(NSInteger)timeCount {
    self.count = timeCount;
    self.enabled = NO;
    // 加1个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired {
    if (self.count != 1) {
        self.count -= 1;
        self.enabled = NO;
        self.lgf_Label.text = [NSString stringWithFormat:@"重新发送 %lds", (long)self.count];
        if (self.lgf_IsGray) {
            self.lgf_Label.textColor = _lgf_SelectTextColor;
            self.backgroundColor = _lgf_SelectColor;
        }
    } else {
        self.enabled = YES;
        self.lgf_Label.text = self.titleLabel.text;
        self.lgf_Label.textColor = self.titleLabel.textColor;
        self.backgroundColor = _lgf_DefaultColor;
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
