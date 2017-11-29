//
//  ZYNetworkManager.m
//  ZYHttpManager
//
//  Created by youyun on 2017/10/30.
//  Copyright © 2017年 TaoSheng. All rights reserved.
//

#import "ZYNetworkManager.h"
#import "CocoaSecurity.h"
#import "SSKeychain.h"

NSString *const kBaseUrl = @"https://apiflbl.aduer.com/"; // 基本的URL
NSString *const kUploadUrl = @"https://apiflbl.aduer.com/uppic.ashx";
NSString *const kTokenMD5Key = @"8250225678eb1d1220e939cc0dedfc9c94bbcdf2";  // 工程签名

@implementation ZYNetworkManager

#pragma mark - Init Method
+ (instancetype)shareInstance
{
    return [[self alloc] init];
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
     
        self.operationManager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        self.operationManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        self.operationManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.operationManager.securityPolicy.allowInvalidCertificates = YES;
        [self.operationManager.securityPolicy setValidatesDomainName:NO];
        self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"text/css", nil];
        self.operationManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    
    return self;
}

#pragma mark - Login Method
- (void)login:(NSString *)URLString
   parameters:(NSDictionary*)parameters
      success:(void (^)(ZYNetworkManager *request, id responseObject))success
      failure:(void (^)(ZYNetworkManager *request, NSError *error))failure
{
    self.operationQueue = self.operationManager.operationQueue;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [self addRequiredKeyAndValueToDic:dic]; //添加必须的键值对（如果没有必要的参数，可以不用传）
    
    [dic addEntriesFromDictionary:parameters];
    
    NSDictionary * dict = [self md5DictHttpManagers:dic]; //使用MD5对参数进行加密
    Log(@"%@",dict);
    
    [self.operationManager POST:URLString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        Log(@"[NetworkTools]: %@",responseDict);
        
        success(self,responseDict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        Log(@"[NetworkTools]: %@",error.localizedDescription);
        failure(self,error);
        
    }];
}

#pragma mark - GET Request Method
- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(ZYNetworkManager *, id responseObject))success
    failure:(void (^)(ZYNetworkManager *, NSError *))failure
{
    
    self.operationQueue=self.operationManager.operationQueue;
    
    [self.operationManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        Log(@"[NetworkTools]: %@",responseObject);
        success(self,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        Log(@"[NetworkTools]: %@",error.localizedDescription);
        failure(self,error);
    }];
}


#pragma mark - POST Request Method
- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(ZYNetworkManager *request, id responseObject))success
     failure:(void (^)(ZYNetworkManager *request, NSError *error))failure
{
    self.operationQueue = self.operationManager.operationQueue;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [self addRequiredKeyAndValueToDic:dic]; //添加必须的键值对
    
    [dic addEntriesFromDictionary:parameters];
    
    NSDictionary * dict = [self md5DictHttpManagers:dic]; //参数加密，用的MD5加密
    Log(@"%@",dict);
    
    [self.operationManager POST:URLString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        Log(@"[NetworkTools]: %@",responseDict);
        
        success(self,responseDict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        Log(@"[NetworkTools]: %@",error.localizedDescription);
        failure(self,error);
        
    }];
}

#pragma mark - 上传图片
- (void)PostImage:(NSString *)URLString
       imageArray:(NSMutableArray <NSData *>*)imageArray
          success:(void (^)(ZYNetworkManager *request, id responseObject))success
          failure:(void (^)(ZYNetworkManager *request, NSError *error))failure;
{
    [self.operationManager POST:kUploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < imageArray.count; i++) {
            
            NSData *imageData = [imageArray objectAtIndex:i];
            
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[self getCurrentTimeStr]];
            
            [formData appendPartWithFileData:imageData name:@"imgFile" fileName:imageName mimeType:@"jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        Log(@"%@",dict);
        
        success(self, responseObject);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        Log(@"%@",error.domain);
        
        failure(self, error);
    }];
}

