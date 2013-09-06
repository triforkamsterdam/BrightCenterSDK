#import "BCGroup.h"
#import "BCStudent.h"

@implementation BCGroup {
    NSMutableArray *students;
}

- (id) initWithId:(NSString *) id name:(NSString *) name schoolId:(NSString *) schoolId {
    self = [super init];
    if (self) {
        _id = id;
        _name = name;
        _schoolId = schoolId;
        students = [NSMutableArray new];
    }
    return self;
}

+ (id) groupWithId:(NSString *) id name:(NSString *) name schoolId:(NSString *) schoolId {
    return [[self alloc] initWithId:id name:name schoolId:schoolId];
}

- (NSArray *) students {
    return students;
}

- (void) addStudent:(BCStudent *) student {
    [students addObject:student];
}

@end