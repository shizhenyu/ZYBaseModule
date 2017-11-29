//
//  ZYNetworkManager.h
//  ZYHttpManager
//
//  Created by youyun on 2017/10/30.
//  Copyright © 2017年 TaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZYNetworkManager;
@protocol ZYNetworkManagerDelegate <NSObject>

- (void)request:(ZYNetworkManager *)request finished:(id)response;
- (void)request:(ZYNetworkManager *)request Error:(id)error;

@end

@interface ZYNetworkManager : NSObject

@property (assign) id<ZYNetworkManagerDelegate> delegate;

/**
 *[AFNetWorking]的operationManager对象
 */
@property (nonatomic, strong) AFHTTPSessionManager *operationManager;

/**
 *当前的请求operation队列
 */
@property (nonatomic, strong) NSOperationQueue* operationQueue;

/**
 *功能: 创建NetworkTools的对象方法
 */
+ (instancetype)shareInstance;

/**
 *功能：POST请求  登录
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
- (void)login:(NSString *)URLString
   parameters:(NSDictionary*)parameters
      success:(void (^)(ZYNetworkManager *request, id responseObject))success
      failure:(void (^)(ZYNetworkManager *request, NSError *error))failure;

/**
 *功能：GET请求
 *参数：(1)请求的url: urlString
 *     (2)请求成功调用的Block: success
 *     (3)请求失败调用的Block: failure
 */
- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(ZYNetworkManager *, id responseObject))success
    failure:(void (^)(ZYNetworkManager *, NSError *))failure;

/**
 *功能：POST请求
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(ZYNetworkManager *request, id responseObject))success
     failure:(void (^)(ZYNetworkManager *request, NSError *error))failure;

/**
 *功能：POST请求上传图片
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:imageArray
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
- (void)PostImage:(NSString *)URLString
  imageArray:(NSMutableArray <NSData*>*)imageArray
     success:(void (^)(ZYNetworkManager *request, id responseObject))success
     failure:(void (^)(ZYNetworkManager *request, NSError *error))failure;

/**
 *  post请求
 *
 *  @param URLString  请求网址
 *  @param parameters 请求参数
 */
- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters;

/**
 *  get 请求
 *
 *  @param URLString 请求网址
 */
- (void)getWithURL:(NSString *)URLString;

/**
 *取消当前请求队列的所有请求
 */
- (void)cancelAllOperations;
@end
