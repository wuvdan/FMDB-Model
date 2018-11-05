![镇楼图](https://upload-images.jianshu.io/upload_images/3334769-db9208d961eb67c2.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

写这个Blog的目的是为了记录的学习经历，代码写的不是很好，希望读者理解。
日常对数据库的操作，需要设计字段，感觉太繁琐了，想找个简化的方法，就想通过这样进行实现，这也就是一种思考方式。实际实现还是看需求。具体看代码：
1、导入FMDB
```
import FMDB
```
2、使用单利模式和必要属性
```
static let defaultManger = WDDataBaseManager()
typealias successBlock = () ->Void
typealias failBlock = () ->Void
private var tableName:String?
```
3、懒加载创建数据库（名称我随便取得）
```
lazy var fmdb:FMDatabase = {
        let path = NSHomeDirectory().appending("/Documents/testDB.db")
        let db = FMDatabase(path: path)
        return db
    }()
```
4、创建表
```
func creatTable(tableName:String) -> Void {
        fmdb.open()
        self.tableName = tableName
        let creatSql = "create table if not exists \(tableName) (id integer primary key autoincrement,model BLOB)"
        let result = fmdb.executeUpdate(creatSql, withArgumentsIn:[])
        if result{
            print("创建表成功")
        }
    }
```
5、删除表
```
 func dropTable() -> Void {
        let sql = "drop table if exists " + tableName!
        let result = fmdb.executeUpdate(sql, withArgumentsIn:[])
        if result{
            print("删除表成功")
        }
    }
```
6、插入数据
```
func insert(model:NSObject, successBlock: successBlock, failBlock: failBlock) -> Void {
        let modelData = try! NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
        let insertSql = "insert into " + tableName! + " (model) values(?)"
        do {
            try fmdb.executeUpdate(insertSql, values: [modelData])
            successBlock()
        } catch {
            print(fmdb.lastError())
            failBlock()
        }
    }
```
7、更新表
```
func update(model:NSObject,uid:Int32, successBlock: successBlock, failBlock: failBlock) -> Void {
        let modelData = try! NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
        let updateSql = "update " + tableName! + " set model = ? where id = ?"
        do {
            try fmdb.executeUpdate(updateSql, values: [modelData, uid])
            successBlock()
        } catch {
            print(fmdb.lastError())
            failBlock()
        }
    }
```
8、查询数据（这是查询所有数据，其他按需求设计）
```
func selectAll() -> [NSObject] {
        var tmpArr = [NSObject]()
        let selectSql = "select * from " + tableName!
        do {
            let rs = try fmdb.executeQuery(selectSql, values:nil)
            while rs.next() {
                var model = NSObject()
                let modelData  = rs.data(forColumn:"model")
                let id = rs.int(forColumn: "id")
                model = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(modelData!) as! NSObject
                model.wd_fmdb_id = id
                tmpArr.append(model)
            }
        } catch {
            print(fmdb.lastError())
        }
        return tmpArr
    }
```
9、删除数据（这是根据Id删除的）
```
func delete(uid:Int32, successBlock: successBlock, failBlock: failBlock) -> Void {
        let deleteSql = "delete from " + tableName! + " where id = ?"
        do {
            try fmdb.executeUpdate(deleteSql, values: [uid])
            successBlock()
        } catch {
            print(fmdb.lastError())
            failBlock()
        }
    }
```
10、新增分类添加默认Id
```
private var wd_id_key: String = "key"

extension NSObject {
    open var wd_fmdb_id:Int32? {
        get {
            return (objc_getAssociatedObject(self, &wd_id_key) as? Int32)
        } set(newValue) {
            objc_setAssociatedObject(self, &wd_id_key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
```
11、使用方法
```
//1. 在Appdelegate中打开数据库
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataBaseManager.defaultManger.creatTable()
        return true
 }
//2、添加数据
WDDataBaseManager.defaultManger.insert(model: model, successBlock: {
                print("成功")
            }, failBlock: {
                 print("失败")
            })
//3、修改数据
WDDataBaseManager.defaultManger.update(model: model, uid: self.model!.wd_fmdb_id!, successBlock: {
               print("成功")
            }, failBlock: {
                print("失败")
            })
//4、删除数据
WDDataBaseManager.defaultManger.delete(uid: model.wd_fmdb_id!, successBlock: {
                print("成功")
            }, failBlock: {
                print("失败")
            })
// 5、查询数据
WDDataBaseManager.defaultManger.selectAll()
```
* 遵循NSCoding 重写三个方法
```
import UIKit

class Model: NSObject , NSCoding{

    public var name:String?
    public var phone:String?
    public var addres:String?
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(addres, forKey: "addres")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.addres = aDecoder.decodeObject(forKey: "addres") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
    }
}
```
12、效果图

![效果图](https://upload-images.jianshu.io/upload_images/3334769-309b5904357f7e30.gif?imageMogr2/auto-orient/strip)

13、Demo地址:https://github.com/wudan-ios/FMDB-Model.git
****
补充Objective-C版本
1、接口文件
```
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (addId)

@property (nonatomic) NSInteger wd_fmdb_id;

@end

typedef void(^successBlock)(void);
typedef void(^failBlock)(void);

@interface WDDataBaseManager : NSObject

+ (instancetype)manager;
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
```
2、实现文件
```
#import "WDDataBaseManager.h"
#import <FMDB.h>
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

@interface WDDataBaseManager ()

@property (nonatomic, strong) FMDatabase *fmdb;
@property (nonatomic, copy) NSString *tableName;


@end

@implementation WDDataBaseManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static WDDataBaseManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[WDDataBaseManager alloc] init];
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
```
3、使用方法
```
// 1、打开数据库，并创建表
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[WDDataBaseManager manager] createTableWithName:@"test"];
    
    return YES;
}
// 2、添加数据
 [[WDDataBaseManager manager] insertDataWithModel:model successBlock:^{
        // TODO:
    } failBlock:^{
        // TODO:
    }];
// 3、查询数据
[[WDDataBaseManager manager] queryAllData]
// 4、修改数据
[[WDDataBaseManager manager] updateDataWithModel:model uid:self.model.wd_fmdb_id successBlock:^{
        // TODO:
    } failBlock:^{
         // TODO:
    }];
// 5、删除数据
[[WDDataBaseManager manager] deleteDataWithUid:model.wd_fmdb_id successBlock:^{
            // TODO:
        } failBlock:^{
            // TODO:
        }];
// 6、删除表
[[WDDataBaseManager manager] dropTable];
```
* 插入表中的Model需要遵循<NSCoding>(实例代码)
```
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.address forKey:@"address"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self == [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"] ;
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}
```

