// BASED FROM THE COLDBOX "VIEW.CFC" COMMAND - https://github.com/Ortus-Solutions/commandbox/tree/master/src/cfml/commands/coldbox/create
/**
* Create a new view in an existing FW/1 application. Be sure to run this command
* in the root of your app to find the correct folder. By default, the new view will be created in /views but can be 
* overridden with the directory param.
* .
* {code:bash}
* fw1 create view myView
* {code}
*  
**/
component extends="commandbox.system.BaseCommand" excludeFromHelp=false {
	/**
	* @name.hint Name of the view to create without the .cfm.
	* @directory.hint The base directory to create your view in and creates the directory if it does not exist.
	**/
	function run( 	
		required name,
		directory = "views" 
	) {
		// This will make each directory canonical and absolute		
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );

		// Validate directory
		if ( !directoryExists( arguments.directory ) ) {
			directoryCreate( arguments.directory );			
		}
		
		// This help readability so the success messages aren't up against the previous command line
		print.line();
		
		var viewContent = "<h1>#arguments.name# view</h1>";
		
		// Write out view
		var viewPath = "#arguments.directory#/#arguments.name#.cfm"; 
		file action="write" file="#viewPath#" mode="777" output="#viewContent#";
		print.greenLine( "Created #viewPath#" );
	}
}