#import "BCAssessmentItemResult.h"
#import "BCStudent.h"
#import "BCAssessment.h"

@implementation BCAssessmentItemResult

- (BOOL) hasSameQuestionAndStudent:(BCAssessmentItemResult *) result {
    return [self.questionId isEqualToString:result.questionId]
            && [self.student.id isEqualToString:result.student.id];
}

- (NSString *) description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.assessment=%@", self.assessment];
    [description appendFormat:@", self.student=%@", self.student];
    [description appendFormat:@", self.date=%@", self.date];
    [description appendFormat:@", self.questionId=%@", self.questionId];
    [description appendFormat:@", self.score=%i", self.score];
    [description appendFormat:@", self.duration=%f", self.duration];
    [description appendFormat:@", self.attempts=%i", self.attempts];
    [description appendFormat:@", self.completionStatus=%d", self.completionStatus];
    [description appendString:@">"];
    return description;
}

@end