/**
* Create a new Clojure service in an existing FW/1 application.
* NOTE: This command assumes you are working in the base directory of
* the Clojure application generated to work with FW/1!
* .
* {code:bash}
* fw1 create service my-service
* {code}
* .
* The command can also take a list of services to create.
* .
* {code:bash}
* fw1 create service my-service,my-other-service
* {code}
* .
* By default, the service will be created in "/services" but can be
* overridden.
* .
* {code:bash}
* fw1 create service my-service my/directory
* {code}
* .
* Once created, the service can be opened in your default editor by
* setting the "open" param to true.
* .
* {code:bash}
* fw1 create service my-service --open
* {code}
*/
component displayname="FW/1 Create Clojure Service Command"
	excludeFromHelp=false
{
	/**
	* @name.hint Name of the service to create. For packages, specify name as 'my/package/my-service'
	* @directory.hint The base directory to create your service in. Defaults to 'services'.
	* @open.hint Open the service once generated.
	*/
	public void function run( 	
		required string name,
		string directory = "services",
		boolean open = false
	) {
		// This will make each directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Validate directory
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// Generate services
		arguments.name.listToArray().each(function( service ) {
			// Allow dot-delimited paths
			service = service.replace( ".", "/", "all" );
			// Grab service name from possible package structure in name parameter
			var serviceName = service.listLast( "/" );
			// This helps readability so the success messages aren't up against the previous command line
			print.line();
			// Generate service with dummy function
			savecontent variable="serviceContent" {
				writeOutput( "(ns change-me-to-project-name.services.#serviceName#)" & cr & cr );
				writeOutput( "(defn hello-world []" & cr );
				writeOutput( chr(32) & chr(32) & '(str "Hello from #serviceName# service!"))' );
			}
			var servicePath = "#directory#/#service#.clj";
			// Create dir if it doesn't exist
			directoryCreate( getDirectoryFromPath( servicePath ), true, true );
			// Create files
			file action="write" file="#servicePath#" mode="777" output="#serviceContent#";
			print.greenLine( "Created #servicePath#" );
			// Open file
			if ( open ){ openPath( servicePath ); }
		});	
	}
}