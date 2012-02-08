ERL					?= erl
ERLC				= erlc
EBIN_DIRS		:= $(wildcard deps/*/ebin)
APPS				:= $(shell dir apps)
REL_DIR     = rel
NODE				= {{name}}
REL					= {{name}}
SCRIPT_PATH  := $(REL_DIR)/$(NODE)/bin/$(REL)

REBAR=./rebar

.PHONY: rel deps

all: deps compile

compile: deps
	$(REBAR) compile

deps:
	${REBAR} get-deps
	${REBAR} check-deps

clean:
	${REBAR} clean

realclean: clean
	${REBAR} delete-deps

test:
	${REBAR} skip_deps=true ct

rel: deps
	${REBAR} compile generate force=1

start: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) start

stop: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) stop

ping: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) ping

attach: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) attach

console: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) console

restart: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) restart

reboot: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) reboot

doc:
	rebar skip_deps=true doc
	for app in $(APPS); do \
		cp -R apps/$${app}/doc doc/$${app}; \
	done;

dev:
	@erl -pa ebin include deps/*/ebin deps/*/include ebin include -boot start_sasl

analyze: checkplt
	${REBAR} skip_deps=true dialyze

buildplt:
	${REBAR} skip_deps=true build-plt

checkplt: buildplt
	${REBAR} skip_deps=true check-plt
