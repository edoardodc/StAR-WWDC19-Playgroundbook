# StAR: Discover the beauty of constellations with AR
[![Build status](https://build.appcenter.ms/v0.1/apps/e0928fc1-253b-4e65-81cd-01e013fd6c0d/branches/master/badge)](https://appcenter.ms)

2 plus 2 is an interactive iOS playground book that helps children learn math using handwriting recognition, gesture detection, and augmented reality.

* Written in Swift
* Awarded by Apple for the WWDC 2019 Scholarship
* Powered by ARKit and UIKit
* Auto Layout was written entirely with code

![](demo.gif)

## Description
During summer nights, I like watching the stars in the sky, but it’s not easy to recognize their names or understand which constellation they belong to. I love the story behind every constellation.
This playground book helps people appreciate the sky by having them connect the stars to form a constellation in augmented reality. This playground was primarily built with ARKit, SceneKit and UIKit. 

To get started, simply place the scene somewhere on the ground and a three dimensional rocket ship will take you to an interactive scene populated by stars. A small instruction label at the top of the view will guide you through the experience. After the rocket has launched, you’ll have a chance to visit the sky a little closer.

After reaching the sky, it’s time to discover some of the most beautiful constellations by connecting the stars around you with ARKit. I found this the hardest technical challenge to implement because I had to populate the scene with 3D spheres, which are reactive to the user’s touches. What’s more, you are prompted to touch a star and then you have to connect the first star to another star by using the interface. The playground book guides you through this experience by understanding where you are in the 3D world (and guiding you to the right track using the isNode: ARKit method if you get lost).

To make the connection with two stars work, I implemented an algorithm that recognizes when two spheres collide. This way, the user is able to connect all the stars to form a constellation. Once the constellation is created, simply tap its label to know more about it. There are 4 constellations in the playground (Serena, Orion, Big Dipper, Aries), so to make this a learning experience, I added interesting information for each one. Also, the label which you can tap to show a pop-up contains the name of the constellation and always faces the user, so it’s always readable no matter where you are.

To make the experience even more interesting, I tried to recreate the entire universe. If you look carefully, you’ll see the Earth and the Moon that rotate around the Sun (which is placed at the center). A melody is played to make the playground, and I converted the playground into a playground book to make this experience even more immersive by taking up all the space available on the iPad.

I am proud of this playground book because it’s a way for me to share my passion for astronomy to everyone. Also, it’s more than an interactive experience. The user will learn about the different constellations by completing a different set of challenges. I believe ARKit was a very interesting and fun technology to work with despite all the technical challenges I faced along the way, and I’m happy the playground is now ready to be shared with everyone.

![](cover.png)
