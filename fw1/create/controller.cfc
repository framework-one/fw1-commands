// BASED FROM THE COLDBOX "CONTROLLER.CFC" COMMAND - https://github.com/Ortus-Solutions/commandbox/tree/master/src/cfml/commands/coldbox/create
/**
* Create a new controller in an existing FW/1 application.
* .
* {code:bash}
* fw1 create controller myController 
* {code}
* .
* By default, only the "default" action is generated but can be overridden to
* include a list of actions.
* .
* {code:bash}
* fw1 create controller myController list,add,edit,delete
* {code}
* .
* By default, the controller will be created in /controllers but can be
* overridden.
* .
* {code:bash}
* fw1 create controller myController default myDirectory
* {code}
* .
* Views are auto-generated in a /views folder by default but can be overridden.
* .
* {code:bash}
* fw1 create controller myController default controllers false
* {code}
* .
* The directory for the views can be overridden as well.
* .
* {code:bash}
* fw1 create controller myController default controllers true myViews
* {code}
* .
* Once created, the controller can be opened in your default editor by
* setting the "open" param to true.
* .
* {code:bash}
* fw1 create controller myController --open
* {code}
*/
component displayname="FW/1 Create Controller Command"
	extends="commandbox.system.BaseCommand"
	excludeFromHelp=false
{
	public any function init() {
		// ascii codes
		variables.ascii = {
			br = Chr(10) & Chr(13), // line break
			br2 = Chr(10) & Chr(13) & Chr(10) & Chr(13), // line break 2x
			tb = Chr(9), // tab
			tb2 = Chr(9) & Chr(9), // tab 2x
		};

		return this;
	}

	/**
	* @name.hint Name of the controller to create without the .cfc. For packages, specify name as 'myPackage/myController'
	* @actions.hint A comma-delimited list of actions to generate
	* @directory.hint The base directory to create your controller in. Defaults to 'controllers'.
	* @views.hint Generate a view for each action.
	* @viewsDirectory.hint The directory where your views are stored. Only used if views is set to true.
	* @open.hint Open the controller once generated.
	*/
	public void function run( 	
		required name,
		actions = "default",
		directory = "controllers",
		boolean views = true,
		viewsDirectory = "views",
		boolean open = false
	) {
		// This will make each directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		arguments.viewsDirectory = fileSystemUtil.resolvePath( arguments.viewsDirectory );
		// Validate directory
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// Allow dot-delimited paths
		arguments.name = replace( arguments.name, ".", "/", "all" );
		// This help readability so the success messages aren't up against the previous command line
		print.line();
		// Generate controller with actions passed
		savecontent variable="controllerContent" {
			var index = 0;
			var actionArray = listToArray( arguments.actions );
			writeOutput( "component {" & ascii.br );
			for ( var thisAction in actionArray ) {
				index++;
				writeOutput( ascii.tb & "public void function #thisAction#() {" & ascii.br );
				writeOutput( ascii.tb2 & ascii.br );
				writeOutput( ascii.tb & "}" );
				if ( index != arrayLen( actionArray ) ) { writeOutput( ascii.br2 ) }
			}
			writeOutput( ascii.br & "}" );
		}
		var controllerPath = "#arguments.directory#/#arguments.name#.cfc";
		// Create dir if it doesn't exist
		directoryCreate( getDirectoryFromPath( controllerPath ), true, true );
		// Create files
		file action="write" file="#controllerPath#" mode="777" output="#controllerContent#";
		print.greenLine( "Created #controllerPath#" );
		// Open file
		if ( arguments.open ){ openPath( controllerPath ); }			
	}
}