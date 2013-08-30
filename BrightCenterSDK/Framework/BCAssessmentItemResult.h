@class BCStudent;

typedef enum {
    BCCompletionStatusCompleted,
    BCCompletionStatusIncomplete,
    BCCompletionStatusNotAttempted,
    BCCompletionStatusUnknown,
} BCCompletionStatus;

@interface BCAssessmentItemResult : NSObject

@property (nonatomic, strong) BCStudent *student;
@property (nonatomic, copy) NSString *questionId;

@property (nonatomic) NSInteger score;
@property (nonatomic) CGFloat duration;
@property (nonatomic) NSInteger attempts;
@property (nonatomic) BCCompletionStatus completionStatus;

- (BOOL) hasSameQuestionAndStudent:(BCAssessmentItemResult *) result;
@end