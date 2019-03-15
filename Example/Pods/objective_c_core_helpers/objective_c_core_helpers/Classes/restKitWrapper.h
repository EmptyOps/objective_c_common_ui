//
//  restKitWrapper.h
//  XClient
//
//  Copyright (c) 2015 XClient. All rights reserved.
//

// 1
#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

// 3
@interface restKitWrapper : NSObject

/**
 *  global single RESTKit manager
 */
@property RKObjectManager *objectManager;
@property RKObjectManager *objectManagerNew;

typedef void(^downloadCallback)(NSDictionary *response);
@property(nonatomic,strong) downloadCallback callback;

-(NSDictionary*) jsonStrToObj:(RKObjectRequestOperation *) operation;

+(BOOL) dictionary:(NSDictionary*) dict valueOfKey:(NSString*) key equalToStr:(NSString*) str;

/**
 *  singltone
 *
 *  @return return singleton isntance of restKitWrapper
 */
+(restKitWrapper *) singleton;

//
- (void) configureRestKit;

/**
 *
 */

- (void)restToCallWithMapping:(NSString *)controller
                         href:(NSString *)href
                   hrefParams:(NSString *)hrefParams
                   formParams:(NSMutableDictionary *)formParams
                      success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *result))success
                      failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
                   formMethod:(NSInteger)formMethod;

/**
 *
 */

- (void)restToCall:(NSString *)controller
              href:(NSString *)href
        hrefParams:(NSString *)hrefParams
        formParams:(NSMutableDictionary *)formParams
           success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *result))success
           failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
        formMethod:(NSInteger)formMethod
         retry_cnt: (int) retry_cnt;

- (void)restToCallNew:(NSString *)controller
                 href:(NSString *)href
           hrefParams:(NSString *)hrefParams
           formParams:(NSMutableDictionary *)formParams
              success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *result))success
              failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
           formMethod:(NSInteger)formMethod;

- (void) uploadImage :(NSData*) image
          controller :(NSString *)controller
                 href:(NSString *)href
           hrefParams:(NSString *)hrefParams
           formParams:(NSMutableDictionary *)formParams
      file_field_name:(NSString*) file_field_name
            file_name:(NSString*) file_name
            mime_type:(NSString*) mime_type
              success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *result))success
              failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;

-(NSString*) getDownloadConnectionKey:(NSURLConnection *)connection;

-(void) removeDownloadConnectionObjects:(NSURLConnection *)connection;

-(void)downloadWithNsurlconnection:(NSString*) currentURL
                       progressBar:(UIProgressView*) progressBar
                          savePath:(NSString*) savePath
                               key:(NSString*) key
                          callback:(downloadCallback)callback;

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:    (NSCachedURLResponse *)cachedResponse;

- (void) connectionDidFinishLoading:(NSURLConnection *)connection;

@end
