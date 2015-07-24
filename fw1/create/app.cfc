// BASED FROM THE COLDBOX "APP.CFC" COMMAND - https://github.com/Ortus-Solutions/commandbox/tree/master/src/cfml/commands/coldbox/create
/**
* Create a example or blank FW/1 app from one of the app skeletons. By default it will create
* in the current directory. Use the "pwd" command to find out which directory you're currently in.
* .
* You can choose what app skeleton to use as well as override the directory it's created in.
* The available app skeletons are located in the .CommandBox/commands/fw1/resources/skeletons/ directory and include:
* .
* - Examples
* - Skeleton
* - Basic
* - Subsystem
* .
* {code:bash}
* fw1 create app myApp
* {code}
* .
* Use the "installFW1" param to install the latest stable version of FW/1 from ForgeBox
* {code:bash}
* fw1 create app myApp --installFW1
* {code}
**/
component extends="commandbox.system.BaseCommand" excludeFromHelp=false {
	// The location of our skeletons
	property name="skeletonLocation";
	// DI
	property name="packageService" inject="PackageService";
	property name="parser" inject="Parser";
	
	function init() {
		super.init();
		variables.skeletonLocation = getDirectoryFromPath( getCurrentTemplatePath() )  & "/../resources/skeletons/";
		return this;
	}
	
	/**
	 * @name The name of the app you want to create
	 * @skeleton The name of the app skeleton to generate
	 * @skeleton.options Examples, Skeleton, Basic, Subsystem
	 * @directory The directory to create the app in and creates the directory if it does not exist.  Defaults to your current working directory.
	 * @installFW1 Install the latest stable version of FW/1 from ForgeBox
	 * @init "init" the directory as a package if it isn't already
	 **/
	function run(
		name = "My FW/1 App",
		skeleton = "Skeleton",
		directory = getCWD(),
		boolean installFW1 = false,
		boolean init = true
	) {
		// This will make the directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
				
		// get the right skeleton
		var skeletonZip = skeletonLocation & arguments.skeleton & ".zip";
		
		// Validate directory, if it doesn't exist, create it.
		if ( !directoryExists( arguments.directory ) ) {
			directoryCreate( arguments.directory );
		}
		
		// Validate skeleton
		if ( !fileExists( skeletonZip ) ) {
			var options = directoryList( path=skeletonLocation, listInfo="name", sort="name" );
			return error( "The app skeleton [#skeletonZip#] doesn't exist. Valid options are #replaceNoCase( arrayToList( options, ', ' ), '.zip', '', 'all' )#" );			
		}
		
		// Unzip the skeleton!
		zip action="unzip" destination="#arguments.directory#" file="#skeletonZip#";
	
		print.line()
			.greenLine( "#skeleton# Application successfully created in [#arguments.directory#]" );
		
		// Check for the @appname@ in .project files
		if ( fileExists( "#arguments.directory#/.project" ) ){
			var sProject = fileRead( "#arguments.directory#/.project" );
			sProject = replaceNoCase( sProject, "@appName@", arguments.name, "all" );
			file action="write" file="#arguments.directory#/.project" mode ="755" output="#sProject#";
		}

		// Init, if not a package as a Box Package
		if ( arguments.init && !packageService.isPackage( arguments.directory ) ) {
			var originalPath = getCWD(); 
			// init must be run from CWD
			shell.cd( arguments.directory );
			runCommand( 'init 
				name="#parser.escapeArg( arguments.name )#" 
				slug="#parser.escapeArg( replace( arguments.name, ' ', '', 'all' ) )#"'
			); 
			shell.cd( originalPath );
		}
		
		// Install the Framework One platform
		if ( arguments.installFW1 ) {
			// Flush out stuff from above
			print.toConsole();
			
			packageService.installPackage(
				ID = "fw1",
				directory = arguments.directory,
				save = true,
				saveDev = false,
				production = true,
				currentWorkingDirectory = arguments.directory
			);
		}
	}
}