//
//  WDDataBaseManager.m
//  DataBase-OC
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDB.h"
#import <objc/runtime.h>


static char *wd_id_key = "key";
@implementation NSObject (addId)

- (NSInteger)wd_fmdb_id {
    NSNumber *numberValue = objc_getAssociatedObject(self, wd_id_key);
    return numberValue.integerValue;
}

- (void)setWd_fmdb_id:(NSInteger)wd_fmdb_id {
    objc_setAssociatedObject(self, wd_id_key, @(wd_fmdb_id), OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface DataBaseManager ()

@property (nonatomic, strong) FMDatabase *fmdb;
@property (nonatomic, copy) NSString *tableName;


@end

@implementation DataBaseManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static DataBaseManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[DataBaseManager alloc] init];
    });
    return manager;
}

- (void)createTableWithName:(NSString *)name {
    [self.fmdb open];
    self.tableName = name;
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,model BLOB)", name];
    BOOL result = [self.fmdb executeUpdate:sql];
    if (result) {
        NSLog(@"表创建成功");
    }
}

- (void)dropTable {
    NSString *sql = [NSString stringWithFormat:@"drop table if exists %@", self.tableName];
    BOOL result = [self.fmdb executeUpdate:sql];
    if (result) {
        NSLog(@"表删除成功");
    }
}

- (void)insertDataWithModel:(NSObject *)model successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock {
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (model) values(?)", self.tableName];
    BOOL result = [self.fmdb executeUpdate:sql withArgumentsInArray:@[modelData]];
    if (result) {
        aSuccessBlock();
    } else {
        aFailBlock();
    }
}

- (void)updateDataWithModel:(NSObject *)model uid:(NSInteger)aUid successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock {
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSString *sql = [NSString stringWithFormat:@"update %@ set model = ? where id = ?", self.tableName];
    BOOL result = [self.fmdb executeUpdate:sql withArgumentsInArray:@[modelData, @(aUid)]];
    if (result) {
        aSuccessBlock();
    } else {
        aFailBlock();
    }
}

- (void)deleteDataWithUid:(NSInteger)uid successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id = ?", self.tableName];
    BOOL result = [self.fmdb executeUpdate:sql withArgumentsInArray:@[@(uid)]];
    if (result) {
        aSuccessBlock();
    } else {
        aFailBlock();
    }
}

- (NSArray<NSObject *> *)queryAllData {
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",self.tableName];
    @try {
        FMResultSet *rs = [self.fmdb executeQuery:sql];
        while (rs.next) {
            NSObject *model = [[NSObject alloc] init];
            NSData *modelData = [rs dataForColumn:@"model"];
            int uid = [rs intForColumn:@"id"];
            
            model = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
            model.wd_fmdb_id = uid;
            [array addObject:model];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", self.fmdb.lastError);
    } @finally {
        NSLog(@"查询数据");
    }
    
   return array;
}

- (FMDatabase *)fmdb {
    if (!_fmdb) {
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/testDB.db"];
        _fmdb = [[FMDatabase alloc] initWithPath:path];
    }
    return _fmdb;
}

@end


