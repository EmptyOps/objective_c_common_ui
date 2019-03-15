//
//  restKitWrapper.m
//  XClient
//
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "restKitWrapper.h"
#import "Venue.h"
#import "config.h"
#import <AFNetworking/AFNetworking.h>

@implementation restKitWrapper

static restKitWrapper *restKitWrapperSingleton;
NSMutableDictionary *downloadReceivedData;
NSMutableDictionary *downloadExpectedBytes;
NSMutableDictionary *downloadConnections;
NSMutableDictionary *downloadProgressBars;
NSMutableDictionary *downloadSavePath;
NSMutableDictionary *downloadCallbackDict;

+(restKitWrapper *) singleton
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        restKitWrapperSingleton = [[restKitWrapper alloc] init];
        
        [restKitWrapperSingleton configureRestKit];
    }
    
    return restKitWrapperSingleton;
}

/**
 *  configures REST Kit wrapper instance
 */
- (void) configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:[[config singleton] REST_URL]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    //initialize RestKit
    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    //
    downloadReceivedData = [[NSMutableDictionary alloc] init];
    downloadExpectedBytes = [[NSMutableDictionary alloc] init];
    downloadConnections = [[NSMutableDictionary alloc] init];
    downloadProgressBars = [[NSMutableDictionary alloc] init];
    downloadSavePath = [[NSMutableDictionary alloc] init];
    downloadCallbackDict = [[NSMutableDictionary alloc] init];
}

/**
 Calls REST server controller for specified href with href params.
 */
- (void)restToCallWithMapping:(NSString *)controller
                         href:(NSString *)href
                   hrefParams:(NSString *)hrefParams
                   formParams:(NSMutableDictionary *)formParams
                      success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *result))success
                      failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
                   formMethod:(NSInteger)formMethod
{
    
    //setup object mappings
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromArray:@[@"res"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"rest/rest_home/menu"
                                                keyPath:@"response"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    NSDictionary *queryParams = @{@"ll" : @"test",
                                  @"client_id" : @"test",
                                  @"client_secret" : @"test",
                                  @"categoryId" : @"4bf58dd8d48988d1e0931735",
                                  @"v" : @"20140118"};
    
    [self.objectManager getObjectsAtPath:@"rest/rest_home/menu"
                              parameters:queryParams
                                 success: success
                                 failure: failure];
}

/**
 Calls REST server controller for specified href with href params.
 */
- (void)restToCall:(NSString *)controller
              href:(NSString *)href
        hrefParams:(NSString *)hrefParams
        formParams:(NSMutableDictionary *)formParams
           success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *result))success
           failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
        formMethod:(NSInteger)formMethod
         retry_cnt: (int) retry_cnt
{
    NSLog(@"postpram1%@",formParams);
    retry_cnt++;
    
    /**
     *  empty mapping
     */
    RKObjectMapping * emptyMapping = [RKObjectMapping mappingForClass:[NSNull class]];
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:emptyMapping
                                                                                             method:formMethod
                                                                                        pathPattern:[NSString stringWithFormat:@"%@/%@", controller, href] keyPath:nil
                                                                                        statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    /**
     *  set empty response descriptor
     */
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    if( formMethod == RKRequestMethodGET )
    {
        NSLog(@" restUri %@ ", [[config singleton] restUri:[NSString stringWithFormat:@"%@/%@", controller, href] withQuery:hrefParams]);
        
        [self.objectManager getObjectsAtPath:[[config singleton] restUri:[NSString stringWithFormat:@"%@/%@", controller, href] withQuery:hrefParams]
                                  parameters:formParams
                                     success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                         success(operation, mappingResult);
                                     }
                                     failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                                         //if time out or 500 error than retry upto limit
                                         if( true || [error code] )
                                         {
                                             if( retry_cnt <= (REST_RETRY_LIMIT_FOR_TIMEOUT+1) )
                                             {
                                                 [self restToCall:controller href:href hrefParams:hrefParams formParams:formParams success:success failure:failure formMethod:formMethod retry_cnt:retry_cnt];
                                                 return;
                                             }
                                         }
                                         
                                         failure(operation,error);
                                     }];
    }
    else
    {
        [self.objectManager postObject:nil path:[[config singleton] restUri:[NSString stringWithFormat:@"%@/%@", controller, href] withQuery:hrefParams] parameters:formParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            success(operation, mappingResult);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
    }
}

