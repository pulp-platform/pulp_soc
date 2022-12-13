.DEFAULT_GOAL := help

VENVDIR?=$(WORKDIR)/.venv
REQUIREMENTS_TXT?=$(wildcard requirements.txt)
include Makefile.venv

## Regenerate the register file and HAL C-header the soc_ctrl register.
regenerate_soc_ctrl: | venv
	@echo Regenerating SoC control register...
	$(VENV)/python util/reggen/regtool.py rtl/pulp_soc/soc_ctrl_reg/soc_ctrl_reg.hjson -r -t rtl/pulp_soc/soc_ctrl_reg/src
	$(VENV)/python util/reggen/regtool.py rtl/pulp_soc/soc_ctrl_reg/soc_ctrl_reg.hjson --cdefines -o rtl/pulp_soc/soc_ctrl_reg/hal/soc_ctrl_reg_hal.h
	@echo "Done"

.PHONY: help
help: Makefile
	@printf "Pulp SoC Reconfiguration\n"
	@printf "Available targets\n\n"
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-15s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
