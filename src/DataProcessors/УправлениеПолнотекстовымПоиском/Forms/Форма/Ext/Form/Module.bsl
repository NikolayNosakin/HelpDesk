﻿
// Обновить индекс поиска
//
&НаКлиенте
Процедура ОбновитьИндексВыполнить()
	
	Состояние(НСтр("ru = 'Идет обновление полнотекстового индекса...
					|Пожалуйста, подождите.'"));
	ОбновитьИндексСервер();
	ОбновитьСтатус();
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'"));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИндексСервер()
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
КонецПроцедуры

// Очистить индекс
//
&НаСервере
Процедура ОчиститьИндексСервер()
	ПолнотекстовыйПоиск.ОчиститьИндекс();
КонецПроцедуры	

// Очистить индекс
&НаКлиенте
Процедура ОчиститьИндексВыполнить()
	ОчиститьИндексСервер();	
	ОбновитьСтатус();
КонецПроцедуры

// Обновить статус - доступность кнопок, дата актуальности индекса.
&НаСервере
Процедура ОбновитьСтатус()
	
	РазрешитьПолнотекстовыйПоиск = (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить);
	Если РазрешитьПолнотекстовыйПоиск Тогда
		ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
		ИндексАктуален = ПолнотекстовыйПоискСервер.ИндексПоискаАктуален();
	КонецЕсли;
	
	СтатусИндекса = "";
	
	Если РазрешитьПолнотекстовыйПоиск Тогда
		
		Элементы.ОбновитьИндекс.Доступность = НЕ ИндексАктуален;
		
		Если ИндексАктуален Тогда
			СтатусИндекса = НСтр("ru = 'Обновление индекса не требуется'");
		Иначе
			СтатусИндекса = НСтр("ru = 'Требуется обновление индекса'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьСтатус();
КонецПроцедуры

