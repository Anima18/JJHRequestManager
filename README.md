# JJHRequest

[![CI Status](http://img.shields.io/travis/Anima18/JJHRequest.svg?style=flat)](https://travis-ci.org/Anima18/JJHRequest)
[![Version](https://img.shields.io/cocoapods/v/JJHRequest.svg?style=flat)](http://cocoapods.org/pods/JJHRequest)
[![License](https://img.shields.io/cocoapods/l/JJHRequest.svg?style=flat)](http://cocoapods.org/pods/JJHRequest)
[![Platform](https://img.shields.io/cocoapods/p/JJHRequest.svg?style=flat)](http://cocoapods.org/pods/JJHRequest)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 功能介绍

UTRequestManager是一个iOS的网络请求框架，通过解耦请求者和响应者简化多重网络传递，这里的网络请求单一的网络请求。  

单一的网络请求包括：
1. 数据请求
2. 文件下载请求
3. 文件上传请求

多重网络请求是指多个单一请求的串行或者并行，包括：
1. 嵌套请求
2. 顺序请求
3. 并发请求

```ruby
pod 'JJHRequest'
```

## 使用
### 添加JJHRequest库
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"

target 'project name' do
    pod 'UTRequest', '~> 0.1.2'
end
```

### 示例
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
