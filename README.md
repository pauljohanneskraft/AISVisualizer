<img src="https://github.com/pauljohanneskraft/AISVisualizer/blob/main/Shared/Assets.xcassets/AppIcon.appiconset/Icon-128@2x.png?raw=true" height="150" align="right">

# AISVisualizer

AISVisualizer is an app to display ship routes from AIS files on top of Apple Maps (MKMapView). It also allows to draw grids to visualize coordinate regions.

## Getting started

The app is currently only available as part of this repository. It is available for iOS 15+ and macOS 12+. To build the application, you will need to use Xcode 13.3+ and adapt code signing to your own team.

## App functionality

First, you can select AIS files with the following format. The app expects the first 4, the rest may be ommitted, since they are irrelevant for the computation of paths.

```
MMSI,BaseDateTime,LAT,LON,SOG,COG,Heading,VesselName,IMO,CallSign,VesselType,Status,Length,Width,Draft,Cargo,TranscieverClass
```

<p align="center"><img width="700" alt="Bildschirmfoto 2022-04-22 um 15 32 02" src="https://user-images.githubusercontent.com/15239005/164724529-d0de4351-10f3-4667-ab91-bba183afa924.png"></p>

After selecting the files you want to `AISVisualizer` to read, tap `Continue`. It will take some time until the files are fully read (a file with 6,000,000 lines takes up to around 5 minutes - keep that in mind!). The progress is displayed as the count of already processed lines.

<p align="center"><img width="700" alt="Bildschirmfoto 2022-04-22 um 15 39 47" src="https://user-images.githubusercontent.com/15239005/164725912-8f6caa12-a6d1-4866-993a-1fd6872f069b.png"></p>

When the files are fully read, an Apple Maps view is displayed.

- On the navigation bar, you can switch between different map types. 
- `Add Path` allows you to add a line to the map that follows a vessel's position over the given date range.
- `Add Grid` allows you to add multiple rectangles forming a grid in a given region.
- `Center` will set the map's visible region to show all of the overlays that are currently visible. If there are none, this option is disabled.
- `Reset` will remove all paths and grids from the map.
- `Close` will discard the information from the files read and get you back to the initial page of the app - you will need to wait again for the files to be read, even if you select the same files.

<p align="center"><img width="700" alt="Bildschirmfoto 2022-04-22 um 15 35 26" src="https://user-images.githubusercontent.com/15239005/164725689-421413e4-c145-4a2a-aa12-e685574dc863.png"></p>

## Author

Paul Kraft

## Licence

AISVisualizer is available under the MIT license. See the LICENSE file for more info.
