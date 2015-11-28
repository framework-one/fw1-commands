/**
* Create a new Clojure controller in an existing FW/1 application.
* NOTE: This command assumes you are working in the base directory of
* the Clojure application generated to work with FW/1!
* .
* {code:bash}
* fw1 create clj-controller my-controller
* {code}
* .
* By default, only the "default" action is generated but can be overridden to
* include a list of actions.
* .
* {code:bash}
* fw1 create clj-controller my-controller list,add,edit,delete
* {code}
* .
* By default, the controller will be created in "/controllers" but can be
* overridden.
* .
* {code:bash}
* fw1 create clj-controller my-controller my/directory
* {code}
* .
* Once created, the controller can be opened in your default editor by
* setting the "open" param to true.
* .
* {code:bash}
* fw1 create controller my-controller --open
* {code}
*/
component displayname="FW/1 Create Clojure Controller Command"
	extends="commandbox.system.BaseCommand"
	excludeFromHelp=false
{
	/**
	* @name.hint Name of the controller to create.
	* @actions.hint A comma-delimited list of actions to generate
	* @directory.hint The base directory to create your controller in. Defaults to 'controllers'.
	* @open.hint Open the controller once generated.
	*/
	public void function run( 	
		required string name,
		string actions = "default",
		string directory = "controllers",
		boolean open = false
	) {
		// This will make each directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Validate directory
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// This helps readability so the success messages aren't up against the previous command line
		print.line();
		// Generate controller with actions passed
		var controllerContent = scaffoldController( arguments.name, arguments.actions.listToArray() );
		var controllerPath = "#arguments.directory#/#arguments.name#.clj";
		// Create dir if it doesn't exist
		directoryCreate( getDirectoryFromPath( controllerPath ), true, true );
		// Create files
		file action="write" file="#controllerPath#" mode="777" output="#controllerContent#";
		print.greenLine( "Created #controllerPath#" );
		// Open file
		if ( arguments.open ){ openPath( controllerPath ); }	
	}

	private string function scaffoldController(
		required string name,
		array actions = ["default"]
	) {
		savecontent variable="controller" {
			var index = 0;
			writeOutput( "(ns change-me-to-project-name.controllers.#arguments.name#)" & cr & cr );
			arguments.actions.each(function(action, index) {
				writeOutput( "(defn #action# [rc]" & cr );
				writeOutput( chr(32) & chr(32) & '(assoc rc :hello (str "Hello from #action#!")))' );
				if ( index != actions.len() ) { writeOutput( cr & cr ) }
			});
		}

		return controller;
	}
}