@class BCGroup;

@interface BCStudent : NSObject

@property(nonatomic, copy) NSString *id;
@property(nonatomic, strong) BCGroup *group;
@property(nonatomic, copy) NSString *name;

- (id) initWithName:(NSString *) name;

+ (id) studentWithName:(NSString *) name;

@end