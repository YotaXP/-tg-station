#define LIBREGEX_LIBRARY "bygex"

// regex_compare(testString, regex)  Returns a match only if the regex matches the entire test string.  Returns a /datum/matchList
// regEx_compare(testString, regex)  Case-sensitive version.
/proc/regex_compare(str, exp)
	return new /datum/matchList(str, exp, call(LIBREGEX_LIBRARY, "regex_compare")(str, exp))

/proc/regEx_compare(str, exp)
	return new /datum/matchList(str, exp, call(LIBREGEX_LIBRARY, "regEx_compare")(str, exp))


// regex_find(searchString, regex)  Returns the first match found in the given string.  Returns a /datum/matchList
// regEx_find(searchString, regex)  Case-sensitive version.
/proc/regex_find(str, exp)
	return new /datum/matchList(str, exp, call(LIBREGEX_LIBRARY, "regex_find")(str, exp))

/proc/regEx_find(str, exp)
	return new /datum/matchList(str, exp, call(LIBREGEX_LIBRARY, "regEx_find")(str, exp))


// regex_findall(searchString, regex)  Returns all matches found in the given string.  Returns a /datum/matchList
// regEx_findall(searchString, regex)  Case-sensitive version.
/proc/regex_findall(str, exp)
	return new /datum/matchList(str, exp, call(LIBREGEX_LIBRARY, "regex_findall")(str, exp))

/proc/regEx_findall(str, exp)
	return new /datum/matchList(str, exp, call(LIBREGEX_LIBRARY, "regEx_findall")(str, exp))


// regex_replace(searchString, regex, replacement)  Replaces a single match in the search string with the given replacement.  Returns a string.
// regEx_replace(searchString, regex, replacement)  Case-sensitive version.
/proc/regex_replace(str, exp, fmt)
	return call(LIBREGEX_LIBRARY, "regex_replace")(str, exp, fmt)

/proc/regEx_replace(str, exp, fmt)
	return call(LIBREGEX_LIBRARY, "regEx_replace")(str, exp, fmt)


// regex_replaceall(searchString, regex, replacement)  Replaces all matches in the search string with the given replacement.  Returns a string.
// regEx_replaceall(searchString, regex, replacement)  Case-sensitive version.
/proc/regex_replaceall(str, exp, fmt)
	return call(LIBREGEX_LIBRARY, "regex_replaceall")(str, exp, fmt)

/proc/regEx_replaceall(str, exp, fmt)
	return call(LIBREGEX_LIBRARY, "regEx_replaceall")(str, exp, fmt)


// replacetext(searchString, needle, replacement)    Replaces all occurances of the 'needle' in the search string with the given replacement.  Returns a string.
// replacetextEx(searchString, needle, replacement)  Case-sensitive version.
/proc/replacetext(str, exp, fmt)
	return call(LIBREGEX_LIBRARY, "regex_replaceallliteral")(str, exp, fmt)

/proc/replacetextEx(str, exp, fmt)
	return call(LIBREGEX_LIBRARY, "regEx_replaceallliteral")(str, exp, fmt)


#undef LIBREGEX_LIBRARY

/* /datum/matchList Basic Usage:

	// Perform the search, and store the results.
	var/datum/matchList/ML = regex_findall("search string", "s(..)")

	// Assert that the regex compiled correctly.
	if(ML.error) CRASH("REGEX ERROR: " + ML.error)

	// Verify that there are matches. (Optional if looping.)
	if(!ML.first) return
	if(ML.matches.len != 4) return

	// Loop through each match.
	for(var/datum/match/M in ML.matches)
		// Retrieve the matched text.
		var/matchText = M.Text()
		// Retrieve the contents of the first group.
		var/groupText = M.Text(1)

	// Retrieving the text of the first match. (Be sure to verify it exists!)
	var/matchText = ML.first.Text()

	// Selecting a specific match.
	var/datum/match/M = ML.matches[2]
	var/matchText = M.Text()
*/
/datum/matchList
	var/str                   // Original search string.
	var/exp                   // Regex expression.
	var/error                 // Error string, if any.
	var/list/matches = list() // List of all matches.
	var/datum/match/first     // First match in the list, for convenience.

/datum/matchList/New(str, exp, results)
	src.str = str
	src.exp = exp

	if(findtext(results, "Err", 1, 4))
		src.error = results
	else
		var/list/L = params2list(results)
		for(var/i in L)
			matches += new/datum/match(str, L[i])
		if(matches.len)
			first = matches[1]