#pragma mark - GET and POST Method -- 使用代理
- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters {
    
    [self POST:URLString
    parameters:parameters
       success:^(ZYNetworkManager *request, id responseObject) {
           
           if ([self.delegate respondsToSelector:@selector(request:finished:)]) {
               
               [self.delegate request:request finished:responseObject];
               
           }
       }
       failure:^(ZYNetworkManager *request, NSError *error) {
           
           if ([self.delegate respondsToSelector:@selector(request:Error:)]) {
               
               [self.delegate request:request Error:error.description];
               
           }
       }];
}

- (void)getWithURL:(NSString *)URLString {
    
    [self GET:URLString parameters:nil success:^(ZYNetworkManager *request, id responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(request:finished:)]) {
            
            [self.delegate request:request finished:responseObject];
        }
    } failure:^(ZYNetworkManager *request, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(request:Error:)]) {
            
            [self.delegate request:request Error:error.description];
        }
    }];
}

#pragma mark - 取消所有网络请求
- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}

#pragma mark - 添加必须要传的key （如若不需要可不传）
- (void)addRequiredKeyAndValueToDic:(NSMutableDictionary *)originDic
{
    NSMutableDictionary *requireDic = [[NSMutableDictionary alloc]init];
    NSDate* date = [NSDate date];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate * localDate = [date dateByAddingTimeInterval:interval];
    NSTimeInterval a=[localDate timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    long int b = timeString.longLongValue-28800;
    [requireDic setObject:[NSNumber numberWithLong:b] forKey:@"timeStamp"];
    [requireDic setObject:[self getUUID] forKey:@"deviceID"];
    
    // 合并key，遇到相同的key会直接把原来的value替换成后面的value
    [originDic addEntriesFromDictionary:requireDic];
}

#pragma mark - 加密方法 （如若工程不加密，可不用）
- (NSDictionary *)md5DictHttpManagers:(NSMutableDictionary *)dict
{
    
    NSMutableString *mutableStr = [[NSMutableString alloc]init];
    
    NSArray* array=[dict allKeys];
    
    NSArray* paiarray=[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    
    for (NSString *key in paiarray) {
        
        [mutableStr appendFormat:@"%@",dict[key]];
    }
    
    [mutableStr appendFormat:@"%@",kTokenMD5Key];
    
    NSString *xiaoxie= [mutableStr lowercaseString];
    
    NSString *zmString=[self encodeToPercentEscapeString:xiaoxie];
    
    NSMutableString* nnstring=[NSMutableString stringWithString:zmString];
    
    [nnstring replaceOccurrencesOfString:@"%20" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0,[nnstring length])];
    
    NSString*  xiaoxie2= [nnstring lowercaseString];
    
    NSString* mdStr=[CocoaSecurity md5:xiaoxie2].hex;
    
    [dict setObject:mdStr forKey:@"sign"];
    
    return dict;
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)input,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    
    return outputStr;
}
- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,
                                                      [outputStr length])];
    
    return
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - 获取用户UUID
- (NSString*)getUUID{
    
    if (TARGET_IPHONE_SIMULATOR) {
        return @"emulator";
    }
    
    NSString *service =[NSString stringWithFormat:@"lclebi_%@",[[NSBundle mainBundle] bundleIdentifier]];
    NSArray *accounts = [SSKeychain accountsForService:service];
    if(accounts&&[accounts count]>0){
        NSDictionary *dictionary = [accounts objectAtIndex:0];
        NSString *account = [dictionary objectForKey:@"acct"];
        return  [NSString stringWithFormat:@"iphone%@",account];
    }else{
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        Log(@"初次创建手机UUID：%@",result);
        [SSKeychain setPassword:result forService:service account:result];
        return  [NSString stringWithFormat:@"iphone%@",result];
    }
}
#pragma mark - 获取当前日期的字符串
- (NSString *)getCurrentTimeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}
@end
