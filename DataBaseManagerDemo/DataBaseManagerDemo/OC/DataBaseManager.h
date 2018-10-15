//
//  WDDataBaseManager.h
//  DataBase-OC
//
//  Created by wudan on 2018/10/15.
//  Copyright © 2018 wudan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (addId)

@property (nonatomic) NSInteger wd_fmdb_id;

@end

typedef void(^successBlock)(void);
typedef void(^failBlock)(void);

@interface DataBaseManager : NSObject

+ (instancetype)defaultManager;
/** 创建表 */
- (void)createTableWithName:(NSString *)name;
/** 删除表 */
- (void)dropTable;
/** 添加数据 */
- (void)insertDataWithModel:(NSObject *)model successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock;
/** 更新数据 */
- (void)updateDataWithModel:(NSObject *)model uid:(NSInteger)aUid successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock;
/** 删除数据 */
- (void)deleteDataWithUid:(NSInteger)uid successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock;
/** 查询全部数据 */
- (NSArray<NSObject *> *)queryAllData;

@end

NS_ASSUME_NONNULL_END
