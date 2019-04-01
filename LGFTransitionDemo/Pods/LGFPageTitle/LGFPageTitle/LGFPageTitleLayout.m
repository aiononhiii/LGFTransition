//
//  LGFPageTitleLayout.m
//  OptimalLive
//
//  Created by apple on 2018/12/6.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "LGFPageTitleLayout.h"

@implementation LGFPageTitleLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    if (self.page_view_animation_type == LGFPageViewAnimationTopToBottom) {
        CGFloat contentOffsetX = self.collectionView.contentOffset.x;
        CGFloat collectionViewCenterX = self.collectionView.bounds.size.width * 0.5;
        for (UICollectionViewLayoutAttributes *attr in attrs) {
            CGFloat alpha = fabs(1 - fabs(attr.center.x - contentOffsetX - collectionViewCenterX) /self.collectionView.bounds.size.width);
            CGFloat scale = -fabs(fabs(attr.center.x - contentOffsetX - collectionViewCenterX) /self.collectionView.bounds.size.width) * 50;
            NSInteger index = fabs(self.collectionView.contentOffset.x / self.collectionView.bounds.size.width);
            // 判断滑动方向
            if ([self.collectionView.panGestureRecognizer translationInView:self.collectionView].x < 0) {
                if (attr.indexPath.item != index) {
                    attr.alpha = alpha;
                }
            } else {
                if (attr.indexPath.item == index) {
                    attr.alpha = alpha;
                }
            }
            attr.transform = CGAffineTransformMakeTranslation(0, scale);
        }
        return attrs;
    } else if (self.page_view_animation_type == LGFPageViewAnimationSmallToBig) {
        CGFloat contentOffsetX = self.collectionView.contentOffset.x;
        CGFloat collectionViewCenterX = self.collectionView.bounds.size.width * 0.5;
        for (UICollectionViewLayoutAttributes *attr in attrs) {
            CGFloat scale = (1 - fabs(attr.center.x - contentOffsetX - collectionViewCenterX) /self.collectionView.bounds.size.width * 0.8);
            attr.transform = CGAffineTransformMakeScale(scale, scale);
        }
        return attrs;
    } else {
        return attrs;
    }
}

@end
