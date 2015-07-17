



#import "WSDataManager.h"
#import <JSONKit.h>

@interface WSDataManager ()
{
    NSString *m_documentPath;
    NSString *m_libraryPath;
    NSString *m_tmpPath;
}
@end

@implementation WSDataManager

+ (instancetype)shareLocalDataManager{
    
    static WSDataManager *s_localDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_localDataManager = [[WSDataManager alloc ] init];
    });
    
    return s_localDataManager;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self _initialize];
    }
    
    return self;
}
#pragma mark -- 私有方法 ---

//获取 本地 沙盒的三个 文件夹 路径
- (void)_initialize{
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    m_documentPath = [paths1 objectAtIndex:0];
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    m_libraryPath = [paths2 objectAtIndex:0];
    
    m_tmpPath = NSTemporaryDirectory();
}


- (NSString *)_getPathWithSubPath:(NSString *)subPath type:(LocalType )type{
    
   return [self _getDictorAndpathWithPath:subPath type:type];
    
}

- (NSString *)_getPathWhenGetData:(NSString *)subpath type:(LocalType )type{
    
    NSString *realpath;
    switch (type) {
        case LocalTypeDocument:
        {
            realpath = m_documentPath;
        }
            break;
        case LocalTypeLibrary:
        {
            realpath = m_libraryPath;
        }
            break;
        case LocaltypeTmp:
        {
            realpath = m_tmpPath;
        }
            break;
            
        default:
            realpath = m_documentPath;
            break;
    }
    
    return [realpath stringByAppendingPathComponent:subpath];

}


//如果是多级 的 则会创建相对应的文件夹
- (NSString *)_getDictorAndpathWithPath:(NSString *)path type:(LocalType )type{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *hostPath;
    switch (type) {
        case LocalTypeDocument:
        {
            hostPath = m_documentPath;
        }
            break;
        case LocalTypeLibrary:
        {
            hostPath = m_libraryPath;
        }
            break;
        case LocaltypeTmp:
        {
            hostPath = m_tmpPath;
        }
            break;
            
        default:
            hostPath = m_documentPath;
            break;
    }
    
    NSArray *array = [path componentsSeparatedByString:@"/"];
    if(array.count > 1)
    {
        NSString *fileDiro = [array firstObject];
        for (NSInteger i = 1; i < array.count - 1; i ++ ) {
            
            fileDiro = [fileDiro stringByAppendingString:[NSString stringWithFormat:@"/%@",[array objectAtIndex:i]]];
        }
        
        NSString *realFileDoro = [hostPath stringByAppendingPathComponent:fileDiro];
        
        BOOL _isDire;
        BOOL  _isExistDire = [fileManager fileExistsAtPath:realFileDoro isDirectory:&_isDire];
        if (!_isExistDire) {
            
            [fileManager createDirectoryAtPath:realFileDoro withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *realPath = [realFileDoro stringByAppendingPathComponent:[array lastObject]];
        return realPath;
    }else{
        
        return path;
    }
   
    
    
}

#pragma mark -- 公有方法 ---

//往本地 存数据
- (void)saveData:(NSData *)data path:(NSString *)path type:(LocalType )type{
    
    NSString *realPath = [self _getPathWithSubPath:path type:type];
    [data writeToFile:realPath atomically:YES];
}

- (void)saveDictionary:(NSDictionary *)dictionary path:(NSString *)path type:(LocalType )type{
    
    NSData *data = [dictionary JSONData];
    [self saveData:data path:path type:type];
}

- (void)saveImage:(UIImage *)image path:(NSString *)path type:(LocalType)type{
    
    NSData *data = UIImagePNGRepresentation(image);
    [self saveData:data path:path type:type];
}

//从本地 取数据
- (NSData *)getDataFromPath:(NSString *)path type:(LocalType )type{
    
    NSString *realPath = [self _getPathWhenGetData:path type:type];
    NSData *data = [[NSData alloc] initWithContentsOfFile:realPath];
    return data;
}

- (NSDictionary *)getDictionaryFrompath:(NSString *)path type:(LocalType )type{
    NSData *data = [self getDataFromPath:path type:type];
    NSDictionary *dictionary  = [data objectFromJSONData];
    return dictionary;
    
}

- (UIImage *)getImageFrompath:(NSString *)path type:(LocalType)type{
    
    NSData *data = [self getDataFromPath:path type:type];
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
}

@end
