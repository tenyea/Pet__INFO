//
//  DataCenter.m
//  东北新闻网
//
//  Created by tenyea on 13-12-23.
//  Copyright (c) 2013年 佐筱猪. All rights reserved.
//

#import "DataCenter.h"
#import "FileUrl.h"
static DataCenter *sigleton = nil;
@implementation DataCenter

//获取cache大小
- (NSUInteger)cacheSize{
        float size = [DataCenter fileSizeForDir:[FileUrl getCacheFile]];
    return size;
}

//获取路径下文件大小
+(float)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size =0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        //判断是否是文件夹
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize;
        }
        else
        {
            size+=[self fileSizeForDir:fullPath];
        }
    }
    return size;
}
//- (void)cacheData;
//清空缓存
- (void)cleanCache{
    NSString *cachesDir = [FileUrl getCacheFile];
    [DataCenter deleteAllFilesInDir:cachesDir];
}
//按照目录删除文件
+(void) deleteAllFilesInDir:(NSString*)path {
	NSError* err=nil;

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        //判断是否是文件夹
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            [fileManager removeItemAtPath:fullPath error:&err];
        }
        else
        {
            [self deleteAllFilesInDir:fullPath];
        }
    }
}
//nsstring 与nsdate 互转
+(NSString *)dateTOString :(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
+(NSDate *)StringTODate :(NSString *)strDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    return date;
}
//比如说有当前文章的发表时间，那么theDate就是这个时间，然后这个方法返回的字符串就是你需要的时间，几分钟前，或者几小时前，具体的需求再重新修改就可以了
+ (NSString*)intervalSinceNow: (NSString*) theDate
{
    NSDateFormatter*date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString*timeString=@"";
    NSTimeInterval cha=now-late;
    //发表在一小时之内
    if(cha/3600<1) {
        if(cha/60<1) {
            timeString = @"刚刚";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];

        }
        
    }
    //在一小时以上24小以内
    else if(cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    //发表在24以上10天以内
    else if(cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    //发表时间大于10天
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray*array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
        timeString = [timeString substringWithRange:NSMakeRange(5, [timeString length]-5)];
    }
    return timeString;
}




//实例化
+(DataCenter *)sharedCenter{
    
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[DataCenter alloc] init];
        }
    }
    return sigleton;

}
//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}



@end
