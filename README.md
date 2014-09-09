### Description:

Sets the bash prompt according to:

*	the branch/status of the current git repository
*	the branch of the current subversion repository
*	the return value of the previous command

 
### Install

1. git clone git://github.com:mcheck/git_svn_bash_prompt.git
2. make install
3. source ```~/.local/bin/git_svn_bash_prompt.sh``` from within your ```.profile``` or ```~.bash\_profile``` or ```~/.bashrc``` file

### Author:
 
   Scott Woods <scott@westarete.com>  
   West Arete Computing

   Based on work by halbtuerke and lakiolen.  
   http://gist.github.com/31967

   mcheck:  
   Added rvm ruby version, adjusted regex for git > 1.8.5 clean status output 






