// BASED FROM THE COLDBOX "CONTROLLER.CFC" COMMAND - https://github.com/Ortus-Solutions/commandbox/tree/master/src/cfml/commands/coldbox/create
/**
* Create a new bean in an existing FW/1 application.
* .
* {code:bash}
* fw1 create bean MyBean
* {code}
* .
* The command can also take a list of bean names.
* .
* {code:bash}
* fw1 create bean MyBean,MyOtherBean
* {code}
* .
* By default, the bean will be created in /model/beans but can be
* overridden.
* .
* {code:bash}
* fw1 create bean MyBean myDirectory
* {code}
* .
* Bean file names are formatted as initial caps.
* This can be altered by setting initialCaps to false.
* .
* {code:bash}
* fw1 create bean MyBean /model/beans false
* {code}
* .
* Once created, the bean can be opened in your default editor by
* setting the "open" param to true.
* .
* {code:bash}
* fw1 create bean MyBean --open
* {code}
*/
component displayname="FW/1 Create Bean Command"
	extends="commandbox.system.BaseCommand"
	excludeFromHelp=false
{
	/**
	* @name.hint Name of the bean to create. For packages, specify name as 'myPackage/MyBean'
	* @directory.hint The base directory to create your bean in. Defaults to 'beans'.
	* @open.hint Open the bean once generated.
	*/
	public void function run( 	
		required string name,
		string directory = "model/beans",
		boolean initialCaps = true,
		boolean open = false
	) {
		// This will make each directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Validate directory
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// Generate beans
		for ( var bean in listToArray( arguments.name ) ) {
			// Allow dot-delimited paths
			bean = replace( bean, ".", "/", "all" );
			// Make bean name intital caps?
			var beanName = arguments.initialCaps
				? reReplace( listLast( bean, "/" ), "\b(\w)", "\u\1", "all" )
				: listLast( bean, "/" );
			// This help readability so the success messages aren't up against the previous command line
			print.line();
			// Generate bean with init function
			savecontent variable="beanContent" {
				writeOutput( "component {" & cr );
				writeOutput( chr(9) & "public #beanName# function init() {" & cr );
				writeOutput( chr(9) & chr(9) & "return this;" & cr );
				writeOutput( chr(9) & "}" );
				writeOutput( cr & "}" );
			}
			var beanPath = "#arguments.directory#/#beanName#.cfc";
			// Create dir if it doesn't exist
			directoryCreate( getDirectoryFromPath( beanPath ), true, true );
			// Create files
			file action="write" file="#beanPath#" mode="777" output="#beanContent#";
			print.greenLine( "Created #beanPath#" );
			// Open file
			if ( arguments.open ){ openPath( beanPath ); }
		}		
	}
}