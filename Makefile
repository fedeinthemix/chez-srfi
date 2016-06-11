# Copyright (c) 2016 Federico Beffa <beffa@fbengineering.ch>
# 
# Permission to use, copy, modify, and distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all
# copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
# OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

PACKAGE = chez-srfi
VERSION = 1.0

CHEZ = chez-scheme
INSTALL = install -D

PREFIX = /usr/local
EXEC_PREFIX = ${PREFIX}
BINDIR = ${EXEC_PREFIX}/bin
LIBDIR = ${EXEC_PREFIX}/lib
INCLUDEDIR = ${PREFIX}/include
DATAROOTDIR = ${PREFIX}/share
DATADIR = ${DATAROOTDIR}
MANDIR = ${DATAROOTDIR}/man
INFODIR = ${DATAROOTDIR}/info
DOCDIR = ${DATAROOTDIR}/doc/${PACKAGE}-${VERSION}

chezversion ::= $(shell echo '(call-with-values scheme-version-number (lambda (a b c) (format \#t "~d.~d" a b)))' | ${CHEZ} -q)
schemedir = ${LIBDIR}/csv${chezversion}-site

build:
	(cd srfi/%3a2 && ln -sf and-let%2a.sls and-let\*.sls)
	(cd srfi && $(CHEZ) --program link-dirs.chezscheme.sps)
	(cd srfi && $(CHEZ) --program compile-all.chezscheme.ss)

clean:
	find srfi -name "*.so" -exec rm {} \;
	find srfi -type l -exec rm {} \;

install:
	find srfi -type f -regex ".*.so" -exec sh -c '${INSTALL} -t ${schemedir}/$$(dirname $$1) $$1' _ {} \;
	${INSTALL} -t ${DOCDIR} srfi/README
	cp -P srfi/:[0-9] ${schemedir}/srfi
	cp -P srfi/:[0-9][0-9] ${schemedir}/srfi
	cp -P srfi/:[0-9]*.so ${schemedir}/srfi

install-src:
	find srfi -type f -regex ".*.s\(ls\|cm\)" -exec sh -c '${INSTALL} -t ${schemedir}/$$(dirname $$1) $$1' _ {} \;
	cp -P srfi/:[0-9] ${schemedir}/srfi
	cp -P srfi/:[0-9][0-9] ${schemedir}/srfi
	cp -P srfi/:[0-9]*.sls ${schemedir}/srfi

test:
	$(CHEZ) --program srfi/tests/and-let%2a.sps
	$(CHEZ) --program srfi/tests/lists.sps
	$(CHEZ) --program srfi/tests/cut.sps
	$(CHEZ) --program srfi/tests/intermediate-format-strings.sps
	$(CHEZ) --program srfi/tests/multi-dimensional-arrays.sps
	$(CHEZ) --program srfi/tests/multi-dimensional-arrays--arlib.sps
	$(CHEZ) --program srfi/tests/lightweight-testing.sps
	$(CHEZ) --program srfi/tests/random-bits.sps
	$(CHEZ) --program srfi/tests/records.sps
	$(CHEZ) --program srfi/tests/rec.sps
	$(CHEZ) --program srfi/tests/testing.sps
	$(CHEZ) --program srfi/tests/vectors.sps
	$(CHEZ) --program srfi/tests/eager-comprehensions.sps
	$(CHEZ) --program srfi/tests/compare-procedures.sps

# Note that test srfi/tests/lightweight-testing.sps reports failing.
# But this is just to test that if the answer is wrong it does signal
# so.

# Exception in get-environment-variables: not implemented
# $(CHEZ) --program srfi/tests/os-environment-variables.sps

# Exception in cumulative-thread-time: not implemented
# $(CHEZ) --program srfi/tests/time.sps

# This test requires interaction.
# $(CHEZ) --program srfi/tests/lazy.sps

check-schemedir:
	echo ${schemedir}
