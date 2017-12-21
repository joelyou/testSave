
#import <Foundation/Foundation.h>

@interface FESandbox : NSObject

+ (NSString *)appPath;		// 程序目录，不能存任何东西
+ (NSString *)docPath;		// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPath;      // 资源目录
+ (NSString *)libPrefPath;	// 配置目录，配置文件存这里
+ (NSString *)libCachePath;	// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除 手机存储空间不足是可能会被删除
+ (NSString *)tmpPath;		// 缓存目录，APP退出后，系统可能会删除这里的内容

+ (BOOL)fileExistsAtPath:(NSString*)path;//文件是否存在

+ (BOOL)createDirectoryAtPath:(NSString *)path;//如果不存在此文件夹 创建文件夹

+ (BOOL)deleteDirectory:(NSString*)path;

//单位 字节   / (1024*1024.0) = M
//获取文件大小
+ (long long)fileSizeAtPath:(NSString*) filePath;

//获取文件夹大小
+ (long long)folderSizeAtPath:(NSString*)folderPath;

//手机剩余空间大小
+ (long long)freeSpace;

//总大小
+ (long long)totalSpace;




NSString* FEPathForBundleResource(NSBundle* bundle, NSString* relativePath);

@end
