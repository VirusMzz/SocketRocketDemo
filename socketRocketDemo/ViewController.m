//
//  ViewController.m
//  socketRocketDemo
//
//  Created by V on 8/7/2016.
//  Copyright © 2016 V. All rights reserved.
//

#import "ViewController.h"
#import <SRWebSocket.h>

@interface ViewController ()<SRWebSocketDelegate>
@property (weak, nonatomic) IBOutlet UILabel *screen;

@property (weak, nonatomic) IBOutlet UITextField *inputTX;
@property (strong, nonatomic)SRWebSocket *socket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.socket open];


}

- (IBAction)send:(id)sender {
    
    if (self.socket) {
        
        NSString *message = self.inputTX.text;
        [self.socket send:message];
    }
    else{
    
        return;
    }
}


- (IBAction)disconnect:(UIButton *)sender {

    [_socket close];
    _socket = nil;

}

- (IBAction)connect:(id)sender {
    
    /*
     SR_CONNECTING   = 0,
     SR_OPEN         = 1,
     SR_CLOSING      = 2,
     SR_CLOSED       = 3,
     */
    
    _socket.delegate = nil;
    [_socket close];
    
    _socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"http://127.0.0.1:8080/echo"]];
    _socket.delegate = self;

    [_socket open];
}

#pragma mark -- Delegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{

    NSLog(@"message = %@", message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.screen.text = message;
    });
    
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{

    NSLog(@"open");
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{

    NSLog(@"%@",error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{

    NSLog(@"code = %ld", code);
    NSLog(@"reason = %@", reason);
    NSLog(@"wasClean = %d", wasClean);
    
    NSLog(@"%ld",self.socket.readyState);
    _socket.delegate = nil;
    _socket = nil;
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{

    NSLog(@"%@",pongPayload);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
