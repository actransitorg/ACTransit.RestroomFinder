# AC Transit Restroom Finder 2.0 app with management websites

Pinpoints the nearest authorized restroom for bus operator and field staff, using GPS and on-screen map.    
   
   
## Features of native Android and iOS app include:

 * Map of restrooms (restroom icons on map, tracking/heading, map type, sortable restroom list, disabled while driving).

 * Restroom feedback screen (needs attention flag, comments, past feedback list).
 
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

 * ASP.NET MVC 5.2, Entity Framework 6.4.4, Bootstrap 3.3, PowerShell 5.0 and jQuery/jQuery UI and Knockout.

 * log4net and email logging for errors and website tracing.


## Features of download website:

* Download link and installation help based on device autodetection (iOS, Android or Desktop).

* Designed for device sideloading.

* Latest version comes from API.


## Minimum Requirements

 * Visual Studio 2022

 * SQL Server 2019+ (Express works).  Can use older version if SQL objects are modified.


## Installation

 * Open the project using Microsoft Visual Studio.

 * Make sure the ACTransit.Restroom.Web project is your startup project.

 * Build and run solution.

By default, the application will run in LocalDB mode -- for demo purposes, this is sufficient.  For production, we suggest at least SQL Server 2017 Express.

Since the databases reference each other, we included a custom SQLExecute tool, which rewrites database references for your particular environment.  When you compile, [PublishScripts/publish.bat](https://github.com/actransitorg/ACTransit.RestroomFinder/PublishScripts/publish.bat) is executed and creates customized databases under the App_Data directory for the web application (see [PublishScripts](https://github.com/actransitorg/ACTransit.RestroomFinder/PublishScripts) for more details).


## Files requiring settings customization

ACTransit.DataAccess.RestroomFinder\App.config
- Rewiew ConnectionStrings

ACTransit.Framework\Notification\EmailPayload.cs
- Update Company FQDN

ACTransit.Framework\Notification\EmailPayload.cs
- Update Company Website

ACTransit.Framework\Notification\SmsPayload.cs
- Update Company FQDN
- Update Company Website

ACTransit.Framework\Security\PasswordStore.cs
- Change defaultKey (base64) and defaultIV (base64) and rootKey (Registry Key) 

ACTransit.RestroomFinder.API.csproj
- Defaults to IIS Express

ACTransit.RestroomFinder.API\Web.config
- Check ConnectionStrings
- Update network SMTP host
- Update noreply email address
- Update Company FQDN
- Update KML access token (GUID)
- Update Transit API Key 
- Update Twilio SID/Token and Phone #
- Update app sideloading download URL (Mobile.Apps website)

ACTransit.RestroomFinder.Native\Apple\Certificates
- Create/Add .p12 files (Apple ID distribution certs, pub/priv keys)

ACTransit.RestroomFinder.Native\Android\RestroomFinder\KeyStore
- Create/Add Restroom.jks

ACTransit.RestroomFinder.Native\Apple\Certificates
- Create/Add CertificateSigningRequest.certSigningRequest

ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\main\java\org\actransit\restroomfinder\Infrastructure\Constants.java
- Update Transit API token
- Update Test API URI Root
- Update Prod API URI Root

ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\flavorDemo\google-services.json
ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\flavorDev\google-services.json
ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\flavorProd\google-services.json
ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\main\google-services.json
RestroomFinder\ACTransit.RestroomFinder.Native\Android\google-services.json
- Update project number
- Update project id
- Update mobilesdk_app_id
- Update package_name (e.g. url.company.your.RestroomFinder)
- Update current key
- Update Google Analytics tracking id

ACTransit.RestroomFinder.Native\Apple\Restroom\Constants.swift
- Update Test API URI
- Update Prod API URI
- Update Company FQDN
- Update Transit API Token

ACTransit.RestroomFinder.Native\Apple\Restroom\GoogleService-Info.plist
- Update TRACKING_ID
- Update BUNDLE_ID
- Update PROJECT_ID
- Update GOOGLE_APP_ID

ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\flavorDemo\res\values\strings.xml
ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\flavorDev\res\values\strings.xml
ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\flavorProd\res\values\strings.xml
ACTransit.RestroomFinder.Native\Android\RestroomFinder\app\src\flavorTest\res\values\strings.xml
- Update Transit API key

ACTransit.RestroomFinder.Web\ACTransit.RestroomFinder.Web.csproj
- Verify publish.bat works as designed (creates database files) or comment out functionality

ACTransit.RestroomFinder.Web\Web.config
- Check ConnectionStrings
- Update AD/LDAP URL
- Update Company SMTP server
- Update SSRS reports URL
- Update noreply email account

ACTransit.RestroomFinder.Web\Scripts\gmap.viewer.js
- Update URL to Restroom Finder 

ACTransit.RestroomFinder.Web\ACL.xml
- Verify ACLs are correct for AD groups or AD user accounts or job titles.


## Contact Us

We welcome and encourage your feedback regarding features, found issues, pull requests or any new business processes you have developed.  
If you want to reach out to our team, please visit http://actransit.org or email devsupport@actransit.org.

## License

Code released under the [MIT](https://github.com/actransitorg/ACTransit.RestroomFinder/LICENSE.md) license.  Docs released under [Creative Commons](https://github.com/actransitorg/RestroomFinder/docs/LICENSE_CC.md).