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
* fw1 create subsystem mySubsystem my/directory
* {code}
*/
component displayname="FW/1 Create Subsystem Command"
	excludeFromHelp=false
{
	property name="settings" inject='commandbox:moduleSettings:fw1-commands';
	
	/**
	* @name.hint The name of the subsystem being created.
	* @directory.hint The directory to create the subsytem in. Defaults to the subsystem name passed in.
	*/
	public void function run(
		required string name,
		string directory = "subsystems"
	) {
		var templates = settings.resources.templates;
		// This will make the directory canonical and absolute
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		// Validate directory, if it doesn't exist, create it
		if ( !directoryExists( arguments.directory & "/" & arguments.name ) ) {
			directoryCreate( arguments.directory & "/" & arguments.name );
		}
		// Unzip the skeleton
		zip action="unzip" destination="#arguments.directory#/#arguments.name#" file="#templates#SubsystemTemplate.zip";
		// Success message
		print.line().greenLine(
			"#arguments.name# subsystem successfully created in [#arguments.directory#]"
		);
	}
}