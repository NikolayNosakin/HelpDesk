﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВРабочемКаталоге = Параметры.ВРабочемКаталоге;
	ВремяИзмененияНаСервере = Параметры.ВремяИзмененияНаСервере;
	Файл = Параметры.Файл;
	Сообщение = Параметры.Сообщение;
	Заголовок = Параметры.Заголовок;
	
	Если Параметры.РежимОткрытия = "ПомещениеФайлаВИБ" Тогда
		Элементы.ФормаОткрытьСуществующий.Видимость = Ложь;
		Элементы.ФормаВзятьССервера.Видимость = Ложь;
		Элементы.ФормаПоместитьВИБ.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.ФормаПоместитьВИБ.Видимость = Ложь;
		Элементы.ФормаОставитьФайлБезИзменений.Видимость = Ложь;
		Элементы.ФормаОткрытьСуществующий.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСуществующий(Команда)
	Закрыть(КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВИБ(Команда)
	Закрыть(КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура Перезаписать(Команда)
	Закрыть(КодВозвратаДиалога.Нет);
КонецПроцедуры

&НаКлиенте
Процедура ОставитьФайлБезИзменений(Команда)
	Закрыть(КодВозвратаДиалога.Нет);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталог(Команда)
	
	ФайловыеФункцииСлужебныйКлиент.ОткрытьПроводникСФайлом(Файл);
	
КонецПроцедуры
