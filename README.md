# githubFetch
Download file from GitHub with MATLAB


## Overview
There are many solutions for automatically downloading files from GitHub. However, they work easily mainly under Linux, needing the libraries `wget` or `curl`. If someone works with Windows or directly wants to use MATLAB, this program is useful.


## Usage
The syntax is
```
filestr = githubFetch(user, repository, downloadType, version)
```
with the inputs
```
user: name of the user or the organization
repository: name of the repository
downloadType: 'branch' or 'release'
version: if downloadType is 'branch': branch name (default: 'master')
         if downloadType is 'release': release version
```
and the output
```
filestr: path to the downloaded file (empty if the downloading failed)
```
Examples:
1. `githubFetch('GLVis', 'glvis', 'branch', 'master');`
2. `githubFetch('matlab2tikz', 'matlab2tikz', 'branch', 'develop');`
3. `githubFetch('matlab2tikz', 'matlab2tikz', 'release', '1.1.0');`


## Technical
Instead of `webread` and `webwrite` introduced to MATLAB in 2014, `urlread` and `urlwrite` is used existing before 2006. The other advantage of `urlread` and `urlwrite` is that they are supported by Octave as well.

Currently, Octave fails with the link formatting. I am working on it ...
