#!/usr/bin/env python

import sys
import os
import argparse

try:
    from git import Repo
except ImportError:
    print 'GitPython missing; try pip install gitpython'
    sys.exit(1)


def __get_branches(local, remote, submodule):
    if local:
        s=submodule.module()
        return s.heads
    else:
        s=submodule.module().remotes[remote]
        return s.refs

def _get_branches(opt, submodule):
    return __get_branches(opt.local, opt.remote, submodule)

def _get_all_branches(opt, submodule):
    return __get_branches(False, opt.remote, submodule)+__get_branches(True, opt.remote, submodule)

def is_branch_in_all_submodules(opt, args):
    '''Determine if a remote branch exists in all submodules.
    
    USAGE: branch-name
    '''
    ret=0
    r=Repo(os.getcwd())
    branch=args[0]
    for submodule in sorted(r.submodules):
        branches=_get_branches(opt, submodule)
        found=False
        for b in branches:
            if branch==str(b):
                found=True
                break
        if not found:
            print branch, 'not found in', submodule
            ret=1
    return ret

def what_submodules_have_branch(opt, args):
    '''Determine what submodules have a certain remote branch.
    
    USAGE: branch-name
    '''
    ret=0
    r=Repo(os.getcwd())
    branch=args[0]
    for submodule in sorted(r.submodules):
        # s=submodule.module().remotes[opt.remote]
        # branches=s.refs
        branches=_get_branches(opt, submodule)
        found=False
        for b in branches:
            if branch==str(b):
                found=True
                if opt.verbose: print branch, 'found in', 
                print submodule
                break
    return ret

def show_all_branches(opt, args):
    '''Show all branches in all submodules.
    '''
    ret=0
    r=Repo(os.getcwd())
    for submodule in sorted(r.submodules):
        branches=_get_branches(opt, submodule)
        for b in branches:
            print submodule, '::', b, '::', b.object
    return ret

def are_branches_equal(opt, args):
    '''Print submodule names for which two given remote branches are equal.
    
    USAGE: branch-name1 branch-name2
    '''
    ret=0
    r=Repo(os.getcwd())
    b1=args[0]
    b2=args[1]
    for submodule in sorted(r.submodules):
        branches=_get_all_branches(opt, submodule)
        branch_names=[str(b) for b in branches]
        if b1 in branch_names and b2 in branch_names:
            b1obj=branches[branch_names.index(b1)]
            b2obj=branches[branch_names.index(b2)]
            if b1obj.object==b2obj.object:
                print submodule,
                if opt.verbose:
                    print '::', b1obj.object, b1, b2
                else:
                    print
    return ret

def delete_remote_branch(opt, args):
    '''Delete a remote branch from each of the specified submodules.
    
    USAGE: branch-name submodule1 ... submoduleN
    '''
    if opt.local:
        print 'only supported for remote branches'
        return 1
    branch=args[0]
    submodules=args[1:]
    r=Repo(os.getcwd())
    for submodule in sorted(r.submodules):
        # s=submodule.module().remotes[opt.remote]
        # branches=s.refs
        branches=_get_branches(opt, submodule)
        branch_names=[str(b) for b in branches]
        rlen=len(opt.remote)+1
        if branch in branch_names:
            cmd='git push %s :%s'%(opt.remote, branch[rlen:])
            os.system('cd %s && %s'%(submodule.module().working_dir, cmd))
    return 0

def delete_branch(opt, args):
    '''Delete a local branch from each of the specified submodules.
    
    USAGE: branch-name submodule1 ... submoduleN
    '''
    if not opt.local:
        print 'only supported for local branches'
        return 1
    branch=args[0]
    submodules=args[1:]
    r=Repo(os.getcwd())
    for submodule in sorted(r.submodules):
        branches=_get_branches(opt, submodule)
        branch_names=[str(b) for b in branches]
        if branch in branch_names:
            cmd='git branch -d %s'%(branch,)
            #print cmd
            os.system('cd %s && %s'%(submodule.module().working_dir, cmd))
    return 0

def unpushed(opt, args):
    '''Provide a list of all local branches in all submodules that have not been pushed to the remote repo.
    '''
    ret=0
    r=Repo(os.getcwd())
    for submodule in sorted(r.submodules):
        remote_branches=__get_branches(False, opt.remote, submodule)
        remote_branch_names=[str(b) for b in remote_branches]
        local_branches=__get_branches(True, opt.remote, submodule)
        local_branch_names=[str(b) for b in local_branches]
        for b in local_branch_names:
            rbranch=opt.remote+'/'+b
            if rbranch not in remote_branch_names:
                # never pushed
                # print dir(lobj)
                # print dir(lobj.object)
                print submodule, '::', b, '::', lobj.object, ':: never pushed ::', lobj.object.committed_datetime
                continue
            robj=remote_branches[remote_branch_names.index(rbranch)]
            lobj=local_branches[local_branch_names.index(b)]
            if robj.object==lobj.object: continue
            print submodule, '::', b, '::', lobj.object, '::', robj.object
    return ret

if __name__=='__main__':

    epilog='Commands:\n\n'
    ls=locals().keys()
    for fname in sorted(ls):
        if fname.startswith('_'): continue
        import types
        fn=locals()[fname]
        if type(fn)!=types.FunctionType: continue
        doc=fn.__doc__ or ''
        help='%s: %s\n\n'%(fname, doc.strip())
        epilog+=help
    
    parser=argparse.ArgumentParser(epilog=epilog, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--verbose', action='store_true')
    parser.add_argument('--local', action='store_true')
    parser.add_argument('--remote', default='origin', help='Remote name')
    parser.add_argument('cmd')
    parser.add_argument('args', nargs=argparse.REMAINDER)
    opt=parser.parse_args()

    cmd=opt.cmd
    cmd=cmd.replace('-', '_')
    if cmd in dir() and callable(locals()[cmd]):
        fn=locals()[cmd]
        #print dir(fn)
        ret=fn(opt, opt.args)
    else:
        print 'bad command'
        ret=1
    sys.exit(ret)
