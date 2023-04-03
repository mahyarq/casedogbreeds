
  
## DogBreeds iOS app
## Task & Requirement

1. List of Breeds
	- Shows the list of available breeds
	- Navigates the app to screen 2 when the user taps any of the breeds
	- Has “favorites” button that navigates the app to screen 3

2. Breed Pictures
	- Shows all the available pictures of a given breed
	- Allows users to like/unlike specific images by tapping the image or a like button

4. Favorite Pictures
	- Shows the images that the user liked
	- Shows which breed a particular image belongs to
	- Allows user to filter images by selecting a breed.

Important Note
The purpose of this assignment is for you to demonstrate your skill level, so we would like you to avoid using frameworks for networking and for images loading (e.g.: Alamofire, Kingfisher, SDWebImage etc) unless you can’t solve these tasks yourself.

Requirements
- You should use the following API: https://dog.ceo/dog-api
- Your app should be written in Swift
- Your app should be using UIKit (because this is what we use ourselves)
- If you are familiar with any FRP framework (like Combine), feel free to use it

## About the Project
Hey there! This is my iOS app for a take-home assignment. I decided to go with MVVM and Combine since I have previously worked with these and I feel like they make testing much easier.

## How I Developed the App
When I started developing the app, I first checked out the API to see what data I could work with. Then, I created some designs for each screen I wanted to include in the app. Here's what my development process looked like:
- I set up the project resources according to the design.
- I created the main screens views.
- I added Managers to handle the networking, image caching, and other features.
- I connected the ViewModels to the API and caching.
- I worked on improving the app's user experience and made some minor UI changes.
- I started debugging the app for any issues I could find.
- I wrote tests to ensure that the app works as expected.
- I refactored the Managers and ViewModels to make them easier to test.
- I added tests for the Managers and ViewModels.
- I did a final round of bug fixing and improvements before submitting the app.

  

## What's Next

There are several improvements that I would make if I had more time. Here are some of the things I would work on:
- Improving the app's UI with more design elements.
- Enhancing the user experience with animations and gestures.
- Adding more filtering and sorting options to the app.
- Writing UI tests to make sure everything is working as it should.
- Adding error handling and retry options in case of single image fetching failures.

## Conclusion
I developed this app with simplicity and ease of testing in mind. I'm happy with how it
