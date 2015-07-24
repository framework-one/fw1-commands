// BASED FROM THE COLDBOX "CONTROLLER.CFC" COMMAND - https://github.com/Ortus-Solutions/commandbox/tree/master/src/cfml/commands/coldbox/create
/**
* Create a new controller in an existing FW/1 application. Be sure to run this command in the root of your app to insure the file is created in the proper folder.
* By default, the controller will be created in /controllers but you can override this with the directory param.
* .
* {code:bash}
* fw1 create controller myController index,foo,bar --open
* {code}
**/
component extends="commandbox.system.BaseCommand" excludeFromHelp=false {
	/**
	* @name.hint Name of the controller to create without the .cfc. For packages, specify name as 'myPackage/myController'
	* @actions.hint A comma-delimited list of actions to generate
	* @views.hint Generate a view for each action
	* @viewsDirectory.hint The directory where your views are stored. Only used if views is set to true.
	* @directory.hint The base directory to create your controller in and creates the directory if it does not exist. Defaults to 'controllers'.
	* @open.hint Open the controller once generated
	**/
	function run( 	
		required name,
		actions = "default",
		boolean views = true,
		viewsDirectory = "views",
		directory = "controllers",
		boolean open = false
	) {
		// This will make each directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		arguments.viewsDirectory = fileSystemUtil.resolvePath( arguments.viewsDirectory );

		// Validate directory
		if ( !directoryExists( arguments.directory ) ) {
			directoryCreate( arguments.directory );
		}

		// Allow dot-delimited paths
		arguments.name = replace( arguments.name, ".", "/", "all" );
		// This help readability so the success messages aren't up against the previous command line
		print.line();

		// Read in Templates
		var controllerContent = fileRead( getDirectoryFromPath( getCurrentTemplatePath() )  & "/../resources/templates/ControllerContent.txt" );
		var actionContent = fileRead( getDirectoryFromPath( getCurrentTemplatePath() )  & "/../resources/templates/ActionContent.txt" );

		// Start text replacements
		controllerContent = replaceNoCase( controllerContent, "|controller|", arguments.name, "all" );
		
		// Handle Actions if passed
		if ( len( arguments.actions ) ) {
			var allActions = "";

			// Loop Over actions generating their functions
			for ( var thisAction in listToArray( arguments.actions ) ) {
				thisAction = trim( thisAction );
				allActions = allActions & replaceNoCase( actionContent, "|action|", thisAction, "all" ) & cr & cr;

				// Are we creating views?
				if ( arguments.views ) {
					var viewPath = arguments.viewsDirectory & "/" & arguments.name & "/" & thisAction & ".cfm";
					// Create dir if it doesn't exist
					directoryCreate( getDirectoryFromPath( viewPath ), true, true );
					// Create View Stub
					fileWrite( viewPath, "<cfoutput>#cr#<h1>#arguments.name#.#thisAction#</h1>#cr#</cfoutput>" );
					print.greenLine( "Created " & arguments.viewsDirectory & "/" & arguments.name & "/" & thisAction & ".cfm" );
				}
			}
			// final replacements
			allActions = replaceNoCase( allActions, "|name|", arguments.name, "all");
			controllerContent = replaceNoCase( controllerContent, "|EventActions|", allActions, "all");
		} else {
			controllerContent = replaceNoCase( controllerContent, "|EventActions|", "", "all" );
		}

		var controllerPath = "#arguments.directory#/#arguments.name#.cfc";
		// Create dir if it doesn't exist
		directoryCreate( getDirectoryFromPath( controllerPath ), true, true );
		// Write out the files
		file action="write" file="#controllerPath#" mode="777" output="#controllerContent#";
		print.greenLine( "Created #controllerPath#" );

		// open file
		if ( arguments.open ){ openPath( controllerPath ); }			
	}
}