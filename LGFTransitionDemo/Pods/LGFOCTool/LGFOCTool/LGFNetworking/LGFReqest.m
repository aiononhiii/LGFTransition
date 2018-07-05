//
//  LGFReqest.m
//  LGFOCTool
//
//  Created by apple on 2017/6/7.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFReqest.h"

@implementation LGFReqest

#pragma mark - 网络请求
/**
 @param method 请求方法：GET/POST 目前只支持这两中
 @param url 地址
 @param param 参数
 @param completed 回调
 */
+ (void)lgf_Request:(lgf_RequestMethod)method url:(NSString *)url param:(NSDictionary *)param completed:(void(^)(NSDictionary *data, NSError *error))completed {
    if (method == lgf_GET) {
        // GET
        [[LGFNetwork sharedNetwork] lgf_GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSDictionary *json_dic = (NSDictionary*)responseObject;
//            NSData *data = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"\n<<-----------返回--------------------\n Url == %@\n Response == %@\n", url, dataStr);
            if ((!responseObject[@"errorCode"] || [responseObject[@"errorCode"] integerValue] != 200 )) {
                // 无返回参数, 但返回code不等于200
                NSString *errorMessage = responseObject[@"errorMessage"] ?: @"请求出了点问题哦, 请稍后重试";
                NSInteger code = responseObject[@"errorCode"] ? [responseObject[@"errorCode"] integerValue] : task.error.code;
                NSError * err = [NSError errorWithDomain:@"LGF" code: code userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
                completed([NSDictionary dictionary], err);
            } else if (responseObject[@"code"] && [responseObject[@"code"] integerValue] != 200) {
                // 有返回参数, 但返回code不等于200
                NSString *errorMessage = responseObject[@"message"] ?: @"请求出了点问题哦, 请稍后重试";
                NSInteger code = responseObject[@"code"]? [responseObject[@"code"] integerValue] : task.error.code;
                NSError * err = [NSError errorWithDomain:@"LGF" code: code userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
                completed([NSDictionary dictionary], err);
            } else {
                // 请求成功 有返回参数, 返回code等于200
                completed(responseObject[@"data"], nil);
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            // 网络欠佳的情况
            if (error.code == -1001 || [error.localizedDescription isEqualToString:@"The request timed out."]) {
                NSError *err = [NSError errorWithDomain:@"LGF" code: -1001 userInfo:@{NSLocalizedDescriptionKey:@"当前网络不佳，请检查网络"}];
                error = err;
            }
            if (error.code == -1009) {
                // 网络断开
                NSError *err = [NSError errorWithDomain:@"LGF" code: -1009 userInfo:@{NSLocalizedDescriptionKey:@"似乎已断开与互联网的连接"}];
                error = err;
            }
            if (error.code == 500) {
                NSError *err = [NSError errorWithDomain:@"LGF" code: 500 userInfo:@{NSLocalizedDescriptionKey:@"当前服务不可用，请稍后再试"}];
                error = err;
            }
            completed(nil, error);
        }];
    } else if (method == lgf_POST) {
        // POST
        [[LGFNetwork sharedNetwork] lgf_POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSDictionary *json_dic = (NSDictionary*)responseObject;
//            NSData *data = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"\n<<-----------返回--------------------\n Url == %@\n Response == %@\n", url, dataStr);
            if ((!responseObject[@"errorCode"] || [responseObject[@"errorCode"] integerValue] != 200 )) {
                // 无返回参数, 但返回code不等于200
                NSString *errorMessage = responseObject[@"errorMessage"] ?: @"请求出了点问题哦, 请稍后重试";
                NSInteger code = responseObject[@"errorCode"] ? [responseObject[@"errorCode"] integerValue] : task.error.code;
                NSError * err = [NSError errorWithDomain:@"LGF" code: code userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
                completed([NSDictionary dictionary],err);
            } else if (( responseObject[@"code"] && [responseObject[@"code"] integerValue] != 200 )) {
                // 有返回参数, 但返回code不等于200
                NSString *errorMessage = responseObject[@"message"] ?: @"请求出了点问题哦, 请稍后重试";
                NSInteger code = responseObject[@"code"]? [responseObject[@"code"] integerValue] : task.error.code;
                NSError * err = [NSError errorWithDomain:@"LGF" code: code userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
                completed([NSDictionary dictionary],err);
            } else {
                // 请求成功 有返回参数, 返回code等于200
                completed(responseObject[@"data"],nil);
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            // 网络欠佳的情况
            if (error.code == -1001 || [error.localizedDescription isEqualToString:@"The request timed out."]) {
                NSError *err = [NSError errorWithDomain:@"LGF" code: -1001 userInfo:@{NSLocalizedDescriptionKey:@"当前网络不佳，请检查网络"}];
                error = err;
            }
            if (error.code == -1009) {
                // 网络断开
                NSError *err = [NSError errorWithDomain:@"LGF" code: -1009 userInfo:@{NSLocalizedDescriptionKey:@"似乎已断开与互联网的连接"}];
                error = err;
            }
            if (error.code == 500) {
                NSError *err = [NSError errorWithDomain:@"LGF" code: 500 userInfo:@{NSLocalizedDescriptionKey:@"当前服务不可用，请稍后再试"}];
                error = err;
            }
            completed(nil, error);
        }];
    }
}

#pragma mark - 下载文请求
/**
 @param fileUrl 要下载的文件路径
 @param path 下载的文件保存路径
 @param completed 完成后回调
 */
+ (void)lgf_DownLoadFile:(NSString *)fileUrl saveToPath:(NSString *)path completed:(void(^)(NSURL *url, NSError *error))completed {
    [[LGFNetwork sharedNetwork] lgf_DownloadTaskWithRequest:fileUrl saveToPath:path completionHandler:^(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completed(filePath,error);
    }];
}

@end
