/**
* FW/1 Commands Version Info
*/
component displayname="FW/1 Commands Version Info"
	excludeFromHelp=false
{
	property name="settings" inject='commandbox:moduleSettings:fw1-commands';

	public string function run() {
		return "FW/1 Commands Version #settings.version#";
	}
}