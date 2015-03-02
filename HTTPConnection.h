//
//  HTTPConnection.h
//  Bencao
//
//  Created by ios on 25/04/14.
//  Copyright (c) 2014 Backstage Digital. All rights reserved.
// http://snippets.aktagon.com/snippets/350-how-to-make-asynchronous-http-requests-with-nsurlconnection
//http://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/

#import <Foundation/Foundation.h>

@protocol HTTPConnectionDelegate <NSObject>
@required

- (void) connectionFinishedWithData:(NSData *) data;

@end

@interface HTTPConnection : NSObject < NSURLConnectionDataDelegate > {
    
    id <HTTPConnectionDelegate> delegate;
    NSMutableData *responseData;
}

@property (retain) id delegate;

- (void) sendAsynchronousRequest:(NSString *) url withPost:(NSString *) post;

@end
