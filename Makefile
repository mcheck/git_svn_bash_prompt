INSTALL_DIR=~/.local/bin

all:
	@echo "Please run 'make install'"

install:
	@echo ""
	mkdir -p $(INSTALL_DIR)
	cp git_svn_bash_prompt.sh $(INSTALL_DIR)
	@echo ""
	@echo "Please add 'source $(INSTALL_DIR)/git_svn_bash_prompt.sh' to your .profile or .bash_profile file"
	@echo ''
	@echo 'DESCRIPTION:'
	@echo '------------'
	@echo 'Sets the bash prompt according to:'
	@echo '* the branch/status of the current git repository'
	@echo '* the branch of the current subversion repository'
	@echo '* the return value of the previous command'
	