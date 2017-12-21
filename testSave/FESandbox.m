
#import "FESandbox.h"

#include <sys/stat.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <dirent.h>



//递归遍历所有文件
long long folderSizeAtPath(const char* folderPath)
{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL)
    {
        return 0;
    }
    
    struct dirent* child;
    while ((child = readdir(dir))!=NULL)
    {
        if (child->d_type == DT_DIR
            && ((child->d_name[0] == '.' && child->d_name[1] == 0)// 忽略目录 .
                || (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                )
            )
        {
            continue;
        }
        
        NSInteger folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/')
        {
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        
        stpcpy(childPath+folderPathLength, child->d_name);
        
        childPath[folderPathLength + child->d_namlen] = 0;
        
        if (child->d_type == DT_DIR)
        {
            // directory
            folderSize += folderSizeAtPath(childPath); // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0)
            {
                folderSize += st.st_size;
            }
        }
        else if (child->d_type == DT_REG || child->d_type == DT_LNK)
        { // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0)
            {
                folderSize += st.st_size;
            }
        }
    }
    
    return folderSize;
}


@implementation FESandbox

+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)libPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{
	return [NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()];
}

+ (BOOL)fileExistsAtPath:(NSString*)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		return [[NSFileManager defaultManager] createDirectoryAtPath:path
										 withIntermediateDirectories:YES
														  attributes:nil
															   error:nil];
	}
	
	return YES;
}

+(BOOL)deleteDirectory:(NSString*)path
{
    return [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
}

//c函数来实现获取文件大小
+ (long long) fileSizeAtPath:(NSString*) filePath
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

//获取文件夹大小
+ (long long)folderSizeAtPath:(NSString*)folderPath
{
    return folderSizeAtPath([folderPath cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (long long)freeSpace
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    long long freespace = 0;
    if ([paths count] > 0) {
        struct statfs tStats;
        statfs([[paths lastObject] UTF8String], &tStats);
        freespace = tStats.f_bfree * tStats.f_bsize;
    }
    
    return freespace;
}

+ (long long)totalSpace
{
    long long totalSpace = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        struct statfs tStats;
        statfs([[paths lastObject] UTF8String], &tStats);
         totalSpace = tStats.f_blocks * tStats.f_bsize;
    }
    
    return totalSpace;
}


NSString* FEPathForBundleResource(NSBundle* bundle, NSString* relativePath)
{
    NSString* resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

@end
