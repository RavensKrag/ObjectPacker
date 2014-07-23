reverse(BODY.strip_comments.reverse_assignment)


BODY {
	strip_comments
	reverse_assignment
}.reverse






BODY {
	ALL_BEFORE {
		strip_empty_lines # similar to String#strip, strips both leading and trailing empties
	}
	
	EACH_LINE {
		strip_comments
		reverse_assignment
	}
	
	
	ALL_AFTER {
		each.indent
		reverse
	}
}