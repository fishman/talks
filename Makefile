DECKS := snow_corp_cncf hami_intro kcd_vietnam
HTMLS := $(addprefix dist/,$(addsuffix .html,$(DECKS)))

all: $(HTMLS)

dist/%.html: %.md
	@mkdir -p dist
	pdm run slidr $<

watch-%: %.md
	pdm run slidr -w $<

clean:
	rm -rf dist/

.PHONY: all clean watch-%
