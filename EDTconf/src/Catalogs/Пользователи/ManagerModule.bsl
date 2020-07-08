////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
	Если НЕ Параметры.Отбор.Свойство("Служебный") Тогда
		Параметры.Отбор.Вставить("Служебный", Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		ПараметрИзменен = Ложь;
		
		Если Не Параметры.Свойство("Отбор") Тогда
			Параметры.Вставить("Отбор", Новый Структура("Недействителен", Ложь));
			ПараметрИзменен = Истина;
		ИначеЕсли Не Параметры.Отбор.Свойство("Недействителен") Тогда
			Параметры.Отбор.Вставить("Недействителен", Ложь);
			ПараметрИзменен = Истина;
		КонецЕсли;
		
		Если ПараметрИзменен Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаСписка";
		КонецЕсли;
		
	КонецЕсли;
	
	СтандартныеПодсистемыПереопределяемый.ОбработкаПолученияФормыПользователя(ВидФормы, Параметры, ВыбраннаяФорма, 
		ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры
