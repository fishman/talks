SLIDR := ../slidr
PDM := cd $(SLIDR) && pdm run

all: snow_corp_cncf

init:
	@test -d $(SLIDR) || { echo "slidr not found at $(SLIDR). Clone it first."; exit 1; }
	@cd $(SLIDR) && pdm install

%: %.md init
	$(PDM) slidr $(CURDIR)/$<

watch-%: %.md init
	$(PDM) slidr -w $(CURDIR)/$<

clean:
	rm -rf dist/

.PHONY: all clean init
