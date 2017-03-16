note
	description: "Summary description for {PERSON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	ANY
		redefine
			out
		end

create
	new_player
	, make_empty


feature -- creation
	make_empty
		do
			create name.make_empty
			create pawn.make_empty
			score := 0
		end
	new_player(a_name: STRING)
		do
			make_empty
			name := a_name
		end

feature -- queries
	name	: STRING
	score	: INTEGER
	pawn	: STRING


feature -- commands
	set_score(a_score: INTEGER)
		require
			nonnegative_score: a_score >= 0
		do
			score := a_score
		ensure
			score_changed: score = a_score
		end

	decrement_score
		require
			nonnegative_score: score > 0
		do
			score := score - 1
		ensure
			score_changed: score = old score - 1
		end

	increment_score
		do
			score := score + 1
		ensure
			score_changed: score = old score + 1
		end

	set_pawn(a_pawn : STRING)
		do
			pawn := a_pawn
		end



feature -- output
	out: STRING
		do
			create Result.make_from_string ("  ")
			Result.append (score.out)
			Result.append (": score for %"")
			Result.append (name.out)
			Result.append ("%" (as ")
			Result.append (pawn.out)
			Result.append (")")
		end

end
