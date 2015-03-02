//
//  HTTPConnection.m
//  Bencao
//
//  Created by ios on 25/04/14.
//  Copyright (c) 2014 Backstage Digital. All rights reserved.
//

//quantidade de erros para conexão
#define kErrorTimes 3
#define kClassName @"HTTPConnection"

#import "HTTPConnection.h"

@implementation HTTPConnection{
    
    NSString *postRequest;
    NSString *urlRequest;
    int countErrorTimes;
    
    //checa se houve algum erro na conexão
    //- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
    BOOL errorWithConnection;
    
}

@synthesize delegate;

- (id) init{
    if ((self = [super init])) {
        countErrorTimes = 0;
        errorWithConnection = NO;
    }
    return self;
}

- (void) sendAsynchronousRequest:(NSString *) url_ withPost:(NSString *) post_{
    responseData = [[NSMutableData alloc] init];
    
    postRequest = post_;
    urlRequest = url_;
    
    NSString *post = post_;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
     
     NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
     NSMutableURLRequest *request =
     [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_]
     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
     timeoutInterval:20.0];
    
     [request setHTTPMethod:@"POST"];
     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:postData];
    
     // create the connection with the request
     // and start loading the data
     // note that the delegate for the NSURLConnection is self, so delegate methods must be defined in this file
     NSURLConnection *theConnection = [[NSURLConnection alloc]
     initWithRequest:request
     delegate:self];
    
     if (theConnection) {
         NSLog(@"%@ : conexão estabelecida para url : %@, com dados %@",kClassName, url_, post_);
     } else {
         // Inform the user that the connection failed.
         NSLog(@"********** connection failed :(");
     }
}


- (void) processComplete:(NSData *) data{
    if ([self.delegate respondsToSelector:@selector(connectionFinishedWithData:)]) {
		NSLog(@"%@ : Calling the delegate", kClassName);
        [[self delegate] connectionFinishedWithData:(id) data];
	}else{
        NSLog(@"%@ : cannot call delegate ", kClassName);
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    [self asynchronousRequest:responseData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@ : The request has failed for some reason : %@",kClassName,error);
    errorWithConnection = YES;
    [self asynchronousRequest:responseData];
}

-(void) asynchronousRequest:(NSData *) data_{
    id result;
    
    if(errorWithConnection == YES){
         result = [NSDictionary dictionaryWithObjectsAndKeys:@"false",@"status",@"ocorreu um erro, tente novamente",@"mensagem", nil];
        NSLog(@"error with connection");
        [self processComplete:result];
    }else{
        NSError *err;
        
        result = [NSJSONSerialization JSONObjectWithData:data_ options:kNilOptions error:&err];
        NSLog(@"%@ : %i\n",kClassName, countErrorTimes);
        NSLog(@"%@ : %@\n",kClassName, postRequest);
        NSLog(@"%@ : %@\n",kClassName, urlRequest);
        
        if (result == nil) {
            result = [NSDictionary dictionaryWithObjectsAndKeys:@"false",@"status",@"ocorreu um erro, tente novamente",@"mensagem", nil];
            NSLog(@"%@ : --------dados recebidos----------",kClassName);
            NSLog(@"%@ : dado recebido : %@",kClassName,data_);
            NSLog(@"------------------");
            NSLog(@"%@ ; dados convertidos em json : %@",kClassName ,result);
            
            countErrorTimes++;
            
            if (countErrorTimes < kErrorTimes) {
                [self sendAsynchronousRequest:postRequest withPost:urlRequest];
            }else{
                [self processComplete:result];
            }
        }else{
            [self processComplete:result];
        }
    }
    
}

@end
