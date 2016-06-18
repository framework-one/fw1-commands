component {
	public void function configure() {
		settings = {
			"resources": {
				"skeletons": "#modulePath#/resources/skeletons/",
				"templates": "#modulePath#/resources/templates/"
			},
			"version": "2.1.0"
		};
	}

	public any function onCLIStart( required struct interceptData ) {  }
}