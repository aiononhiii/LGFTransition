//
//  LGFThreeVC.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2019/4/1.
//  Copyright © 2019年 来国锋. All rights reserved.
//

#import "LGFThreeVC.h"
#import "LGFOCTool.h"
#import "LGFPushVC.h"

@interface LGFThreeVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *testCV;
@end

@implementation LGFThreeVC

lgf_SBViewControllerForM(LGFThreeVC, @"Main", @"LGFThreeVC");

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Collection View DataSource And Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(lgf_ScreenWidth, 150);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = lgf_CVGetCell(collectionView, UICollectionViewCell, indexPath);
    cell.backgroundColor = lgf_RandomColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LGFPushVC *vc = [LGFPushVC lgf];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
