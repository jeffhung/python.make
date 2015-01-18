# ----------------------------------------------------------------------------
# Configurations
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Main targets
# ----------------------------------------------------------------------------

.PHONY: all
all: python-help

include python.make

# ----------------------------------------------------------------------------
# ipython targets
# ----------------------------------------------------------------------------

# See: https://coderwall.com/p/xdox9a
.PHONY: ipython-shell
ipython-shell:
	$(MAKE) python-exec ipython;

.PHONY: ipython-notebook
ipython-notebook:
	$(MAKE) python-exec ipython notebook;

UNAME := $(shell uname | tr A-Z a-z)
SYSTEM_PREFIX := /usr
ifeq ($(UNAME),darwin)
SYSTEM_PREFIX := $(shell brew --prefix)
endif

$(SYSTEM_PREFIX)/include/zmq.h:
ifeq ($(UNAME),darwin)
	brew install zeromq;
endif

# See: http://ipython.org/ipython-doc/stable/install/install.html
# See: https://gist.github.com/westurner/3196564
# See: http://gureckislab.org/courses/spring12/modeling/ipythonhints.html
# See: http://michaelmartinez.in/installing-ipython-notebook-on-mountain-lion.html
# See: https://gist.github.com/juandazapata/3182604
#      https://github.com/settings/applications
# See: http://robots.thoughtbot.com/the-hitchhikers-guide-to-riding-a-mountain-lion
# See: http://nbviewer.ipython.org/gist/z-m-k/4484816/ipyD3sample.ipynb
# See: http://stackoverflow.com/questions/19453430/examples-of-interactive-plots-through-python
.PHONY: ipython
ipython:
	$(MAKE) $(SYSTEM_PREFIX)/include/zmq.h
# XXX: Note that `pip install readline` generally DOES NOT WORK, because
#      it installs to site-packages, which come *after* lib-dynload in
#      sys.path, where readline is located.  It must be `easy_install
#      readline`, or to a custom location on your PYTHONPATH (even --user
#      comes after lib-dyload).
#	$(MAKE) python-readline   # for full readline implementation (use pyreadline instead on Windows)
	$(MAKE) python-nose       # to run the ipython test suite
	$(MAKE) python-pexpect    # to manage subprocesses in ipython.irunner
	$(MAKE) python-pyzmq      # to use ipython.parallel, ipython.notebook
#	$(MAKE) python-paramiko   # to use ssh in ipython.parallel on Windows
	$(MAKE) python-tornado    # http server for ipython.notebook
	$(MAKE) python-Jinja2     # for ipython.notebook to render html pages
	$(MAKE) python-pygments   # to use qtconsole with syntax highlighting
	$(MAKE) python-ipython
	# for rendering LaTeX in web browsers (MathJax is a Javascript library)
	# will install to ~/.ipython/nbextensions/mathjax
#	$(MAKE) python-exec -- python -c "'from IPython.external import mathjax; mathjax.install_mathjax()'";

