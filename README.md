# fw1-commands (v1.0.0)
### A collection of CommandBox commands for working with FW/1

## Installation

1. First, make sure you have <a href="http://ortus.gitbooks.io/commandbox-documentation/content/setup/installation.html" target="_blank">CommandBox installed</a>.
2. Fire up your terminal and drop into CommandBox by entering `box`.
3. Install FW/1 Commands by entering `install fw1-commands`.
4. Done!

<br>

## Getting Started

#### Application Skeleton Generation With `fw1 create app`

To get started quickly, _FW/1 Commands_ comes with a `create app` command that can be used to generate a ready-to-go application skeleton for you.

###### _A simple example:_

> `fw1 create app MyApp Basic`

To break it down further, `fw1` is the alias used that tells CommandBox that we are using _FW/1 Commands_. `create app` is instructing to use the `app` command located in the `create` driectory (check out the actual file structure of the command bundle to get a better idea). `MyApp` is the first parameter to be passed to the `app` command. This is the name of your application. `Basic` is the skeleton we chose to use as the base medium for out application structure.

<br>

## A Deeper Look Into `create app`

###### `create app` can take up to 5 parameters.

- `name` (type: string) - The name of your application. Defaults to "My FW/1 App" if no name is supplied.
- `skeleton` (type: string) - The skeleton structure to generate. Defaults to `basic`.
- `directory` (type: string) - The directory to generate the application skeleton in. If it does not exist, it will be created. Defaults to the current working directory.
- `installFW1` (type: boolean) - Flags whether to install the latest version FW/1. Defaults to `false`.
- `package` (type: boolean) - Flags whether to create a `box.json`. Defaults to `true`.

<br>

#### Available Skeletons

- *Examples*: (the examples and introduction folders from the FW/1 repo) - `fw1 create app myApp examples`
- *Skeleton*: (the skeleton folder from the FW/1 repo) - `fw1 create app myApp skeleton`
- *Basic*: (a bare bones setup for a single application) - `fw1 create app myApp basic`
- *Subsystem*: (a bare bones setup for a application using subsystems 2.0 released with FW/1 3.5) - `fw1 create app myApp subsystem`
- *Subsystem Legacy*: (a bare bones setup for a application using subsystems prior to 2.0) - `fw1 create app myApp subsystem-legacy`

<br>

#### Choosing A Directory to Generate In

By default, _FW/1 Commands_ assumes that the current directory you are in on the command line is your current working directory and will generate the application in said directory. Should you need to install elsewhere, you can override this by passing in a path as the third parameter.

###### _Example:_

> `fw1 create app MyApp basic path/to/my/directory`

<br>

#### Including Framework One With Your New Application

By default, FW/1 is not included with generated skeletons. The option to to use the master or development release is up to you.

`create app` comes with a fourth parameter, `installFW1`, that when set to `true` will install the latest stable releast of FW/1. When you are in the working directory you want FW/1 to be installed in, you can pass the parmaeter in with double dashes.

###### _Examples installing FW/1:_

> _Create in current working directory._ - `fw1 create app MyApp basic --installFw1`  
> _Create in a specified directory._ - `fw1 create app MyApp basic path/to/directory true`

To manually install the latest version of FW/1 all you need to do is enter this command in the command line: `install fw1`. To include the dev release, it's the same command but with that release's version number. For example: `install fw1-4.0.0`. Note that the version number must reflect what is available on ForgeBox. To install directly from Github you can do this: `install https://github.com/framework-one/fw1/archive/develop.zip`.

<br>

#### Generating Your Application as a Package

To follow in the CommandBox/ForgeBox scheme of things, a `box.json` with basic package information is generated with your application. This makes your app capable of being added to ForgeBox for others to use and also makes installing it with CommandBox super simple.

By default this option is set to `true` but can be altered like so: `fw1 create app MyApp basic / false false`

<br>

## Scaffolding Individual Parts of Your Application

#### Generating Views With `fw1 create view`

