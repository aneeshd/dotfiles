#!/usr/bin/env python

import sys
from git import Repo
import os

#for t in r.submodule('idsapps').module().tags: print t

def is_branch_in_all_submodules(args):
    #print args
    ret=0
    r=Repo(os.getcwd())
    branch=args[1]
    for submodule in r.submodules:
        #print submodule
        #s=r.submodule(submodule)
        #print s
        s=submodule.module().remotes['origin']
        #print s
        branches=s.refs
        #print len(branches), branches
        found=False
        for b in branches:
            #print '-->', b
            if branch==str(b):
                found=True
                break
        if not found:
        #if branch not in branches:
            print branch, 'not found in', submodule
            ret=1
    return ret

def what_submodules_have_branch(args):
    ret=0
    r=Repo(os.getcwd())
    branch=args[1]
    for submodule in r.submodules:
        s=submodule.module().remotes['origin']
        branches=s.refs
        found=False
        for b in branches:
            if branch==str(b):
                found=True
                print branch, 'found in', submodule
                break
    return ret


def action2(*args):
    print 'action2', args
    return 0

if __name__=='__main__':
    cmd=sys.argv[1]
    cmd=cmd.replace('-', '_')
    if cmd in dir():
        ret=locals()[cmd](sys.argv[1:])
    else:
        ret=1
    sys.exit(ret)
