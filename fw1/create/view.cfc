// BASED FROM THE COLDBOX "VIEW.CFC" COMMAND - https://github.com/Ortus-Solutions/commandbox/tree/master/src/cfml/commands/coldbox/create
/**
* Create a new view in an existing FW/1 application.
* .
* {code:bash}
* fw1 create view myView
* {code}
* .
* By default, the view will be created in /views but can be overridden.
* .
* {code:bash}
* fw1 create view myView myDirectory
* {code}
*/
component displayname="FW/1 Create View Command"
	extends="commandbox.system.BaseCommand"
	excludeFromHelp=false
{
	/**
	* @name.hint Name of the view to create.
	* @directory.hint The base directory to create your view in. Defaults to current working directory.
	*/
	public void function run(
		required string name,
		string directory = "views"
	) {
		// This will make each directory canonical and absolute		
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Validate directory
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// This help readability so the success messages aren't up against the previous command line
		print.line();
		// Default content to be generated in the view
		var viewContent = "<h1>#arguments.name# view</h1>";
		// Create view
		var viewPath = "#arguments.directory#/#arguments.name#.cfm"; 
		file action="write" file="#viewPath#" mode="777" output="#viewContent#";
		print.greenLine( "Created #viewPath#" );
	}
}