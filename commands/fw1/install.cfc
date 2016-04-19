/**
* FW/1 Commands - Install FW/1
*/
component displayname="FW/1 Commands - Install FW/1"
	excludeFromHelp=false
{
	public string function run( boolean dev = false ) {
		dev
		? command( "install" ).params( id = "fw1-dev", directory = fileSystemUtil.resolvePath( getCWD() ) ).run()
		: command( "install" ).params( id = "fw1", directory = fileSystemUtil.resolvePath( getCWD() ) ).run();
	}
}