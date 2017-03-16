note
	description: "Summary description for {HISTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HISTORY

create
	make

feature --creation
	make
		do
			create history_list.make_empty
			cursor := 0
		end

feature -- queries

	history_list	: ARRAY[INTEGER]
	cursor		 	: INTEGER


feature -- commands/ queries
	place_item( a_button: INTEGER)
		do
			cursor := cursor + 1
			history_list.force (a_button, cursor)
			if not (cursor = history_list.count) then
				after_expired(cursor)
			end
		end

	after_expired(a_index: INTEGER)
		local
			new_cursor : INTEGER
		do
			new_cursor := history_list.count-cursor
			history_list.remove_tail (new_cursor)

			cursor := new_cursor - 1
			if not (cursor <= history_list.count) and not (cursor >= 1) then
				cursor := 1
			end

	end

	get_button : INTEGER
		do
			Result:= history_list.at (cursor)
		end

	get_count : INTEGER
		do
			Result:= history_list.count
		end

	undo
		do
			if 	cursor > 1 then
				cursor := cursor - 1
			else

			end

		end

	redo
		do
			if  cursor < history_list.count then
				cursor := cursor + 1
			end
		end


end
