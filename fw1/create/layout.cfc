/**
* Create a new layout in an existing FW/1 application.
* .
* {code:bash}
* fw1 create layout myLayout
* {code}
* .
* By default, the layout will be created in /layouts but can be overridden.
* .
* {code:bash}
* fw1 create layout myLayout myDirectory
* {code}
*/
component displayname="FW/1 Create Layout Command"
	extends="commandbox.system.BaseCommand"
	excludeFromHelp=false
{
	/**
	* @arguments.name.hint Name of the layout to create.
	* @directory.hint The base directory to create your layout in.
	*/
	public void function run( 	
		required name,
		boolean helper = false,
		directory = "layouts" 
	) {
		// This will make each directory canonical and absolute		
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );				
		// Validate directory
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// This help readability so the success messages aren't up against the previous command line
		print.line();
		// Default content to be generated in the layout
		var layoutContent = "<h1>#arguments.name# Layout</h1>#CR#<cfoutput>##body##</cfoutput>";
		// Create layout
		var layoutPath = "#arguments.directory#/#arguments.name#.cfm"; 
		file action="write" file="#layoutPath#" mode="777" output="#layoutContent#";
		print.greenLine( "Created #layoutPath#" );
	}
}