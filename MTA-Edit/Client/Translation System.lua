-- Tables --
lSecession.Translations = {}
lSecession.language = 'nil'

-- Functions --

functions.retreiveTranslation = function (original,language,translation)
	lSecession.Translations[language][original] = translation
end


functions.fetchTranslationInformation = function ()
	functions.server('fetchTranslation',lSecession.language)
end

setTimer (functions.fetchTranslationInformation, 1000, 0 )


functions.fetchTranslation = function (original)
	if (lSecession.Translations[lSecession.language] or {})[original] then
		if lSecession.Translations[lSecession.language][original] then
			return lSecession.Translations[lSecession.language][original]
		else
			return original
		end
	end
	return original
end
