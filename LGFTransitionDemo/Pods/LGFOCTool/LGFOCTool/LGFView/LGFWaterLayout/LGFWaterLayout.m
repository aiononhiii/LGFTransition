//
//  LGFWaterLayout.m
//  JKRFallsDemo
//
//  Created by apple on 2018/6/6.
//  Copyright © 2018年 Lucky. All rights reserved.
//

#import "LGFWaterLayout.h"

@interface LGFWaterLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *lgf_AttrsArray; // 所有的cell的布局
@property (nonatomic, strong) NSMutableArray *lgf_ColumnHeights;                                  // 每一列的高度
@property (nonatomic, assign) NSInteger lgf_NoneDoubleTime;                                       // 没有生成大尺寸次数
@property (nonatomic, assign) NSInteger lgf_LastDoubleIndex;                                      // 最后一次大尺寸的列数
@property (nonatomic, assign) NSInteger lgf_LastFixIndex;                                         // 最后一次对齐矫正列数
@property (nonatomic, assign) CGFloat lgf_WaterContentHeight;
@property (nonatomic, assign) CGFloat lgf_NotWaterContentHeight;
- (int)lgf_ColumnCount;     // 列数
- (CGFloat)lgf_ColumnMargin;    // 列边距
- (CGFloat)lgf_RowMargin;       // 行边距
- (UIEdgeInsets)lgf_EdgeInsets; // collectionView边距

@end

@implementation LGFWaterLayout

#pragma mark - 默认参数
static const CGFloat lgf_DefaultColumnCount = 2;                           // 默认列数
static const CGFloat lgf_DefaultColumnMargin = 1;                         // 默认列边距
static const CGFloat lgf_DefaultRowMargin = 1;                            // 默认行边距
static const UIEdgeInsets lgf_DefaultUIEdgeInsets = {0, 0, 0, 0};      // 默认collectionView边距

#pragma mark - 布局计算
// collectionView 首次布局和之后重新布局的时候会调用
// 并不是每次滑动都调用，只有在数据源变化的时候才调用
- (void)prepareLayout {
    // 重写必须调用super方法
    [super prepareLayout];
    
    // 判断如果有50个cell（首次刷新），就重新计算
    if ([self.collectionView numberOfItemsInSection:0] == 50) {
        [self.lgf_AttrsArray removeAllObjects];
        [self.lgf_ColumnHeights removeAllObjects];
    }
    // 当列高度数组为空时，即为第一行计算，每一列的基础高度加上collection的边框的top值
    if (!self.lgf_ColumnHeights.count) {
        for (NSInteger i = 0; i < self.lgf_ColumnCount; i++) {
            [self.lgf_ColumnHeights addObject:@(self.lgf_EdgeInsets.top)];
        }
    }
    // 遍历所有的cell，计算所有cell的布局
    for (NSInteger i = self.lgf_AttrsArray.count; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 计算布局属性并将结果添加到布局属性数组中
        [self.lgf_AttrsArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

// 返回布局属性，一个UICollectionViewLayoutAttributes对象数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.lgf_AttrsArray;
}

// 计算布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // cell的Size
    CGSize cellSize = [self.delegate lgf_cellSizeInWaterLayout:self indexPath:indexPath];
    
    // 列数
    int columnCount = self.lgf_ColumnCount;
    
    // 根据index判断是否执行瀑布流
    if (indexPath.item < [self.delegate lgf_StartWaterLayoutIndex]) {
        attrs.frame = CGRectMake(0, self.lgf_NotWaterContentHeight, cellSize.width, cellSize.height);
        self.lgf_NotWaterContentHeight += cellSize.height;
        for (int i = 0; i < columnCount; i++) {
            self.lgf_ColumnHeights[i] = @(self.lgf_NotWaterContentHeight);
        }
        return attrs;
    }
    
    // cell应该拼接的列数
    NSInteger destColumn = 0;
    
    // 取得当前最大高度
    CGFloat minColumnHeight = [self.lgf_ColumnHeights[0] doubleValue];
    for (int i = 0; i < columnCount; i++) {
        CGFloat columnHeight = [self.lgf_ColumnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat w = (cellSize.width - self.lgf_EdgeInsets.left - self.lgf_EdgeInsets.right - self.lgf_ColumnMargin * (self.lgf_ColumnCount - 1)) / self.lgf_ColumnCount;
    CGFloat h = cellSize.height;
    CGFloat x = self.lgf_EdgeInsets.left + destColumn * (w + self.lgf_ColumnMargin);
    CGFloat y = minColumnHeight;
    if (minColumnHeight != self.lgf_EdgeInsets.top) y += self.lgf_RowMargin;
    
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 配置总ContentSize
    self.lgf_ColumnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    CGFloat columnHeight = [self.lgf_ColumnHeights[destColumn] doubleValue];
    if (self.lgf_WaterContentHeight < columnHeight) self.lgf_WaterContentHeight = columnHeight;
    
    return attrs;
}

#pragma mark - 返回collectionView的ContentSize

- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.lgf_WaterContentHeight + self.lgf_EdgeInsets.bottom);
}

#pragma mark - 部分懒加载和取值方法

- (NSMutableArray *)lgf_AttrsArray {
    if (!_lgf_AttrsArray) {
        _lgf_AttrsArray = [NSMutableArray array];
    }
    return _lgf_AttrsArray;
}

- (NSMutableArray *)lgf_ColumnHeights {
    if (!_lgf_ColumnHeights) {
        _lgf_ColumnHeights = [NSMutableArray array];
    }
    return _lgf_ColumnHeights;
}

- (CGFloat)lgf_RowMargin {
    if ([self.delegate respondsToSelector:@selector(lgf_RowMarginInWaterLayout:)]) {
        return [self.delegate lgf_RowMarginInWaterLayout:self];
    } else {
        return lgf_DefaultRowMargin;
    }
}

- (int)lgf_ColumnCount {
    if ([self.delegate respondsToSelector:@selector(lgf_ColumnCountInWaterLayout:)]) {
        return [self.delegate lgf_ColumnCountInWaterLayout:self];
    } else {
        return lgf_DefaultColumnCount;
    }
}

- (CGFloat)lgf_ColumnMargin {
    if ([self.delegate respondsToSelector:@selector(lgf_ColumnMarginInWaterLayout:)]) {
        return [self.delegate lgf_ColumnMarginInWaterLayout:self];
    } else {
        return lgf_DefaultColumnMargin;
    }
}

- (UIEdgeInsets)lgf_EdgeInsets {
    if ([self.delegate respondsToSelector:@selector(lgf_EdgeInsetsInWaterLayout:)]) {
        return [self.delegate lgf_EdgeInsetsInWaterLayout:self];
    } else {
        return lgf_DefaultUIEdgeInsets;
    }
}

@end

