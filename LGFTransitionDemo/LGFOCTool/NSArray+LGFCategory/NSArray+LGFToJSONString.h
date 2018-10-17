//
//  NSArray+LGFToJSONString.h
//  LGFOCTool
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (LGFToJSONString)

#pragma mark - 数组转 JSON字符串
- (nullable NSString *)lgf_ArrayToJson;

#pragma mark - 数组转 格式化JSON字符串
- (nullable NSString *)lgf_ArrayToJsonPrettyString;

@end

NS_ASSUME_NONNULL_END
