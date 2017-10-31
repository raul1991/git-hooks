# git-hooks
A list of hooks that I have or will make in future for my daily development workflow

## Requirements

### Windows
	
	 	1. python
	 	2. git bash
		
### Linux (not tested yet)
	 	1. python

## Hooks supported

### Pre-Commit hook
This hook is fired up by GIT everytime you `commit`. Whenever you commit your code containing white-spaces this hook would prevent it from going into the upstream branch and fix it for you. Your work after that would be just to add the "affected files" again into git.

## How to install
1. Add the path to this directory to your environment variables or use export PATH=path-to-this-folder:$PATH if you are super lazy.
2. Run this command -> `./init.sh` or `./init.sh 1` for more logs :p

## Tell me about it
Put in your issues in [here](https://github.com/raul1991/git-hooks/issues "pre-commit hook")

## Suggestions for contributions
- Discuss new hook features you would want to see. Use features as a label for it.
- Restructuring of the project. Do you not like how the files are kept. Raise [issues](https://github.com/raul1991/git-hooks/issues). Use arch as a label for it.
- Readme or wiki pages should be updated ? Talk about it on the issues page and use documentation as a label for it.