###### `create view` takes up to 2 parameters.

- `name` (type: string, _required_) - The name of your view.
- `directory` (type: string) - The directory to generate the view in. If it does not exist, it will be created. Defaults to looking for the `views` directory in your current working directory.

###### _Examples:_

> _Create in current working directory._ - `fw1 create view myView`  
> _Create in specified directory._ - `fw1 create view myView my/directory`

<br>

#### Generating Controllers With `fw1 create controller`

###### `create controller` takes up to 6 parameters.

- `name` (type: string, _required_) - The name of your controller.
- `actions` (type: string) - The actions to be included in your controller. A comma delimited list of action names can be passed to create multiple actions. By default, only `default` is generated in the controller.
- `directory` (type: string) - The directory to generate the controller in. If it does not exist, it will be created. Defaults to looking for the `controllers` directory in your current working directory.
- `views` (type: boolean) - A flag to determine whether to generate views for each action. Defaults to `true`.
- `viewsDirectory` (type: string) - The directory to generate the controller's views in. If it does not exist, it will be created. Defaults to looking for the `views` directory in path supplied to the `directory` parameter.
- `open` (type: boolean) - A flag to determine whether to open the generated controller for editing right away. Opens in your machine's default editor. Defaults to `false`.

###### _Examples:_

> _Create in current working directory._ - `fw1 create controller myController`  
> _Create with multiple actions._ - `fw1 create controller myController list,add,edit,delete`  
> _Create and open in editor._ - `fw1 create controller myController myAction --open`  
> _Create in specified directory._ `fw1 create controller myController myAction my/controller/directory`  
> _Create and generate views for each action._ - `fw1 create controller myController myAction controllers true`  
> _Create controller, views and specify the views directory._ - `fw1 create controller myController myAction controllers true my/view/directory`  
> _Create controller, views and open in editor._ -  `fw1 create controller myController myAction controllers true my/view/directory true`

<br>

#### Generating Layouts With `fw1 create layout`

###### `create layout` takes up to 2 parameters.

- `name` (type: string, _required_) - The name of your layout.
- `directory` (type: string) - The directory to generate the layout in. If it does not exist, it will be created. Defaults to looking for the `layouts` directory in your current working directory.

###### _Examples:_

> _Create in current working directory._ - `fw1 create layout myLayout`  
> _Create in specified directory._ `fw1 create layout myLayout my/layouts`

<br>

#### Generating Beans With `fw1 create bean`

###### `create bean` takes up to 4 parameters.

- `name` (type: string, _required_) - The name of your bean. A comma delimited list of beans can be passed to be created in bulk. To specify "package" directorys, include the base path to be found/generated. Example: package/path/to/Bean.
- `directory` (type: string) - The directory to generate the bean in. If it does not exist, it will be created. Defaults to looking for the `model/beans` directory in your current working directory.
- `camelCase` (type: boolean) - A flag to determine the naming convention of the bean file to be in _camel case_ format. For example: _MyBean.cfc_. Defaults to `true`.
- `open` (type: boolean) - A flag to determine whether to open the generated bean for editing right away. Opens in your machine's default editor. Defaults to `false`.

###### _Examples:_

> _Create in current working directory._ - `fw1 create bean MyBean`  
> _Create and open in editor._ - `fw1 create bean MyBean --open`  
> _Create and specify package directory structure._ - `fw1 create bean package/path/for/MyBean`  
> _Create multiple beans._ - `fw1 create bean MyBean,MyOtherBean`  
> _Create in specified directory._ - `fw1 create bean MyBean path/to/beans`  
> _Create without camel case formatted file name._ - `fw1 create bean MyBean model/beans false`  
> _Create without camel case formatted file name and open in editor._ - `fw1 create bean MyBean model/beans false true`

<br>

#### Generating Services With `fw1 create service`

###### `create service` takes up to 4 parameters.

