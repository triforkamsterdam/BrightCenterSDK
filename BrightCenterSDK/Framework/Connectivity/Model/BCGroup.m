#import "BCGroup.h"
#import "BCStudent.h"

@implementation BCGroup {
    NSMutableArray *students;
}

- (id) initWithName:(NSString *) name {
    self = [super init];
    if (self) {
        self.name = name;
    }

    return self;
}

+ (id) groupWithName:(NSString *) name {
    return [[self alloc] initWithName:name];
}

- (NSArray *) students {
    return students;
}

- (void) setStudents:(NSArray *) theStudents {
    students = [[NSMutableArray alloc] initWithCapacity:[theStudents count]];
    for (BCStudent *student in theStudents) {
        student.group = self;
        [students addObject:student];
    }
}

@end