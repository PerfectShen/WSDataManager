//
//  WSDataManager.h
//
//  Created by Seeulater on 15/1/21.
//  Copyright (c) 2015年 Senro Wong. All rights reserved.
//

/*
   本地存储的类
    存储的时候 string1/string2/string3/... 就可以直接创建多层次文件夹 并保存数据。
 
    When you store the string1/string2/string3/... You can directly create a multi - level folder and save the data.
 
   技术支持   840787626@qq.com
 */

#import <Foundation/Foundation.h>

#define GroupImage @"GroupImage"
#define CurrLoginUserName   [AppCommon shareAppCommon].currentUser.m_username

typedef enum{
    
    LocalTypeDocument = 0,
    LocalTypeLibrary = 1,
    LocaltypeTmp = 2
    
}LocalType;

//保存本地数据

@interface WSDataManager : NSObject

+ (instancetype)shareLocalDataManager;


//往本地 存数据
- (void)saveData:(NSData *)data path:(NSString *)path type:(LocalType )type;

- (void)saveDictionary:(NSDictionary *)dictionary path:(NSString *)path type:(LocalType )type;

//往本地存图片
- (void)saveImage:(UIImage *)image path:(NSString *)path type:(LocalType )type;


//从本地 取数据
- (NSData *)getDataFromPath:(NSString *)path type:(LocalType )type;

- (NSDictionary *)getDictionaryFrompath:(NSString *)path type:(LocalType )type;

- (UIImage *)getImageFrompath:(NSString *)path type:(LocalType )type;





@end
