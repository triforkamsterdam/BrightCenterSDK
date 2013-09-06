@interface BCAssessment : NSObject

@property (nonatomic, copy) NSString *id;

- (id) initWithId:(NSString *) id;

+ (id) assessmentWithId:(NSString *) id;

@end