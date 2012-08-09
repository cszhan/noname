//
//  QWeiboAsyncApi.h
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-18.
//   
//

#import <Foundation/Foundation.h>
#import "QWeiboSyncApi.h"


@interface QWeiboAsyncApi : NSObject {

}

- (NSURLConnection *)getHomeMsgWithConsumerKey:(NSString *)aConsumerKey
						 consumerSecret:(NSString *)aConsumerSecret 
						 accessTokenKey:(NSString *)aAccessTokenKey 
					  accessTokenSecret:(NSString *)aAccessTokenSecret 
							 resultType:(ResultType)aResultType 
							  pageFlage:(PageFlag)aPageFlag 
								nReqNum:(NSInteger)aReqNum 
							   delegate:(id)aDelegate;

- (NSURLConnection *)publishMsgWithConsumerKey:(NSString *)aConsumerKey 
						 consumerSecret:(NSString *)aConsumerSecret 
						 accessTokenKey:(NSString *)aAccessTokenKey 
					  accessTokenSecret:(NSString *)aAccessTokenSecret 
								content:(NSString *)aContent 
							  imageFile:(NSString *)aImageFile 
							 resultType:(ResultType)aResultType 
							   delegate:(id)aDelegate;

- (NSURLConnection *)publishMsgWithConsumerKey:(NSString *)aConsumerKey 
                                consumerSecret:(NSString *)aConsumerSecret 
                                accessTokenKey:(NSString *)aAccessTokenKey 
                             accessTokenSecret:(NSString *)aAccessTokenSecret 
                                       content:(NSString *)aContent 
                                     imageData:(NSData *)aImageFileData 
                                    resultType:(ResultType)aResultType 
                                      delegate:(id)aDelegate ;

- (NSURLConnection *)getUserInfoWithConsumerKey:(NSString *)aConsumerKey 
                                 consumerSecret:(NSString *)aConsumerSecret 
                                 accessTokenKey:(NSString *)aAccessTokenKey 
                              accessTokenSecret:(NSString *)aAccessTokenSecret 
                                     resultType:(ResultType)aResultType
                                       delegate:(id)aDelegate;

@end
