﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.ФормаОбъекта", Новый Структура("Ключ", УчетнаяЗапись()),,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция УчетнаяЗапись()
	
	Возврат РаботаСПочтовымиСообщениями.ПолучитьСистемнуюУчетнуюЗапись();
	
КонецФункции
