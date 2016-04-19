/**
* Create a new service in an existing FW/1 application.
* .
* {code:bash}
* fw1 create service MyService
* {code}
* .
* The command can also take a list of services to create.
* .
* {code:bash}
* fw1 create service MyService,MyOtherService
* {code}
* .
* By default, the service will be created in "/model/services" but can be
* overridden.
* .
* {code:bash}
* fw1 create service MyService my/directory
* {code}
* .
* Service file names are formatted as camel case.
* This can be altered by setting camelCase to false.
* .
* {code:bash}
* fw1 create service MyService /model/services false
* {code}
* .
* Once created, the service can be opened in your default editor by
* setting the "open" param to true.
* .
* {code:bash}
* fw1 create service MyService --open
* {code}
*/
component displayname="FW/1 Create service Command"
	excludeFromHelp=false
{
	/**
	* @name.hint Name of the service to create. For packages, specify name as 'my/package/MyService'
	* @directory.hint The base directory to create your service in. Defaults to 'services'.
	* @open.hint Open the service once generated.
	*/
	public void function run( 	
		required string name,
		string directory = "model/services",
		boolean camelCase = true,
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
			// Make service name intital caps?
			var serviceName = camelCase
				? service.listLast( "/" ).reReplace( "\b(\w)", "\u\1", "all" )
				: service.listLast( "/" );
			// This helps readability so the success messages aren't up against the previous command line
			print.line();
			// Generate service with init function
			savecontent variable="serviceContent" {
				writeOutput( 'component displayname="#serviceName# service" {' & cr );
				writeOutput( chr(9) & "public #serviceName# function init() {" & cr );
				writeOutput( chr(9) & chr(9) & "return this;" & cr );
				writeOutput( chr(9) & "}" );
				writeOutput( cr & "}" );
			}
			var servicePath = "#directory#/#serviceName#.cfc";
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