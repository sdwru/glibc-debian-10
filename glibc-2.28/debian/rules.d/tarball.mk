GLIBC_GIT = https://sourceware.org/git/glibc.git
GLIBC_BRANCH = release/$(GLIBC_VERSION)/master
GLIBC_TAG = glibc-$(GLIBC_VERSION)
GLIBC_CHECKOUT = glibc-checkout
GLIBC_DIR = glibc-$(GLIBC_VERSION)
DEB_ORIG = ../glibc_$(GLIBC_VERSION).orig.tar.xz
GIT_UPDATES_DIFF = debian/patches/git-updates.diff

get-orig-source: $(DEB_ORIG)
$(DEB_ORIG):
	dh_testdir
	git clone --bare $(GLIBC_GIT) $(GLIBC_CHECKOUT)
	mkdir -p $(GLIBC_DIR)
	(cd $(GLIBC_CHECKOUT) && git archive -v --format=tar $(GLIBC_TAG)) | tar -C $(GLIBC_DIR) -xf -
	rm -fr $(GLIBC_DIR)/manual
	tar --mode=go=rX,u+rw,a-s --owner=root --group=root --numeric-owner -Jcf $(DEB_ORIG) $(GLIBC_DIR)
	rm -rf $(GLIBC_DIR) $(GLIBC_CHECKOUT)

update-from-upstream:
	dh_testdir
	git clone --bare $(GLIBC_GIT) $(GLIBC_CHECKOUT)
	echo "GIT update of $(GLIBC_GIT)/$(GLIBC_BRANCH) from $(GLIBC_TAG)" > $(GIT_UPDATES_DIFF)
	echo "" >> $(GIT_UPDATES_DIFF)
	(cd $(GLIBC_CHECKOUT) && git diff --no-renames $(GLIBC_TAG) $(GLIBC_BRANCH) -- . ':!manual') >> $(GIT_UPDATES_DIFF)
	rm -rf $(GLIBC_CHECKOUT)
