﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТекстСообщения.Заголовок = Параметры.ТекстСообщения;
	Элементы.РекомендуемаяВерсияПлатформы.Заголовок = Параметры.РекомендуемаяВерсияПлатформы;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Элементы.Версия.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.Версия.Заголовок, СистемнаяИнформация.ВерсияПриложения);
	Если Параметры.ЗавершитьРаботу Тогда
		Элементы.ФормаНет.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТекстСсылкиНажатие(Элемент)
	СтандартнаяОбработка = Ложь;
	НачатьЗапускПриложения(Неопределено, Элементы.ТекстСсылки.Подсказка);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПродолжитьРаботу(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

