&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Письмо", ПараметрКоманды);
	
	ОткрытьФорму(
		"ЖурналДокументов.ЭлектроннаяПочта.Форма.ПечатьПисьма",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
