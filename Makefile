SLIDR := $(abspath ../slidr)
DECKS := snow_corp_cncf hami_intro kcd_vietnam
HTMLS := $(addprefix dist/,$(addsuffix .html,$(DECKS)))

all: $(HTMLS)

dist/%.html: %.md
	@mkdir -p dist
	@CSS=$$(grep -q '^theme:' $< && echo "" || echo "--css ../themes/dynamia.css"); \
	cd $(SLIDR) && pdm run slidr $$CSS $(CURDIR)/$<

watch-%: %.md
	@CSS=$$(grep -q '^theme:' $< && echo "" || echo "--css ../themes/dynamia.css"); \
	cd $(SLIDR) && pdm run slidr -w $$CSS $(CURDIR)/$<

clean:
	rm -rf dist/

.PHONY: all clean watch-%
