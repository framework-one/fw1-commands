// BASED FROM THE COLDBOX "APP.CFC" COMMAND - https://github.com/Ortus-Solutions/commandbox/tree/master/src/cfml/commands/coldbox/create
/**
* Create a individual FW/1 subsystem skeleton structure.
* .
* {code:bash}
* fw1 create subsystem mySubsystem
* {code}
* .
* By default, the subsystem will be created in the current working directory
* but can be overridden.
* .
* {code:bash}
* fw1 create subsystem mySubsystem myDirectory
* {code}
*/
component displayname="FW/1 Create Subsystem Command"
	extends="commandbox.system.BaseCommand"
	excludeFromHelp=false
{
	/**
	* @name.hint The name of the app being created.
	* @directory.hint The directory to create the app in. Defaults to the subsystem name passed in.
	*/
	public void function run(
		required string name,
		string directory = getCWD()
	) {
		var skeletonLocation = getDirectoryFromPath( getCurrentTemplatePath() )  & "/../resources/templates/";
		// This will make the directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Validate directory, if it doesn't exist, create it
		if ( !directoryExists( arguments.directory & "/" & arguments.name ) ) {
			directoryCreate( arguments.directory & "/" & arguments.name );
		}
		// Unzip the skeleton
		zip action="unzip" destination="#arguments.directory#/#arguments.name#" file="#skeletonLocation#SubsystemTemplate.zip";
		// Success message
		print.line().greenLine(
			"#arguments.name# FW/1 subsystem successfully created in [#arguments.directory#]"
		);
	}
}