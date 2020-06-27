package exampleparser

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func parse(pn string) *astPhoneNumber {
	l := newLexer(pn)
	_ = yyParse(l)
	return l.result
}

func TestParse(t *testing.T) {
	x := &astPhoneNumber{
		area:  "123",
		part1: "456",
		part2: "7890",
	}
	assert.Equal(t, x, parse("123 456 7890"))
	assert.Equal(t, x, parse("123-456-7890"))
	assert.Equal(t, x, parse("(123)456 7890"))
	assert.Equal(t, x, parse("(123)456-7890"))
}
