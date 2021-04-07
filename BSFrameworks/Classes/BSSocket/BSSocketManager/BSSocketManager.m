//
//  BSSocketManager.m
//  BSFrameworks
//
//  Created by 叶一枫 on 2021/3/29.
//

////socket 创建并初始化 socket，返回该 socket 的文件描述符，如果描述符为 -1 表示创建失败。
//int socket(int addressFamily, int type,int protocol)
////关闭socket连接
//int close(int socketFileDescriptor)
////将 socket 与特定主机地址与端口号绑定，成功绑定返回0，失败返回 -1。
//int bind(int socketFileDescriptor,sockaddr *addressToBind,int addressStructLength)
////接受客户端连接请求并将客户端的网络地址信息保存到 clientAddress 中。
//int accept(int socketFileDescriptor,sockaddr *clientAddress, int clientAddressStructLength)
////客户端向特定网络地址的服务器发送连接请求，连接成功返回0，失败返回 -1。
//int connect(int socketFileDescriptor,sockaddr *serverAddress, int serverAddressLength)
////使用 DNS 查找特定主机名字对应的 IP 地址。如果找不到对应的 IP 地址则返回 NULL。
//hostent* gethostbyname(char *hostname)
////通过 socket 发送数据，发送成功返回成功发送的字节数，否则返回 -1。
//int send(int socketFileDescriptor, char *buffer, int bufferLength, int flags)
////从 socket 中读取数据，读取成功返回成功读取的字节数，否则返回 -1。
//int receive(int socketFileDescriptor,char *buffer, int bufferLength, int flags)
////通过UDP socket 发送数据到特定的网络地址，发送成功返回成功发送的字节数，否则返回 -1。
//int sendto(int socketFileDescriptor,char *buffer, int bufferLength, int flags, sockaddr *destinationAddress, int destinationAddressLength)
////从UDP socket 中读取数据，并保存发送者的网络地址信息，读取成功返回成功读取的字节数，否则返回 -1 。
//int recvfrom(int socketFileDescriptor,char *buffer, int bufferLength, int flags, sockaddr *fromAddress, int *fromAddressLength)

#import "BSSocketManager.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface BSSocketManager ()

@property (nonatomic,assign)int clientScoket;

@end


@implementation BSSocketManager

+(instancetype)shareManager{
    
    static BSSocketManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BSSocketManager alloc]init];
    });
    
    return manager;
}


static int CreatClientSocket(){
    
    int clientSocket = 0;
    /// 参数：网络类型，数据类型，协议类型
    /// 网络类型：IPv4(AF_INET) 或 IPv6(AF_INET6)。
    /// 数据类型：SOCK_STREAM 或 SOCK_DGRAM。
    /// 协议类型：0是自动选择，如果数据是 STREAM ，协议为TCP ，
    /// 如果 datagram（SOCK_DGRAM） 协议是UDP
    ///
    clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    return clientSocket;
}



-(void)connect{
    
    if (self.clientScoket != 0) {
        [self disConnect];
        self.clientScoket = 0;
    }
    self.clientScoket = CreatClientSocket();

    const char *serverIp = "127.0.0.1";
    short serverPort = 8000;
    
    if (connectToServer(self.clientScoket, serverIp, serverPort) == 0) {
        NSLog(@"Socket连接失败");
        self.clientScoket = 0;
        return;
    }
    NSLog(@"Socket 连接成功");
    [self startMessageReceiveOperation];

}


static int connectToServer(int clientSocket ,const char *serverIp ,short serverPort){
    
    struct sockaddr_in sockadd = {0};
    sockadd.sin_len = sizeof(sockadd);
    sockadd.sin_family = AF_INET;
    
    ///inet_aton是一个计算机函数，功能是将一个字符串IP地址转换为
    ///一个32位的网络序列IP地址。如果这个函数成功，函数的返回值非零，
    ///如果输入地址不正确则会返回零。
    ///使用这个函数并没有错误码存放在errno中，所以它的值会被忽略。
    if (inet_aton(serverIp, &sockadd.sin_addr) == 0) {
        NSLog(@"服务器地址转换失败，请检查服务器地址是否正确");
        return 0;
    }
    
    ///htons是将整型变量从主机字节顺序转变成网络字节顺序，
    ///就是整数在地址空间存储方式变为高位字节存放在内存的低地址处。
    sockadd.sin_port = htons(serverPort);
    
    /// 链接服务器
    if (connect(clientSocket, (struct sockaddr *)&sockadd, sizeof(sockadd)) == 0) {
        return clientSocket;
    }
    return 0;
}



-(void)disConnect{
    if (self.clientScoket != 0) {
        [self sendMessage:@"BSSocket.disconnect"];
        //    close(self.clientScoket);
        //    NSLog(@"客户端断开连接");
    }
}



-(void)sendMessage:(NSString *)message{

    if (self.clientScoket == 0) {
        NSLog(@"socket 已断开连接");
        return;
    }
    NSLog(@"sendMessage:%@",message);
    
    const char *send_Message = [message UTF8String];
    send(self.clientScoket,send_Message,strlen(send_Message),0);
}



-(void)startMessageReceiveOperation{
    
    NSOperationQueue *msgQueue = [[NSOperationQueue alloc]init];
    
    NSInvocationOperation *receiveOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(receiveMessage) object:nil];
    [msgQueue addOperation:receiveOperation];
}


-(void)receiveMessage{
        
    while (1) {
        char receive_message[1024] = {0};
        recv(self.clientScoket, receive_message, sizeof(receive_message), 0);
        NSString *message = [NSString stringWithCString:receive_message encoding:NSUTF8StringEncoding];
        if (message.length>0) {
            [self.delegate receiveMessage:message];
        }
    }
}


@end
