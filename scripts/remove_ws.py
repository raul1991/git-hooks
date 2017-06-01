#!/proj/env/bin/python
# pylint: disable=W0105

'''
Scenarios:
    Remove all the trailing spaces, replacing tabs with standard 4 spaces and replace windows new line with unix new line from the work space
    Remove characters from single file
    Remove characters from <pattern> file(s)
    Remove characters from file(s)in the file system recursively
    Remove characters from all unstaged files
    Create a help menu
'''

import argparse
import re
import os
import subprocess


def removeSpacesTabsCRLF(filename, replacechar):
    '''
    Function : Remove/replace trailing space(s), tab(s) and window(s) newline with unix newline
    '''
    lines = []
    with open(filename, "r") as f:
        for line in f.readlines():
            if "TB" in replacechar or "ALL" in replacechar:
                line = line.replace('\t', '    ')
            if "TS" in replacechar or "ALL" in replacechar:
                line = line.rstrip() + "\n"
            if "WNL" in replacechar or "ALL" in replacechar:
                line = re.sub(r'(\r\n|\r|\n)', '\n', line)
            lines.append(line)
    with open(filename, "w") as f:
        for line in lines:
            f.write(line)


def getrepodir():
    repodir = subprocess.check_output(['git', 'rev-parse', '--git-dir'])
    return os.path.dirname(str(repodir).strip('\n'))


def main():
    counter = 0
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", dest="fileorpattern", nargs="+", help="The file or pattern from which the characters are to be removed.")
    parser.add_argument("-r", dest="recursive", nargs='+', help="The characters will be removed from the files in this directory recursively.")
    parser.add_argument("-u", dest="unstaged", action="store_true", help="The characters will be removed from all unstaged files.")
    parser.add_argument("-c", dest="character", choices=['TB', 'TS', 'WNL', 'ALL'], nargs='+', help="Enter one or more from TB(Tab), TS(trailing space), WNL(windws new line) or ALL to remove all character.")
    options = parser.parse_args()
    repodir = getrepodir()

    if options.fileorpattern and options.character:
        for filename in options.fileorpattern:
            removeSpacesTabsCRLF(filename, options.character)
            counter += 1
            print filename

    elif options.recursive and options.character:
        for path, _, files in os.walk(str(options.recursive[0])):
            for name in files:
                if name.endswith(str(options.recursive[1])):
                    fromfile = os.path.join(path, name)
                    removeSpacesTabsCRLF(fromfile, options.character)
                    counter += 1
                    print fromfile

    elif options.unstaged and options.character:
        unstagedfileslist = []
        stdout = subprocess.check_output(['git', 'status', '--porcelain'])
        if not " M " in stdout:
            print "Message : You do not have any unstaged files"
        else:
            for row in str(stdout).split('\n'):
                if row.startswith(" M "):
                    unstagedfileslist.append(row.split()[1])
            for filename in unstagedfileslist:
                fromfile = os.path.join(repodir, filename)
                removeSpacesTabsCRLF(fromfile, options.character)
                print fromfile
                counter += 1

    else:
        parser.print_help()
    print "Number of file(s) effected by the script >> " + str(counter)


if __name__ == '__main__':
    main()

