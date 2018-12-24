-- Tables --
lSecession.Translations = {}

-- Functions
functions.loadTranslationFile = function(language)
	if language then
		if fileExists('Translations/'..language..'.txt') then
			return fileOpen('Translations/'..language..'.txt')
		end
	end
end

functions.prepTranslation = function(language)
	if not lSecession.Translations[language] then
		local file = functions.loadTranslationFile(language)
		if file then 
			lSecession.Translations[language] = {}
			local Data =  fileRead(file, fileGetSize(file))
			local Proccessed = split(Data,10)
			for i,v in pairs(Proccessed) do
				local splitA = split(vA,",")
				lSecession.Translations[language][splitA[1]] = splitA[2]
			end
			fileClose (file)
		end
	end
end

functions.fetchTranslation = function (language)
	functions.prepTranslation(language)
	if lSecession.Translations[language] then
		if lSecession.Translations[language] then
			for i,v in pairs(lSecession.Translations[language]) do
				return functions.client(client,'retreiveTranslation',i,language,v)
			end
		end
	end
end