- `name` (type: string, _required_) - The name of your service. A comma delimited list of services can be passed to be created in bulk. To specify "package" directorys, include the base path to be found/generated. Example: package/path/to/Service.
- `directory` (type: string) - The directory to generate the service in. If it does not exist, it will be created. Defaults to looking for the `model/services` directory in your current working directory.
- `camelCase` (type: boolean) - A flag to determine the naming convention of the service file to be in _camel case_ format. For example: _MyService.cfc_. Defaults to `true`.
- `open` (type: boolean) - A flag to determine whether to open the generated service for editing right away. Opens in your machine's default editor. Defaults to `false`.

###### _Examples:_

> _Create in current working directory._ - `fw1 create service MyService`  
> _Create and open in editor._ - `fw1 create service MyService --open`  
> _Create and specify package directory structure._ - `fw1 create service package/path/for/MyService`  
> _Create multiple services._ - `fw1 create service MyService,MyOtherService`  
> _Create in specified directory._ - `fw1 create service MyService path/to/services`  
> _Create without camel case formatted file name._ - `fw1 create service MyService model/services false`  
> _Create without camel case formatted file name and open in editor._ - `fw1 create service MyService model/services false true`

<br>

#### Generating Subsytem Skeletons With `fw1 create subsystem`

###### `create subsystem` takes up to 2 parameters and will generate a bare bones subsytem file structure.

- `name` (type: string, _required_) - The name of your subsystem.
- `directory` (type: string) - The directory to generate the subsystem in. If it does not exist, it will be created. Defaults to looking for the `subsystems` directory in your current working directory based on the Subsystem 2.0 convention released with FW/1 3.5.

###### _Examples:_

> _Create from current working directory._ - `fw1 create subsystem mysubsystem`  
> _Create in specified directory._ - `fw1 create subsystem mysubsystem my/subsystems`

<br>

#### Generating Clojure Controllers For FW/1 3.5+ With `fw1 create clj-controller`

###### `create clj-controller` takes up to 4 parameters.

- `name` (type: string, _required_) - The name of your controller.
- `actions` (type: string) - The actions to be included in your controller. A comma delimited list of action names can be passed to create multiple actions. By default, only `default` is generated in the controller.
- `directory` (type: string) - The directory to generate the controller in. If it does not exist, it will be created. Defaults to looking for the `controllers` directory in your current working directory.
- `open` (type: boolean) - A flag to determine whether to open the generated controller for editing right away. Opens in your machine's default editor. Defaults to `false`.

###### _Examples:_

> _Create in current working directory._ `fw1 create clj-controller my-controller`  
> _Create with multiple actions._ - `fw1 create clj-controller my-controller list,add,edit,delete`  
> _Create and open in editor._ - `fw1 create clj-controller my-controller --open`  
> _Create in specified directory._ - `fw1 create clj-controller my-controller my-action my/controller/directory`  
> _Create, specify actions, directory and open in editor._ - `fw1 create clj-controller my-controller my-action controllers true`

<br>

#### Generating Clojure Services For FW/1 3.5+ With `fw1 create clj-service`

###### `create clj-service` takes up to 3 parameters.

- `name` (type: string, _required_) - The name of your service. A comma delimited list of services can be passed to be created in bulk. To specify "package" directorys, include the base path to be found/generated. Example: package/path/to/Service.
- `directory` (type: string) - The directory to generate the service in. If it does not exist, it will be created. Defaults to looking for the `services` directory in your current working directory.
- `open` (type: boolean) - A flag to determine whether to open the generated service for editing right away. Opens in your machine's default editor. Defaults to `false`.

###### _Examples:_

> _Create in current working directory._ - `fw1 create clj-service my-service`  
> _Create and open in editor._ - `fw1 create clj-service my-service --open`  
> _Create and specify package directory structure._ - `fw1 create clj-service package/path/for/my-service`  
> _Create multiple services._ - `fw1 create clj-service my-service,my-other-service`  
> _Create in specified directory._ - `fw1 create clj-service my-service path/to/services`  
> _Create, specify directory and open in editor._ - `fw1 create clj-service my-service services true`
