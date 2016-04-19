/**
* Create an FW/1 application from one of the available skeletons:
* .
* - Examples
* - Skeleton
* - Basic
* - Subsystem
* - Subsystem-Legacy
* .
* {code:bash}
* fw1 create app myApp
* {code}
* .
* By default the "Basic" skeleton will be installed as the application skeleton.
* .
* By default, the application will be installed in the current working directory
* but can be overridden.
* .
* {code:bash}
* fw1 create app myApp basic my/directory
* {code}
* .
* By default, your application will be created as a package to be used by CommandBox
* for other applications and ForgeBox. This can be altered by setting "package" to false.
* .
* {code:bash}
* fw1 create app myApp basic / false
* {code}
* .
* Use "installFW1" to install the latest stable release of FW/1 from ForgeBox.
* .
* {code:bash}
* fw1 create app myApp --installFW1
* {code}
* .
* Use "serverConfig" to generate a pre-defined server.json.
* .
* {code:bash}
* fw1 create app myApp --serverConfig
* {code}
* .
* Use "startSever" to have CommandBox start a server that
* will run your app after generation.
* .
* {code:bash}
* fw1 create app myApp --startServer
* {code}
*/
component displayname="FW/1 Create Application Command"
	excludeFromHelp=false
{
	property name="packageService" inject="PackageService";
	property name="settings" inject='commandbox:moduleSettings:fw1-commands';
	
	/**
	* @name.hint The name of the app being created.
	* @skeleton.hint The name of the app skeleton to generate.
	* @skeleton.options Examples, Skeleton, Basic, Subsystem, Subsystem-Legacy
	* @directory.hint The directory to create the app in. Defaults to current working directory.
	* @installFW1.hint Install the latest stable version of FW/1 from ForgeBox.
	* @package.hint Generate a box.json to make the current directory a package.
	* @serverConfig.hint Generate a server.json to control how CommandBox starts a server for the app.
	* @startServer.hint Have CommandBox start a server that will run your app after generation.
	*/
	public void function run(
		string name = "My FW/1 App",
		string skeleton = "Basic",
		string directory = getCWD(),
		boolean package = true,
		boolean installFW1 = false,
		boolean serverConfig = false,
		boolean startServer = false
	) {
		// This will make the directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Get the skeleton resource to use
		var skeletonZip = settings.resources.skeletons & arguments.skeleton & ".zip";
		// Validate skeleton
		if ( !fileExists( skeletonZip ) ) {
			var options = directoryList( path = settings.resources.skeletons, listInfo = "name", sort = "name" );
			return error( "The app skeleton [#skeletonZip#] doesn't exist. Valid options are #options.toList( ', ' ).replaceNoCase( '.zip', '', 'all' )#." );
		}
		// Validate directory, if it doesn't exist, create it
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// Unzip the skeleton
		zip action="unzip" destination="#arguments.directory#" file="#skeletonZip#";
		// Success message
		print.line().greenLine( "FW/1 (#arguments.skeleton#) application successfully generated in [#arguments.directory#]!" );
		// Create app as a package
		if ( arguments.package && !packageService.isPackage( arguments.directory ) ) {
			shell.cd( arguments.directory );
			command( "init" ).params( name = arguments.name, slug = arguments.name.replace( ' ', '', 'all' ) ).run();
			shell.cd( getCWD() );
		}
		// Install FW/1 from ForgeBox
		if ( arguments.installFW1 ) {
			command( "install" ).params( id = "fw1", directory = arguments.directory ).run();
		}
		// Create server.json
		if ( arguments.serverConfig ) {
			// Write server.json content and print success
			savecontent variable="serverJson" {
				writeOutput( '{' );
			    writeOutput( cr & chr(9) & '"heapSize": "512",' );
			    writeOutput( cr & chr(9) & '"host": "localhost",' );
			    writeOutput( cr & chr(9) & '"rewritesEnable": false,' );
				writeOutput( cr & '}' );
			}
			fileWrite( arguments.directory & "/server.json", serverJson );
			print.line().greenLine( "Created server.json successfully." );
		}
		// Start a server to begin using generated app
		if ( arguments.startServer ) { command( "server start" ).run(); }
	}
}