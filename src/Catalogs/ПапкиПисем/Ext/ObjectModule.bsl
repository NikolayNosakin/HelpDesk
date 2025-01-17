﻿Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) И ПометкаУдаления Тогда
		Если ЭтоПредопределеннаяПапка() Тогда
			Отказ = Истина;
			ВызватьИсключение НСтр("ru = 'Нельзя удалять предопределенные папки писем'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПредыдущаяПометкаУдаления = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления");
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПисьмаВПапке(Ссылка, ПометкаУдаления);
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Родитель",ОбщегоНазначения.ПолучитьЗначениеРеквизита(ЭтотОбъект.Ссылка,"Родитель"));
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПредопределеннаяПапка = Ложь;
	
КонецПроцедуры

Функция ЭтоПредопределеннаяПапка()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПапкиУчетныхЗаписей.УчетнаяЗапись
		|ИЗ
		|	РегистрСведений.ПапкиУчетныхЗаписей КАК ПапкиУчетныхЗаписей
		|ГДЕ
		|	ПапкиУчетныхЗаписей.Папка = &Папка
		|	И (НЕ ПапкиУчетныхЗаписей.УчетнаяЗапись.ПометкаУдаления)");
	Запрос.УстановитьПараметр("Папка", Ссылка);
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьОбъектЗначениямиПоУмолчанию();
	
КонецПроцедуры

// Инициализирует новую папку писем значениями по умолчанию.
//
Процедура ЗаполнитьОбъектЗначениямиПоУмолчанию() Экспорт
	
	ВидПапки = Перечисления.ВидыПапокПисем.Общая;
	ВариантОтображенияКоличестваПисем = Перечисления.ВариантыОтображенияКоличестваПисемВПапке.Непрочтенные;
	
КонецПроцедуры
