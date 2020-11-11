//
//  LJ_FileInfo.m
//  FileDirectoryTool
//
//  Created by nuomi on 2017/2/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "LJ_FileInfo.h"
#include <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation LJ_FileInfo


CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

+ (NSString*)getFileMD5WithPath:(NSString*)path
{
    if (!path) {
        return @"";
    }
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

+ (NSMutableArray*)searchAllFileFromRightDirPath:(NSString *)rightDirPath{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExists = [fileManager fileExistsAtPath:rightDirPath isDirectory:&isDir];
    if (!isExists || !isDir) {
        return nil;
    }
    
    NSMutableArray * subFileNamesArr = [NSMutableArray array];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:rightDirPath];
    for (NSString *fileName in enumerator){
        if (fileName && [fileName hasPrefix:@"."] == NO && [fileName containsString:@"/"] == NO) {
            /*
            NSFileCreationDate = "2017-02-09 09:04:50 +0000";
            NSFileExtensionHidden = 0;
            NSFileGroupOwnerAccountID = 20;
            NSFileGroupOwnerAccountName = staff;
            NSFileModificationDate = "2017-02-09 09:04:50 +0000";
            NSFileOwnerAccountID = 501;
            NSFilePosixPermissions = 493;
            NSFileReferenceCount = 2;
            NSFileSize = 68;//文件大小
            NSFileSystemFileNumber = 13723856;
            NSFileSystemNumber = 16777218;
            NSFileType = NSFileTypeDirectory;
            canDel = 1;
            title = Documents;*/
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
            //获取文件属性
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:[rightDirPath stringByAppendingPathComponent:fileName] error:nil];
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:fileAttributes];
            [dict setObject:fileName forKey:@"title"];
            [dict setObject:[NSNumber numberWithBool:[[NSFileManager defaultManager] isDeletableFileAtPath:[NSHomeDirectory() stringByAppendingPathComponent:fileName]]] forKey:@"canDel"];
            if ([[dict objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]) {
                [dict setObject:@"Dir" forKey:@"FileType"];
            }else{
                [dict setObject:[self judgeFileTypeWithPath:[rightDirPath stringByAppendingPathComponent:fileName]] forKey:@"FileType"];
            }
            [subFileNamesArr addObject:dict];
        }
    }
    return subFileNamesArr;
}

+ (NSString *)judgeFileTypeWithPath:(NSString *)filePath{
    if ([filePath hasSuffix:@".note"]) {
        return  @"未知文件类型";
    }
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    if (data.length<2) {
        return  @"未知文件类型";
    }
    int char1 = 0 ,char2 =0 ;
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    [data getBytes:&char2 range:NSMakeRange(1, 1)];
    data = nil;
    NSString *numStr = [NSString stringWithFormat:@"%i%i",char1,char2];
    
    if ([numStr isEqualToString:@"255216"]) {
        return @"image/jpeg";
    }else if ([numStr isEqualToString:@"7173"]) {
        return @"image/gif";
    }else if ([numStr isEqualToString:@"6677"]) {
        return @"image/bmp";
    }else if ([numStr isEqualToString:@"13780"]) {
        return @"image/png";
    }else if ([numStr isEqualToString:@"7790"]) {
        return @"exe";
    }else if ([numStr isEqualToString:@"8297"]) {
        return @"rar";
    }else if ([numStr isEqualToString:@"8075"]) {
        return @"zip";
    }else if ([numStr isEqualToString:@"55122"]) {
        return @"7z";
    }else if ([numStr isEqualToString:@"6063"]) {
        return @"xml";
    }else if ([numStr isEqualToString:@"6033"]) {
        return @"html";
    }else if ([numStr isEqualToString:@"119105"]) {
        return @"js";
    }else if ([numStr isEqualToString:@"102100"]) {
        return @"txt";
    }else if ([numStr isEqualToString:@"255254"]) {
        return @"sql";
    }else{
        return @"未知文件类型";
    }
}




@end
