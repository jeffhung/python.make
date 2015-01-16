python.make
===========

The `python.make` file is a `Makefile` module for python development that use
[GNU make][gmake] to build a local python development environment using
[virtualenv][virtualenv], and simplify [pip][pip] package management from
outside.

[virtualenv]: https://virtualenv.pypa.io/
[pip]: https://pypi.python.org/pypi/pip
[gmake]: http://www.gnu.org/software/make/


Usage
-----

Use the `-f` option to load and use `python.make`:

	$ make -f python.make
	Usage: make [ TARGET ... ]
	
	These python-* make targets help you manage a python development environment
	in local via virtualenv(1) and pip(1) inside it.
	
	  python-help       - show this help message
	  python-runtime    - bootstrap a virtualenv runtime environment
	  python-destroy    - destroy the virtualenv runtime environment
	  python-pip        - run pip(1) command inside the virtualenv runtime
	  python-shell      - enter python shell inside the virtualenv runtime
	  python-exec       - run shell commands inside the virtualenv runtime
	  python-%          - install the pip module which called %
	  python-freeze     - save installed pip modules in requirements.txt
	  python-module M   - generate boilerplate files for new module M
	
	The virtualenv (v1.11.4) runtime environment is located at this path:
	  /path/to/current/folder/runtime

Or you can write your main makefile like following to merge `python.make` make
targets in:

	.PHONY: all
	all: python-help
	
	...
	
	include python.make


Install
-------

Copy the `python.make` file into the top-level folder of your project.

Or download with [curl](http://curl.haxx.se/) directly:

	curl -O https://raw.githubusercontent.com/jeffhung/python.make/master/python.make

Or with [wget](https://www.gnu.org/software/wget/):

	wget https://raw.githubusercontent.com/jeffhung/python.make/master/python.make


Targets
-------

Assumes the current folder is `~/work` and have merged `python.make` make
targets in.

The make targets provided by `python.make` are prefixed with `python-` so you
can use them easily with auto-completion:

	$ make python-<TAB>
	python-%        python-exec     python-help     python-pip      python-shell
	python-destroy  python-freeze   python-module   python-runtime

### python-help

Show help message of `python.make`:

	$ make python-help
	...

### python-runtime

Bootstrap your development environment in local:

	$ make python-runtime
	mkdir -p ~/work/runtime;
	python ~/work/.cache/virtualenv/virtualenv.py ~/work/runtime;
	New python executable in ~/work/runtime/bin/python
	Installing setuptools, pip...done.

### python-pip

Search pip modules in virtualenv:

	$ make python-pip search ralc
	. ~/work/runtime/bin/activate; pip search ralc;
	ColanderAlchemy           - Autogenerate Colander schemas based on SQLAlchemy models.
	python-mistralclient      - Mistral Client Library
	ralc                      - Rate Calculator.
	referral_candy            - ReferralCandy Python API Client

List installed pip modules in virtualenv:

	$ make python-pip list
	. ~/work/runtime/bin/activate; pip list;
	pip (1.5.4)
	setuptools (2.2)
	wsgiref (0.1.2)

### python-%

Install any pip module you want in virtualenv, with prefix `python-` added in front of package name:

	$ make python-ralc
	. ~/work/runtime/bin/activate; \
	pip install --download-cache ~/work/.cache/pip ralc;
	Downloading/unpacking ralc
	  Using download cache from ~/work/.cache/pip/https%3A%2F%2Fpypi.python.org%2Fpackages%2Fsource%2Fr%2Fralc%2Fralc-0.1.tar.gz
	  Running setup.py (path:~/work/runtime/build/ralc/setup.py) egg_info for package ralc
	
	Installing collected packages: ralc
	  Running setup.py install for ralc
	
	    Installing ralc script to ~/work/runtime/bin
	Successfully installed ralc
	Cleaning up...

### python-exec

Run any command in virtualenv while using `--` to avoid options captured by `make`:

	$ make python-exec -- ralc 30 20
	. ~/work/runtime/bin/activate; ralc 30 20;
	> 30.00 x 20.00 = 600.00

### python-shell

Run python interactively with all modules you installed in local:

	$ make python-shell
	. ~/work/runtime/bin/activate; python;
	Python 2.7.5 (default, Mar  9 2014, 22:15:05)
	[GCC 4.2.1 Compatible Apple LLVM 5.0 (clang-500.0.68)] on darwin
	Type "help", "copyright", "credits" or "license" for more information.
	>>>

### python-freeze

Take a snapshot of current dependencies in `requirements.txt`:

	$ make python-freeze
	. ~/work/runtime/bin/activate; pip freeze > requirements.txt;

### python-module

Create new module `foo` in current folder with module skeleton generated:

	$ make python-module foo \
	       version=1.2.3 \
	       author='Jeff Hung' email=name@example.com \
	       url=https://github.com/jeffhung/python.make \
	       summary='one line summary to describe this new module' \
	       description='multiline description of this new module' \
	       license=mit copyright='blah~'
	. ~/work/runtime/bin/activate; pip freeze > requirements.txt;
	Making new python module 'foo'...
	mkdir -p foo;
	Generate foo/__init__.py
	Generate setup.py
	Generate MANIFEST.in
	Generate LICENSE

The `version`, `author`, `email`, `url`, `summary`, `description`, and
`license` parameters are optional. Please specify them to override the default
values.

By default the `author`, `email`, and `url` parameters will be automatically
discovered from your git and github configurations. The `author` will be the
value of your `user.name` git configuration. The `email` will be the value of
your `user.email` git configuration. And `url` will be a github repository url
composed by your github username and name of this new python module.

By default `license` is empty. If `license` is empty, the new python module is
considered a private work that all rights are reserved to the author (auto
discovered or specified by the `author` parameter). Otherwise, a `LICENSE` file
will be generated using the [lice][lice] tool.  That means the valid value of
`license` parameter could be any of the followings: `agpl3`, `apache`, `bsd2`,
`bsd3`, `cddl`, `cc0`, `epl`, `gpl2`, `gpl3`, `lgpl`, `mit`, or `mpl`.

[lice]: https://pypi.python.org/pypi/lice

### python-destroy

Destory and wipe out the local virtualenv runtime environment:

	make python-destroy
	rm -rf ~/work/runtime;


References
----------

See also:

  * [Virtualenv and Makefiles](http://blog.bottlepy.org/2012/07/16/virtualenv-and-makefiles.html)
  * [bootstrapper](https://pypi.python.org/pypi/bootstrapper)

