@class BCStudent;

@interface BCGroup : NSObject

@property(readonly) NSString *id;
@property(readonly) NSString *name;
@property(readonly) NSString *schoolId;
@property(readonly) NSArray *students;

- (id) initWithId:(NSString *) id name:(NSString *) name schoolId:(NSString *) schoolId;

+ (id) groupWithId:(NSString *) id name:(NSString *) name schoolId:(NSString *) schoolId;

- (void) addStudent:(BCStudent *) student;

@end