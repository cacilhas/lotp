MOONC := moonc
BUSTED := env NO_MAKE=1 busted
SHARE_DIR := $(shell moon find-lua-path.moon)

DEST= $(SHARE_DIR)/lotp
MD= mkdir -p
RM= rm -rf

SRC= $(wildcard lotp/*.moon)
TARGET= $(SRC:.moon=.lua)


#-------------------------------------------------------------------------------
.PHONY: install uninstall clean test


all: $(TARGET)


%.lua: %.moon
	@$(MOONC) $<


install: $(TARGET)
	tar --exclude "*.moon" -cf- lotp | (cd $(SHARE_DIR) && tar -xf -)


uninstall:
	$(RM) $(DEST)


clean:
	$(RM) $(TARGET) $(HEADERS_DIR)


test: $(TARGET)
	@$(BUSTED)
