# Brightcenter SDK

Use this SDK to make it easy to communicate with the Brightcenter backend. Also it contains the student picker which helps you
login to Brightcenter and select students from a list of groups.

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
    pod 'BrightCenterSDK', '~> 1.2'

Now open a terminal and change to your XCode project directory. Run the command `pod install`. That's it!
Open the generated YourApp.xcworkspace file with XCode or AppCode (instead of YourApp.xcodeproj).

### Configure the environment you want to use

If you want to use the Brightcenter test-server at http://tst-brightcenter.trifork.nl put this line in your `AppDelegate`
```objective-c
[[BCStudentsRepository instance] configureForSandbox];
```

At the moment of writing the production environment is not yet ready. When it is, the SDK will be updated and you will be able to call `configureForProduction` instead.

###Using the brightcenter login button
We've created a nice button which you can implement in your code so you dont have to implement the studentPicker yourself. Add the following code to the viewcontroller in which you want to add the button:

```objective-c
- (void) addOverlayButtonWithColor: (int) color andPosition: (int) position{
    UIColor *logoColor;
    switch (color) {
        case 1:
            logoColor =[UIColor colorWithRed:244 / 255.0 green:126 / 255.0 blue:43 / 255.0 alpha:1.0];
            break;
        case 2:
            //blue
            logoColor = [UIColor colorWithRed:0 / 255.0 green:156 / 255.0 blue:250 / 255.0 alpha:1.0];
            break;
        case 3:
            //grey
            logoColor = [UIColor colorWithRed:77 / 255.0 green:77 / 255.0 blue:77 / 255.0 alpha:1.0];
            break;
        default:
            logoColor = [UIColor colorWithRed:244 / 255.0 green:126 / 255.0 blue:43 / 255.0 alpha:1.0];
            break;
    }
    
    CGSize size = self.view.frame.size;
    CGFloat logoSize = MIN(size.width / 3, size.height / 3) * 0.5;

    int x = 0;
    int y = 0;
    
    double margin = 0.8;
    int posX = 0;
    int posY = 0;
    int trans = logoSize / 3;
    switch (position) {
        case 1:
            x = (logoSize * margin) - logoSize;
            y = (logoSize * margin) - logoSize;
            posX = 4;
            posY = 4;
            break;
        case 2:
            x = size.width - (logoSize * margin);
            y = (logoSize * margin) - logoSize;
            posX = trans;
            posY = 4;
            break;
        case 3:
            x = (logoSize * margin) - logoSize;
            y = size.height - (logoSize * margin);
            posX= 0;
            posY = trans;
            break;
        case 4:
            x = size.width - (logoSize * margin);
            y = size.height - (logoSize * margin);
            posX = trans;
            posY = trans;
            break;
            
        default:
            x = size.width - (logoSize * margin);
            y = size.height - (logoSize * margin);
            break;
    }
    BCButtonLogo *backgroundView;
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        backgroundView = [[BCButtonLogo alloc] initWithColor:logoColor andPositionX:posX andPositionY:posY];
        [self.view addSubview:backgroundView];
        
        backgroundView.frame = CGRectMake(x, y, logoSize, logoSize);
    } else if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        backgroundView = [[BCButtonLogo alloc] initWithColor:logoColor andPositionX:posY andPositionY:posX];
        [self.view addSubview:backgroundView];
        
        backgroundView.frame = CGRectMake(y, x, logoSize, logoSize);
    }
    backgroundView.bcButtonClickedDelegate = self;
}

- (void) bcButtonIsClicked{
    BCStudentPickerController *studentPickerController = [BCStudentPickerController new];
    studentPickerController.studentPickerDelegate = self;
    if (studentPickerController) {
        [self presentViewController:studentPickerController animated:YES completion:nil];
    }
}
```
You also need to make your viewcontroller a delegate of `BCStudentPickerControllerDelegate` and `BCButtonLogoClickedDelegate`. You can do that as follows:
```objective-c
@interface MyCoolEduAppController : UIViewController <BCStudentPickerControllerDelegate, BCButtonLogoClickedDelegate>
```
In your code you can call `addOverlayButtonWithColor: (int) color andPosition: (int) position` to show the button.
The number color stands for the following: 1 for orange, 2 for blue and 3 for grey. The positions are as follows: 1 for top left corner, 2 for top right corner, 3 for bottom left corner and 4 for bottom right corner.



### Login to Brightcenter from your app(Manually)

The SDK contains some screens that will log you into Brightcenter and choose a student from a list of groups, right out-of-the-box.
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

Optionally you can implement the logout method:
```objective-c
- (void) loggedOut{
    //Use this to log out in your app if necessary
}
```

After a student completed an exercise (in Brightcenter this is called an assessment item) you have to let Brightcenter know.

## Using the API directly (without UI)

Using the `BCStudentsRepository` you can access the Brightcenter API directly. You can always get the shared (singleton) instance of `BCStudentsRepository` like this:

```objective-c
BCStudentsRepository *repository = [BCStudentsRepository instance];
```

### Registering a new assessment item result
This is how you register the result of an assessment item:

```objective-c
BCStudentsRepository *repository = [BCStudentsRepository instance];
BCAssessmentItemResult *result = [BCAssessmentItemResult new];
result.student = self.student;
result.questionId = @"123";
result.assessment = [BCAssessment assessmentWithId:@"456"];
result.duration = 5;
result.completionStatus = BCCompletionStatusCompleted;
result.score = 10;

// Saving an assessment makes a call to the backend, so it could take a second. It is wise to display an activity indicator.
[repository saveAssessmentItemResult:result success:^{
    // Saving the assessment item was successful!
    // At this point you can hide the progress indicator.
} failure:^(NSError *error, BOOL loginFailure) {
    // Saving the result failed. This could happen when: 
    // 1) the given credentials are no longer valid (loginFailure = YES)
    // 2) or there was a network error 
}];
```

### Loading all registered item results for an assessment
When you later on need to load all the assessment item results that were registered in Brightcenter for a given assessment and student:

```objective-c
    BCStudentsRepository *repository = [BCStudentsRepository instance];

    // Loading the registered results makes a call to the backend, so it could take a second. It is wise to display an activity indicator.
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

Open the generated BrightcenterSDK.xcworkspace in XCode or AppCode (instead of BrightcenterSDK.xcodeproj)

Run the project in the iPad Simulator or on an actual iPad.
