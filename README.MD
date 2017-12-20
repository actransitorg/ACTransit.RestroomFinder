# AC Transit Restroom Finder app with management websites

Pinpoints the nearest authorized restroom for bus operator and field staff, using GPS and on-screen map.    
   
## Features of native Android and iOS app include:

 * Map of restrooms (restroom icons on map, tracking/heading, map type, sortable restroom list, disabled while driving).

 * Restroom rating screen (needs attention flag, comments, star rating, past feedback list).
 
 * Filtering (by route or by potable water). 

 * Login screen (badge authentication and disclaimer).

 * Uses sideloading (not found in Google Play or Apple Store).

 * iOS 9+ and Android 4.4+.
 
## Features of restroom management website:

 * View and Search (search options, restroom table, data paging, app menu, add/edit restroom).

 * Restroom management (address, type, attributes, find location on map, reverse geolocation).

 * Restroom API for native app.

 * SSRS Reports (Feedback Summary, Filtered Restroom List, Daily Restroom Digest).

 * Feature access control uses AD groups, NT usernames and/or job titles.  

 * ASP.NET MVC 5.2, Entity Framework 6.1.3, Bootstrap 3.3, PowerShell 5.0 and jQuery/jQuery UI and Knockout.

 * log4net and email logging for errors and website tracing.

## Features of download website:

* Download link and installation help based on device autodetection (iOS, Android or Desktop).

* Designed for device sideloading.

* Latest version comes from API.

## Minimum Requirements

 * Visual Studio 2017

 * SQL Server 2016 (Express is OK)

## Installation

 * Open the project using Microsoft Visual Studio.

 * Make sure the ACTransit.Restroom.Web project is your startup project.

 * Build and run solution.

By default, the application will run in LocalDB mode -- for demo purposes, this is sufficient.  For production, we suggest at least SQL Server 2016 Express.

Since the databases reference each other, we included a custom SQLExecute tool, which rewrites database references for your particular environment.  When you compile, [PublishScripts/publish.bat](https://github.com/actransitorg/ACTransit.RestroomFinder/PublishScripts/publish.bat) is executed and creates customized databases under the App_Data directory for the web application (see [PublishScripts](https://github.com/actransitorg/ACTransit.RestroomFinder/PublishScripts) for more details).

## Files requiring settings customization

* ACTransit.Framework\ACTransit.Framework\Notification\EmailPayload.cs
* RestroomFinder\ACTransit.Mobile.Apps\Restroom\manifest.plist
* RestroomFinder\ACTransit.Mobile.Apps\Restroom\Help.htm
* RestroomFinder\ACTransit.RestroomFinder.Web\Scripts\gmap.viewer.js
* RestroomFinder\ACTransit.RestroomFinder.Web\Web.config
* RestroomFinder\Native\Android\RestroomFinder\app\src\main\java\org\actransit\restroomfinder\Infrastructure\Constants.java
* RestroomFinder\Native\Android\RestroomFinder\app\google-services.json
* RestroomFinder\Native\Apple\Restroom\Constants.swift
* RestroomFinder\Native\Apple\Restroom\GoogleService-Info.plist
* RestroomFinder\RestroomFinderAPI\Controllers\VersionController.cs
* RestroomFinder\RestroomFinderAPI\Web.config
* RestroomFinder\RestroomFinderApi.Test\Settings.cs
* RestroomFinder\Native\Android\RestroomFinder\app\src\flavorProd\res\values\strings.xml
* RestroomFinder\Native\Android\RestroomFinder\app\src\flavorTest\res\values\strings.xml

## Contact Us

We welcome and encourage your feedback regarding features, found issues, pull requests or any new business processes you have developed.  
If you want to reach out to our team, please visit http://actransit.org or email devsupport@actransit.org.

## License

Code released under the [MIT](https://github.com/actransitorg/ACTransit.RestroomFinder/LICENSE.md) license.  Docs released under [Creative Commons](https://github.com/actransitorg/RestroomFinder/docs/LICENSE_CC.md).