@interface BCGroup : NSObject

@property(nonatomic, copy) NSString *name;
@property NSArray *students;

- (id) initWithName:(NSString *) name;

+ (id) groupWithName:(NSString *) name;

@end