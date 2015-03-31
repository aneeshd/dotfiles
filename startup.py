try:
    import readline
except ImportError:
    print "Module readline not available."
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
    readline.parse_and_bind("bind ^I rl_complete")

    import os
    histfile = os.path.join(os.environ["HOME"], ".pyhist")
    try:
        readline.read_history_file(histfile)
    except IOError:
        pass

    import atexit
    atexit.register(readline.write_history_file, histfile)
    del os, histfile

