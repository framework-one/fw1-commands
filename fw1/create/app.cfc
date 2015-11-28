// BASED FROM THE COLDBOX "APP.CFC" COMMAND - https://github.com/Ortus-Solutions/commandbox/tree/master/src/cfml/commands/coldbox/create
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
* Use "installFW1" to install FW/1 from ForgeBox
* {code:bash}
* fw1 create app myApp --installFW1
* {code}
*/
component displayname="FW/1 Create Application Command"
	extends="commandbox.system.BaseCommand"
	excludeFromHelp=false
{
	property name="packageService" inject="PackageService";
	property name="parser" inject="Parser";
	
	/**
	* @name.hint The name of the app being created.
	* @skeleton.hint The name of the app skeleton to generate.
	* @skeleton.options Examples, Skeleton, Basic, Subsystem, Subsystem-Legacy
	* @directory.hint The directory to create the app in. Defaults to current working directory.
	* @installFW1.hint Install the latest stable version of FW/1 from ForgeBox.
	* @package.hint Generate a box.json to make the current directory a package.
	*/
	public void function run(
		string name = "My FW/1 App",
		string skeleton = "Basic",
		string directory = getCWD(),
		boolean installFW1 = false,
		boolean package = true
	) {
		// The location of the app skeletons 
		var skeletonLocation = expandPath("#getDirectoryFromPath( getCurrentTemplatePath() )#../resources/skeletons/");
		// This will make the directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Get the skeleton resource to use
		var skeletonZip = skeletonLocation & arguments.skeleton & ".zip";
		// Validate directory, if it doesn't exist, create it.
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// Validate skeleton
		if ( !fileExists( skeletonZip ) ) {
			var options = directoryList( path = skeletonLocation, listInfo = "name", sort = "name" );
			return error( "The app skeleton [#skeletonZip#] doesn't exist. Valid options are #options.toList( ', ' ).replaceNoCase( '.zip', '', 'all' )#" );
		}
		// Unzip the skeleton
		zip action="unzip" destination="#arguments.directory#" file="#skeletonZip#";
		// Success message
		print.line().greenLine(
			"#skeleton# FW/1 application successfully created in [#arguments.directory#]"
		);
		// Create app as a package
		if ( arguments.package && !packageService.isPackage( arguments.directory ) ) {
			shell.cd( arguments.directory );
			runCommand( 'init 
				name="#parser.escapeArg( arguments.name )#" 
				slug="#parser.escapeArg( arguments.name.replace( ' ', '', 'all' ) )#"'
			); 
			shell.cd( getCWD() );
		}
		// Install FW/1 from ForgeBox
		if ( arguments.installFW1 ) {
			packageService.installPackage(
				id = "fw1",
				directory = arguments.directory,
				save = true,
				saveDev = false,
				production = true,
				currentWorkingDirectory = arguments.directory
			);
		}
	}
}