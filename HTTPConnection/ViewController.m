//
//  ViewController.m
//  HTTPConnection
//
//  Created by ios on 02/03/15.
//  Copyright (c) 2015 Jhonsore. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HTTPConnection *connection;
    //criando conexão com o banco de dados
    connection = [[HTTPConnection alloc] init];
    connection.delegate = self;
    
    NSString *kHost = @"http://www.your-host.com/";//your host
    NSString *kWsUpdateData = @"ws-connection.php";//your file
    NSString *name = @"jhonsore";//some data
    NSString *age = @"29";//some data
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kHost,kWsUpdateData];
    NSString *post = [NSString stringWithFormat:@"name=%@&age=%@",name,age];
    
    [connection sendAsynchronousRequest:url withPost:post];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connectionFinishedWithData:(id)data{
    NSLog(@"%@", data);
}

@end
