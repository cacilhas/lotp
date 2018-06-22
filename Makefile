MOON := moon
MOONC := moonc
SHARE_DIR := $(shell $(MOON) find-lua-path.moon)

DEST= $(SHARE_DIR)/otp
MD= mkdir -p
RM= rm -rf

SRC= $(wildcard otp/*.moon)
TARGET= $(SRC:.moon=.lua)


#-------------------------------------------------------------------------------
.PHONY: install uninstall clean test


all: $(TARGET)


%.lua: %.moon
	@$(MOONC) $<


install: $(TARGET)
	tar --exclude "*.moon" otp | (cd $(SHARE_DIR) && tar -xvf -)


uninstall:
	$(RM) $(DEST)


clean:
	$(RM) $(TARGET) $(HEADERS_DIR)


test: tests/init.moon $(TARGET)
	$(MOON) $<
