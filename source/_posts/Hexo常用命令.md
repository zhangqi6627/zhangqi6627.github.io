---
title: Hexo常用命令
date: 2018-07-25 16:59:22
tags:
---
# QuickStart
### Installation

``` bash
$ npm install hexo-cli -g
```

### Quick Start

**Setup your blog**

``` bash
$ hexo init blog
$ cd blog
```

**Start the server**

``` bash
$ hexo server
```

**Create a new post**

``` bash
$ hexo new "Hello Hexo"
```

**Generate static files**

``` bash
$ hexo generate
```



### init
```
$ hexo init [folder]
```
Initializes a website. If no folder is provided, Hexo will set up the website in the current directory.

### new
```
$ hexo new [layout] <title>
```
Creates a new article. If no layout is provided, Hexo will use the default_layout from _config.yml. If the title contains spaces, surround it with quotation marks.

### generate
```
$ hexo generate
```
Generates static files.

Option	Description
-d, --deploy	Deploy after generation finishes
-w, --watch	Watch file changes
-b, --bail	Raise an error if any unhandled exception is thrown during generation
-f, --force	Force regenerate


### publish
```
$ hexo publish [layout] <filename>
```
Publishes a draft.

### server
```
$ hexo server
```
Starts a local server. By default, this is at http://localhost:4000/.

Option	Description
-p, --port	Override default port
-s, --static	Only serve static files
-l, --log	Enable logger. Override logger format.

### deploy
```
$ hexo deploy
```
Deploys your website.

Option	Description
-g, --generate	Generate before deployment

### render
```
$ hexo render <file1> [file2] ...
```
Renders files.

Option	Description
-o, --output	Output destination

### migrate
```
$ hexo migrate <type>
```
Migrates content from other blog systems.

### clean
```
$ hexo clean
```
Cleans the cache file (db.json) and generated files (public).

### list
```
$ hexo list <type>
```
Lists all routes.

### version
```
$ hexo version
```
Displays version information.

Options
### Safe mode
```
$ hexo --safe
```
Disables loading plugins and scripts. Try this if you encounter problems after installing a new plugin.

### Debug mode
```
$ hexo --debug
```
Logs verbose messages to the terminal and to debug.log. Try this if you encounter any problems with Hexo. If you see errors, please raise a GitHub issue.

### Silent mode
```
$ hexo --silent
```
Silences output to the terminal.

### Customize config file path
```
$ hexo --config custom.yml
```
Uses a custom config file (instead of _config.yml). Also accepts a comma-separated list (no spaces) of JSON or YAML config files that will combine the files into a single _multiconfig.yml.

```
$ hexo --config custom.yml,custom2.json
```

### Display drafts
```
$ hexo --draft
```
Displays draft posts (stored in the source/_drafts folder).

### Customize CWD
```
$ hexo --cwd /path/to/cwd
```
Customizes the path of current working directory.