/**
 Calls REST server controller for specified href with href params.
 */
- (void)restToCallNew:(NSString *)controller
                 href:(NSString *)href
           hrefParams:(NSString *)hrefParams
           formParams:(NSMutableDictionary *)formParams
              success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *result))success
              failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
           formMethod:(NSInteger)formMethod
{
    NSLog(@"postpram2%@",formParams);
    /**
     *  empty mapping
     */
    RKObjectMapping * emptyMapping = [RKObjectMapping mappingForClass:[NSNull class]];
    RKResponseDescriptor * responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:emptyMapping
                                                                                             method:formMethod
                                                                                        pathPattern:[NSString stringWithFormat:@"%@/%@", controller, href] keyPath:nil
                                                                                        statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    /**
     *  set empty response descriptor
     */
    [self.objectManagerNew addResponseDescriptor:responseDescriptor];
    
    if( formMethod == RKRequestMethodGET )
    {
        NSLog(@" restUriNew %@ ", [[config singleton] restUri:[NSString stringWithFormat:@"%@/%@", controller, href] withQuery:hrefParams]);
        
        [self.objectManagerNew getObjectsAtPath:[[config singleton] restUri:[NSString stringWithFormat:@"%@/%@", controller, href] withQuery:hrefParams]
                                     parameters:formParams
                                        success: success
                                        failure: failure];
    }
    else
    {
        [self.objectManagerNew postObject:nil path:[[config singleton] restUri:[NSString stringWithFormat:@"%@/%@", controller, href] withQuery:hrefParams] parameters:formParams success:success failure:failure];
    }
}

/**
 * upload image
 **/
- (void) uploadImage :(NSData*) image
          controller :(NSString *)controller
                 href:(NSString *)href
           hrefParams:(NSString *)hrefParams
           formParams:(NSMutableDictionary *)formParams
      file_field_name:(NSString*) file_field_name
            file_name:(NSString*) file_name
            mime_type:(NSString*) mime_type
              success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *result))success
              failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    // Serialize the Article attributes then attach a file
    NSObject *article = [NSObject new];
    
    //
    if( image == nil || [image isKindOfClass:[NSNull class]] )
    {
        //An error occurred
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Upload data is null" forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:@"myDomain" code:100 userInfo:errorDetail];
        failure(nil, err);
        return;
    }
    
    //show app network activity inidicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableURLRequest *request = [self.objectManager multipartFormRequestWithObject:article method:RKRequestMethodPOST path:[[config singleton] restUri:[NSString stringWithFormat:@"%@/%@", controller, href] withQuery:hrefParams] parameters:formParams constructingBodyWithBlock:^(id<AFRKMultipartFormData> formData)
                                    {
                                        NSLog(@"postpram upload image: %@",formParams);
                                        [formData appendPartWithFileData:image
                                                                    name:file_field_name
                                                                fileName:file_name  //@"photo.png"
                                                                mimeType:mime_type  //@"image/png"
                                         ];
                                    }];
    
    request.timeoutInterval = 1800.0;
    
    RKObjectRequestOperation *operation = [self.objectManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                           {
                                               //show app network activity inidicator
                                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                               
                                               if( success )
                                               {
                                                   success(operation, mappingResult);
                                               }
                                           } failure:^(RKObjectRequestOperation *operation, NSError *error)
                                           {
                                               //show app network activity inidicator
                                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                                               //
                                               NSDictionary *resObj;
                                               if( operation != nil )
                                               {
                                                  resObj = [self jsonStrToObj:operation];
                                                   
                                                   if( [[resObj objectForKey:@"type"] isEqualToString:@"success"] )
                                                   {
                                                       success(operation, nil);
                                                       return;
                                                   }
                                               }
                                               
                                               if( failure )
                                               {
                                                   failure(operation, error);
                                               }
                                           }];
    
    [self.objectManager enqueueObjectRequestOperation:operation];
    
}

-(NSDictionary*) jsonStrToObj:(RKObjectRequestOperation *) operation
{
    NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingMutableLeaves error:nil];
    
    return resObj;
}

-(void) dictionary:(NSMutableDictionary *)dictMutable key:(NSString *)key value:(id)value
{
    [dictMutable setObject:value forKey:key];
}

@end
