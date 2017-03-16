note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	TIC_TAC_ACCESS

feature
	m: TIC_TAC
		once
			create Result.make
		end

invariant
	m = m
end




