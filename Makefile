
	# check if user is root
	user = $(shell whoami)
	ifeq ($(user),root)
	INSTALL_DIR = /usr/lib/lv2
	else 
	INSTALL_DIR = ~/.lv2
	endif

	# set bundle name
	NAME = gx_voxtb
	BUNDLE = $(NAME).lv2
	VER = 0.1
	# set compile flags
	CXXFLAGS += -I. -I../DSP -fPIC -DPIC -O2 -Wall -funroll-loops -ffast-math -fomit-frame-pointer -fstrength-reduce
	LDFLAGS += -shared -lm
	# invoke build files
	OBJECTS = $(NAME).cpp
	## output style (bash colours)
	BLUE = "\033[1;34m"
	RED =  "\033[1;31m"
	NONE = "\033[0m"

.PHONY : all clean install uninstall

all : $(NAME)
	@mkdir -p ./$(BUNDLE)
	@cp ./*.ttl ./$(BUNDLE)
	@cp -r ./modgui ./$(BUNDLE)
	@mv ./*.so ./$(BUNDLE)
	@if [ -f ./$(BUNDLE)/$(NAME).so ]; then echo $(BLUE)"build finish, now run make install"; \
	else echo $(RED)"sorry, build failed"; fi
	@echo $(NONE)

clean :
	@rm -f $(NAME).so
	@rm -rf ./$(BUNDLE)
	@echo ". ." $(BLUE)", done"$(NONE)

install : all
	@mkdir -p $(DESTDIR)$(INSTALL_DIR)/$(BUNDLE)
	@cp -r ./$(BUNDLE)/* $(DESTDIR)$(INSTALL_DIR)/$(BUNDLE)
	@echo ". ." $(BLUE)", done"$(NONE)

uninstall :
	@rm -rf $(INSTALL_DIR)/$(BUNDLE)
	@echo ". ." $(BLUE)", done"$(NONE)

$(NAME) :
	$(CXX) $(CXXFLAGS) $(OBJECTS) $(LDFLAGS) -o $(NAME).so
