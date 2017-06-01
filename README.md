# git-hooks
A list of hooks that I have or will make in future for my daily workflow

## Requirements
	### Windows
	 1. python
	 2. git bash
	### Linux (not tested yet)
	 1. python

## Pre-Commit hook
This commit will fire up when you type in the command `git commit`. I am
using this hook to remove the whitespace errors if any, removing them
and failing the commit allowing the user to add the now modified files
again.

### How to install

Rename the file inside  `hooks/pre-commit.new.sample` to your `.git/hooks/pre-commit`

## Tell me about it

Put in your issues in [here](https://github.com/raul1991/git-hooks/issues "pre-commit hook")