/datum/match
	var/str         // These variables are not intended to be accessed directly.
	var/list/groups // Use the functions defined below.

/datum/match/New(str, groups)
	src.str = str
	src.groups = list()
	for(var/n in groups)
		src.groups += text2num(n)


// Text()      Returns the text matched.
// Text(group) Returns the text matched by the specified group.
/datum/match/proc/Text(group=0)
	if(group < 0 || group > groups.len/2 - 1)
		CRASH("Group #[group] does not exist in this match.")
	var/pos = groups[group*2 + 1]
	return copytext(str, pos, pos + (groups[group*2 + 2]))


// Pre()      Returns the text preceeding the match.
// Pre(group) Returns the matched text preceeding the specified group.
/datum/match/proc/Pre(group=0)
	if(group < 0 || group > groups.len/2 - 1)
		CRASH("Group #[group] does not exist in this match.")
	return copytext(str, group ? groups[1] : 1, groups[group*2 + 1])


// Post()      Returns the text following the match.
// Post(group) Returns the matched text following the specified group.
/datum/match/proc/Post(group=0)
	if(group < 0 || group > groups.len/2 - 1)
		CRASH("Group #[group] does not exist in this match.")
	return copytext(str, groups[group*2 + 1] + groups[group*2 + 2], group ? groups[1] + groups[2] : 0)


// Start()      Returns the starting position of the match within the search string.
// Start(group) Returns the starting position of the specified group within the search string.
/datum/match/proc/Start(group=0)
	if(group < 0 || group > groups.len/2 - 1)
		CRASH("Group #[group] does not exist in this match.")
	return groups[group*2 + 1]


// End()      Returns the ending position of the match within the search string.
// End(group) Returns the ending position of the specified group within the search string.
/datum/match/proc/End(group=0)
	if(group < 0 || group > groups.len/2 - 1)
		CRASH("Group #[group] does not exist in this match.")
	return groups[group*2 + 1] + groups[group*2 + 2]


// Len()      Returns the length of the matched text.
// Len(group) Returns the length the text matched by the specified group.
/datum/match/proc/Len(group=0)
	if(group < 0 || group > groups.len/2 - 1)
		CRASH("Group #[group] does not exist in this match.")
	return groups[group*2 + 2]


// Toggle for unit tests.
#if 0

/world/New()
	..()
	spawn(20)
		world << "Beginning regex unit tests."

		var/datum/matchList/ML
		var/datum/match/M
		var/search

		search = "123.456;abc.def;123.abc;abc.123"
		ML = regex_findall(search, "(\\w+)\\.(\\w+)")
		ASSERT(ML.matches.len == 4)
		M = ML.matches[1]
		ASSERT(M.Text()  == "123.456")
		M = ML.matches[2]
		ASSERT(M.Text(1) == "abc")
		M = ML.matches[3]
		ASSERT(M.Start() == 17)
		M = ML.matches[4]
		ASSERT(M.End(2)  == length(search)+1)

		ML = regex_find("abc", "123")
		ASSERT(!ML.first)

		search = "111-abCba-222"
		ML = regex_find(search, "ab(c)ba")
		ASSERT(ML.matches.len   == 1)
		ASSERT(ML.first.Pre()   == "111-")
		ASSERT(ML.first.Pre(1)  == "ab")
		ASSERT(ML.first.Post(1) == "ba")
		ASSERT(ML.first.Post()  == "-222")
		ASSERT(ML.first.Len()   == 5)

		ML = regEx_find(search, "B")
		ASSERT(!ML.first)
		ML = regEx_find(search, "b")
		ASSERT(ML.matches.len == 1)

		ML = regex_compare(search, "\\d+-\\w+-\\d+")
		ASSERT(ML.first)
		ML = regEx_compare(search, "\\d+-\\w+-\\d+")
		ASSERT(ML.first)
		ML = regex_compare(search, "\\d+-\\w+-\\d")
		ASSERT(!ML.first)

		search = "AB12"
		ASSERT( regex_replace(search,    "\[a-z]", "_") == "_B12" )
		ASSERT( regEx_replace(search,    "\[a-z]", "_") == "AB12" )
		ASSERT( regex_replaceall(search, "\[a-z]", "_") == "__12" )
		ASSERT( regEx_replaceall(search, "\[a-z]", "_") == "AB12" )
		search = "A\\W"
		ASSERT( replacetext(search,   "\\w", "_") == "A_" )
		ASSERT( replacetextEx(search, "\\w", "_") == "A\\W" )

		world << "Completed regex unit tests."

#endif
