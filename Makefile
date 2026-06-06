CC ?= cc
PARSER := parser/conops.so

.PHONY: all parser binary test clean
all: parser binary

parser: $(PARSER)
$(PARSER): src/parser.c
	@mkdir -p parser
	$(CC) -o $(PARSER) -Isrc -shared -fPIC -O2 src/parser.c

binary:
	@./scripts/fetch-binary.sh

test:
	@./tests/run.sh

clean:
	rm -f $(PARSER); rm -rf bin
