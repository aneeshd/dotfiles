import sys
if sys.version_info.major==2:
    try:
        import readline
    except ImportError:
        #print "Module readline not available."
        pass
    else:
        import rlcompleter
        readline.parse_and_bind("tab: complete")
        if 'libedit' in readline.__doc__:
            readline.parse_and_bind("bind ^I rl_complete")
        else:
            readline.parse_and_bind("tab: complete")

        import os
        histfile = os.path.join(os.environ["HOME"], ".pyhist")
        try:
            readline.read_history_file(histfile)
        except IOError:
            pass

        import atexit
        atexit.register(readline.write_history_file, histfile)
        del os, histfile

#import sys
#sys.path.append('/usr/local/lib/python2.7/site-packages/')

