//
//  NetworkHandler.h
//  piwigo
//
//  Created by Spencer Baker on 9/10/14.
//  Copyright (c) 2014 CS 3450. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id responseObject);

// Piwigo URLs:
FOUNDATION_EXPORT NSString * const kReflectionGetMethodList;
FOUNDATION_EXPORT NSString * const kPiwigoSessionLogin;
FOUNDATION_EXPORT NSString * const kPiwigoSessionGetStatus;
FOUNDATION_EXPORT NSString * const kCommunitySessionGetStatus;
FOUNDATION_EXPORT NSString * const kPiwigoSessionGetPluginsList;
FOUNDATION_EXPORT NSString * const kPiwigoSessionLogout;

FOUNDATION_EXPORT NSString * const kPiwigoGetInfos;
FOUNDATION_EXPORT NSString * const kPiwigoCategoriesGetList;
FOUNDATION_EXPORT NSString * const kCommunityCategoriesGetList;
FOUNDATION_EXPORT NSString * const kPiwigoCategoriesGetImages;
FOUNDATION_EXPORT NSString * const kPiwigoCategoriesAdd;
FOUNDATION_EXPORT NSString * const kPiwigoCategoriesSetInfo;
FOUNDATION_EXPORT NSString * const kPiwigoCategoriesDelete;
FOUNDATION_EXPORT NSString * const kPiwigoCategoriesMove;
FOUNDATION_EXPORT NSString * const kPiwigoCategoriesSetRepresentative;
FOUNDATION_EXPORT NSString * const kPiwigoCategoriesRefreshRepresentative;

FOUNDATION_EXPORT NSString * const kPiwigoImagesUpload;
FOUNDATION_EXPORT NSString * const kCommunityImagesUploadCompleted;
FOUNDATION_EXPORT NSString * const kPiwigoImagesGetInfo;
FOUNDATION_EXPORT NSString * const kPiwigoImageSetInfo;
FOUNDATION_EXPORT NSString * const kPiwigoImageDelete;

FOUNDATION_EXPORT NSString * const kPiwigoTagsGetList;
FOUNDATION_EXPORT NSString * const kPiwigoTagsGetAdminList;

// Parameter keys:
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamData;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamFileName;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamTitle;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamChunk;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamChunks;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamCategory;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamPrivacy;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamAuthor;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamDescription;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamTags;
FOUNDATION_EXPORT NSString * const kPiwigoImagesUploadParamMimeType;

// HUD tag:
FOUNDATION_EXPORT NSInteger const loadingViewTag;

@interface NetworkHandler : NSObject

+(void)createJSONdataSessionManager;
+(void)createImagesSessionManager;
+(NSString*)encodedURL:(NSString*)originalURL;

+(NSURLSessionTask*)post:(NSString*)path
           URLParameters:(NSDictionary*)urlParams
              parameters:(NSDictionary*)parameters
                progress:(void (^)(NSProgress *))progress
                 success:(void (^)(NSURLSessionTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionTask *task, NSError *error))fail;

+(NSURLSessionTask*)postMultiPart:(NSString*)path
                       parameters:(NSDictionary*)parameters
                         progress:(void (^)(NSProgress *))progress
                          success:(void (^)(NSURLSessionTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionTask *task, NSError *error))fail;

+(NSString*)getURLWithPath:(NSString*)path asPiwigoRequest:(BOOL)piwigo withURLParams:(NSDictionary*)params;

+(void)showConnectionError:(NSError*)error;

@end
