
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЗначениеЗаполнено(ПараметрКоманды) Тогда

		ОткрытьФорму("ОбщаяФорма.СтруктураПодчиненности",Новый Структура("ОбъектОтбора", ПараметрКоманды),
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Источник.КлючУникальности,
				ПараметрыВыполненияКоманды.Окно);

	КонецЕсли;

КонецПроцедуры

