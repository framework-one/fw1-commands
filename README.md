# fw1-commands
A collection of commands to be used with CommandBox for working with FW/1

### Installation

- First of all, make sure you have CommandBox installed.
- Open up your favorite terminal and enter `box install fw1-commands`.
- Done! Super simple.

### How it works...

The main feature right now is the ability to generate a application skeleton via the `fw1 create app` command.

**Here's an example:** `fw1 create app myApp examples`

Where `app` is the `app.cfc` command found in the `create` directory of the package, `myApp` is the name of the application package I am generating and `examples` is the skeleton I will be using.

In this case, `examples` isn't so much a skeleton for a real application as it is what its name implies. In fact, it's just a copy of the examples found in the FW/1 repository. With CommandBox we can now add them upon command and start playing right away!

There are 3 other arguments to the `app` command - `directory`, `init` and `installFW1`.

`directory` is a string representing a folder you wish the skeleton to be generated in. If the directory/directory chain does not exist, it will be created. It defaults to the current working directory.

`init` creates a `box.json` template for your app's info and dependencies so that it can play nice with CommandBox (and ForgeBox). It defaults to `true`.

`installFW1` does what it says on the tin. It defaults to `false`. Adding this will make sure FW/1 is installed with your skeleton. _**Skeletons are not generated with the actual framework files!**_ As an example - `fw1 create app myApp examples --installFW1`.
**Note that this part is still in the works as FW/1 needs to be updated on ForgeBox!** In a separate scenario, you will be able to do `box install fw1`.

### What's available? (so far...)

At this time there's only the ability to generate a small handful prearranged application skeletons. These are still a work in progress and subject to modification in order to provide solid content for everyone.

**Here's a list...**

- Examples (the examples and introduction folders from the FW/1 repo) - `fw1 create app myApp examples`
- Skeleton (the skeleton folder from the FW/1 repo) - `fw1 create app myApp skeleton`
- Basic (a bare bones setup for a single application) - `fw1 create app myApp basic`
- Subsystem (a bare bones setup for a application with subsystems) - `fw1 create app myApp subsystem`

### A work in progress!

This is all still being pieced together so some features may change and new features will be added so stay tuned!
