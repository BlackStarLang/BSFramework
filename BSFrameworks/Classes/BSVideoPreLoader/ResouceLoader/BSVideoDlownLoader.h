//
//  BSVideoDlownLoader.h
//  BSFrameworks
//
//  Created by dangdang on 2021/6/16.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol BSVideoDlownLoaderDelegate <NSObject>

@optional

-(void)BSVideoDlownLoaderReceiveResponse:(NSURLResponse *)response dataTaskRequest:(NSURLRequest *)request;

-(void)BSVideoDlownLoaderDidReceiveData:(NSData *)data request:(NSURLRequest *)request;

@end


@interface BSVideoDlownLoader : NSObject

@property (nonatomic , weak) id<BSVideoDlownLoaderDelegate> delegate;

-(void)downLoadWithRequest:(NSURLRequest *)request;

@end



