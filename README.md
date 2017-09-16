# JJHRequest


UTRequestManager是一个iOS的网络请求框架，通过解耦请求者和响应者简化多重网络传递。  

#### 支持单一请求
1. 数据请求，支持GET和POST请求
2. 文件下载请求，并显示下载进度
3. 文件上传请求，并显示上传经典

#### 支持多重网络请求
多重网络请求是指多个单一请求的串行或者并行，包括：
1. 嵌套请求，请求二可以在请求一的结果基础上发送
2. 顺序请求，先发送请求一再发送请求二，返回结果保证请求顺序
3. 并发请求，同时发送请求一和请求二，返回结果保证请求顺序

#### 请求管理
在发送单一请求或者多重请求时，会自动显示loading提示框，请求结束后会自动关闭。在请求过程中，如果手动关闭loading提示框，会取消请求。


## 安装
在Podfile文件添加JJHRequest库
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"

target 'TargetName name' do
    pod 'UTRequest', '~> 1.0.0'
end
```

然后，执行下面命令：  

```ruby
pod 'JJHRequest'
```

在OC文件中添加：  

```
#import <JJHRequest/JJHRequest.h>
```


## 示例
#### JJHNetworkRequest 配置方法
1. request方法，创建一个JJHNetworkRequst对象
2. url方法，设置url链接
3. method方法，设置请求方式，比如GET或者POST
4. dataClass方法，设置请求返回数据的类型
5. addParam：value方法，设置请求参数
6. data：faiure方法，数据请求的成功和失败回调
7. download：faiure方法，下载请求的成功和失败回调
8. upload：faiure方法，上传请求的成功和失败回调

#### 数据请求

```
[[[[[[[JJHNetworkRequest request] url:url] method:POST] 
        dataClass:@"User"]
       addParam:@"name" value:@"Chris"]
      addParam:@"password" value:@"123456"]
     data:^(id result) {                                    
         NSLog(@"%@", result);
     } failure:^(NSUInteger code, NSString *errorMessage) { 
         NSLog(@"%zi , %@", code, errorMessage);
         
     }];
```

#### 文件下载
```
[[[[[JJHNetworkRequest request] url:url] method:GET]
      downloadFilePath:@"file:///Users/xxx/Library/"]
     download:^(NSString *filePath) {
         NSLog(@"filePath : %@", filePath);
     } failure:^(NSUInteger code, NSString *errorMessage) {
         NSLog(@"code:%zi, message:%@", code, errorMessage);
     }];
```

#### 文件上传

```
NSString *url = [NSString stringWithFormat:@"%@security/security_uploadList.action", BASE_PATH];

// 获取文件上传数据
NSString *dirPath=@"/Users/xxx/Documents/uploadFile/";
NSFileManager *myFileManager=[NSFileManager defaultManager];
NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:dirPath];

NSMutableDictionary *fileParam = [NSMutableDictionary new];
NSString *filePath;
while((filePath=[myDirectoryEnumerator nextObject])!=nil){
    
    NSLog(@"%@",filePath);
    fileParam[filePath] = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@%@", dirPath, filePath]];
}

// 上传文件
[[[[[[JJHNetworkRequest request] url:url] method:POST] dataClass:@"User"] uploadFileParam:fileParam] upload:^(id result) {
    NSLog(@"%@", result);
} failure:^(NSUInteger code, NSString *errorMessage) {
    NSLog(@"%zi , %@", code, errorMessage);
}];
```

#### JJHNetworkRequestManager
JJHNetworkRequestManager是JJHNetworkRequest的管理器，多重网络请求是指多个单一请求的串行或者并行.  
1. managerWithRequest方法，初始化管理器
2. nest方法，嵌套一个请求
3. nestSuccess：failure方法，嵌套请求的成功和失败回调方法
4. sequence方法，顺序一个请求
5. sequenceSuccess：failure方法，顺序请求的成功和失败回调方法
6. merge方法，并发一个请求
7. mergeSuccess：failure方法，并发请求的成功和失败回调方法

#### 嵌套请求

```
JJHNetworkRequest *request = [[[[[JJHTNetworkRequest request] url:url] method:POST]
                                    dataClass:@"User"]
                                    progressMessage:@"请求一" ]
                                    dataRequest];  
    
    [[[JJHNetworkRequestManager managerWithRequest:request] nest:^id(id value) {
        NSLog(@"map-----%@", value);
        return [[[[[[UTNetworkRequest request] url:url2] method:POST]
                    dataClass:@"User"]
                    progressMessage:@"请求二" ]
                    dataRequest];
    }] nestSuccess:^(id result) {
        NSLog(@"subscribe-----%@", result);
    } failure:^(NSUInteger code, NSString *errorMessage) {
        NSLog(@"%zi , %@", code, errorMessage);
    }];
```

#### 顺序请求

```
JJHNetworkRequest *request1 = [[[[[[JJHNetworkRequest request] url:url] method:POST]
                                  dataClass:@"User"]
                                 progressMessage:@"请求一" ]
                                dataRequest];
JJHNetworkRequest *request2 = [[[[[[UTNetworkRequest request] url:url2] method:POST]
                                  dataClass:@"User"]
                                 progressMessage:@"请求二" ]
                                dataRequest];


[[[JJHNetworkRequestManager managerWithRequest:request1] sequence:request2]sequenceSuccess:^(NSArray *resultList) {
    NSLog(@"顺序请求成功:%zi", [resultList count]);
} failure:^(NSUInteger code, NSString *errorMessage) {
    NSLog(@"%zi , %@", code, errorMessage);
}];
```

#### 并发请求

```
JJHNetworkRequest *request1 = [[[[[[JJHNetworkRequest request] url:url] method:POST]
                                      dataClass:@"User"]
                                     progressMessage:@"请求一" ]
                                    dataRequest];
JJHNetworkRequest *request2 = [[[[[[JJHNetworkRequest request] url:url2] method:POST]
                                  dataClass:@"User"]
                                 progressMessage:@"请求二" ]
                                dataRequest];
                                    
[[[JJHNetworkRequestManager managerWithRequest:request1] merge:request2] mergeSuccess:^(NSArray *resultList) {
        
        NSLog(@"并发请求成功:%zi", [resultList count]);
    } failure:^(NSUInteger code, NSString *errorMessage) {
        NSLog(@"%zi , %@", code, errorMessage);
    }];
```

## Author

Anima18, 591151451@qq.com

## License

JJHRequest is available under the MIT license. See the LICENSE file for more info.
