# Tweets-And-Feelings
IOS Test - used Twitter and Google Natural Language APIs

## Requirements:
- Xcode 10 / 10.1
- Swift 4.2

## Used iOS Architecture Pattern
**MVVM - Model-View-ViewModel**:
#### Distribution
- High distribution of responsibilities among Model, View, ViewModel
#### Testability
- ViewModel knows nothing about the View. It allows to test easily.


### Directory Layout
```
Tweets-And-Feelings
├── /Tweets-And-Feelings/
│   ├── /Appllication/
│       ├── /AppDelegate.swift
│       ├── /AppConfig.swift
│       ├── /Configuration.plist
│   ├── /SupportingFiles/
│       ├── /Info.plist
│   ├── /Network/
│       ├── /API/
│       	  ├── /GoogleAPIProtocol.swift
│       	  ├── /TwitterAPIProtocol.swift
│       ├── /HTTPService.swift
│       ├── /RestClientError.swift
│   ├── /ViewModel/
│       ├── /DynamicValue.swift
│      	├── /GenericDataSource.swift
│       ├── /Twitter/
│       	  ├── /TweetViewModel.swift
│       	  ├── /TwitterTimeLineDataSource.swift
│       	  ├── /TwitterTimeLineViewModel.swift
│   ├── /Models/
│       ├── /GoogleSentiment/
│       	  ├── /GoogleSentiment.swift
│       	  ├── /Sentence.swift
│       	  ├── /Sentiment.swift
│       	  ├── /Text.swift
│       ├── /Twitter/
│       	  ├── /Tweet.swift
│       	  ├── /TweeterUser.swift
│       	  ├── /TwitterToken.swift
│   ├── /UI/
│       ├── /StoryBoards/ 
│           ├── /Main.storyboard
│           ├── /LaunchScreen.storyboard
│       ├── /Controllers/ 
│           ├── /MainViewController.swift
│       ├── /View/ 
│           ├── /TweetCollectionViewCell/
│           	  ├── /TweetCollectionViewCell.swift
│           	  ├── /TweetCollectionViewCell.xib
│   ├── /Utilities/
│       ├── /Extensions.swift
│       ├── /Plist.swift
├── /Tweets and feelings.xcodeproj
├── /Tweets and feelings.xcworkspace
├── /Tweets and feelingsTests/
│   ├── /HTTPServiceTest.swift
├── /.README.md                    
```

## Dependancies

Name          	            | purpose
--------------------------	| -----------------------------------------------------
Alamofire                  	| Network library
AlamofireObjectMapper       | Mapping JSON objects into Swift classes
Toast-Swift                	| Toast notifications to UIView class
Expanding-collection	 	    | Animated material design UI card peek/pop controller



## License

Copyright (c) Nadeesha Lakmal.
