# BrightCenter SDK

Use this SDK to make it easy to communicate with the Bright Center backend. Also it contains the student picker which helps you
login to Bright Center and select students from a list of groups.

Requirements:
- iPad only (for now)
- iOS 5, iOS 6 or iOS 7

## Install cocoapods

Make sure you have Ruby gem by running `gem --version`.

Install cocoapods

    $ sudo gem install cocoapods
    $ pod setup

See also: http://cocoapods.org


## To integrate this SDK into your educational app

Go to your XCode project directory and create a text file called `PodFile` with the following contents:

    platform :ios, '5.0'
    pod 'BrightCenterSDK', '~> 1.1.0'

Now open a terminal and change to your XCode project directory. Run the command `pod install`. That's it!
Open the generated YourApp.xcworkspace file with XCode or AppCode (instead of YourApp.xcodeproj).

### Configure the environment you want to use

If you want to use the BrightCenter test-server at http://tst-brightcenter.trifork.nl put this line in your `AppDelegate`
```objective-c
[[BCStudentsRepository instance] configureForSandbox];
```

At the moment of writing the production environment is not yet ready. When it is, the SDK will be updated and you will be able to call `configureForProduction` instead.

### Login to Bright Center from your app

The SDK contains some screens that will log you into Bright Center and choose a student from a list of groups, right out-of-the-box.
To open the login screen / student picker, present `BCStudentPickerController` as a modal view controller:

```objective-c
BCStudentPickerController *studentPickerController = [BCStudentPickerController new];
studentPickerController.studentPickerDelegate = self;
[self presentViewController:studentPickerController animated:YES completion:nil];
```

As you can see it assigns the controller (self) as the delegate. For this to work you have to conform to the `BCStudentPickerControllerDelegate` protocol as follows:

```objective-c
@interface MyCoolEduAppController : UIViewController <BCStudentPickerControllerDelegate>
```

The protocol requires you to implement one simple method:

```objective-c
- (void) studentPicked:(BCStudent *) student {
    // Save the student object for later. It is needed later to register assessment item results for this student.
    // Also you can use it right now to display the name of this student somewhere in your app.
}
```

After the above method is called, the student picker automatically closes and you can let the chosen student do the exercises you want.
After a student completed an exercise (in Bright Center this is called an assessment item) you have to let Bright Center know.

This is how you register the result of an assessment item:

```objective-c
BCStudentsRepository *repository = [BCStudentsRepository instance];
BCAssessmentItemResult *result = [BCAssessmentItemResult new];
result.student = self.student;
result.questionId = @"123";
result.assessment = [BCAssessment assessmentWithId:@"456"];
result.attempts = 2;
result.duration = 5;
result.completionStatus = BCCompletionStatusCompleted;
result.score = 10;

// Saving an assessment makes a call to the backend, so it could take a second. It is wise to display a progress indicator.
[repository saveAssessmentItemResult:result success:^{
    // Saving the assessment item was successful!
    // At this point you can hide the progress indicator.
} failure:^(NSError *error, BOOL loginFailure) {
    // Saving the result failed. This could happen when: 
    // 1) the given credentials are no longer valid (loginFailure = YES)
    // 2) or there was a network error 
}];
```

When you later on need to load all the assessment item results that were registered in Bright Center for a given assessment and student:

```objective-c
    BCStudentsRepository *repository = [BCStudentsRepository instance];

    // Loading the registered results makes a call to the backend, so it could take a second. It is wise to display a progress indicator.
    [repository loadAssessmentItemResults:[BCAssessment assessmentWithId:@"456"]
                                  student:self.student
                                  success:^(NSArray *assessmentItemResults) {
                                      // Given is an NSArray of BCAssessmentItemResults, do with it whatever you like
                                      // At this point you can hide the progress indicator.
                                  }
                                  failure:^(NSError *error, BOOL loginFailure) {
                                      // Saving the result failed. This could happen when:
                                      // 1) the given credentials are no longer valid or
                                      // 2) there was a network error
                                  }];
```

This is basically it! If you have any questions, don't hasitate to contact me.

## For developers of this SDK

Get the dependencies by running `pod install`.

Open the generated BrightCenterSDK.xcworkspace in XCode or AppCode (instead of BrightCenterSDK.xcodeproj)

Run the project in the iPad Simulator or on an actual iPad.
