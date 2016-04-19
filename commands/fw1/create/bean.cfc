/**
* Create a new bean in an existing FW/1 application.
* .
* {code:bash}
* fw1 create bean MyBean
* {code}
* .
* The command can also take a list of beans.
* .
* {code:bash}
* fw1 create bean MyBean,MyOtherBean
* {code}
* .
* By default, the bean will be created in "/model/beans" but can be
* overridden.
* .
* {code:bash}
* fw1 create bean MyBean myDirectory
* {code}
* .
* Bean file names are formatted as camel case.
* This can be altered by setting camelCase to false.
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
	excludeFromHelp=false
{
	/**
	* @name.hint Name of the bean to create. For packages, specify name as 'myPackage/MyBean'
	* @directory.hint The base directory to create your bean in. Defaults to 'beans'.
	* @camelCase.hint Generate the bean file name as camel case.
	* @open.hint Open the bean once generated.
	*/
	public void function run( 	
		required string name,
		string directory = "model/beans",
		boolean camelCase = true,
		boolean open = false
	) {
		// This will make each directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Validate directory
		if ( !directoryExists( arguments.directory ) ) { directoryCreate( arguments.directory ); }
		// Generate beans
		arguments.name.listToArray().each(function( bean ) {
			// Allow dot-delimited paths
			bean = bean.replace( ".", "/", "all" );
			// Make bean name intital caps?
			var beanName = camelCase
				? bean.listLast( "/" ).reReplace( "\b(\w)", "\u\1", "all" )
				: bean.listLast( "/" );
			// This helps readability so the success messages aren't up against the previous command line
			print.line();
			// Generate bean with init function
			savecontent variable="beanContent" {
				writeOutput( 'component displayname="#beanName# bean" {' & cr );
				writeOutput( chr(9) & "public #beanName# function init() {" & cr );
				writeOutput( chr(9) & chr(9) & "return this;" & cr );
				writeOutput( chr(9) & "}" );
				writeOutput( cr & "}" );
			}
			var beanPath = "#directory#/#beanName#.cfc";
			// Create dir if it doesn't exist
			directoryCreate( getDirectoryFromPath( beanPath ), true, true );
			// Create files
			file action="write" file="#beanPath#" mode="777" output="#beanContent#";
			print.greenLine( "Created #beanPath#" );
			// Open file
			if ( open ){ openPath( beanPath ); }
		});	
	}
}