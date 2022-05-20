﻿
&НаСервере
Процедура ПроверитьРабочееВремя(Отказ)
	
	НетЗаполненныхЗначений = Истина;
	Для Инд = 1 По 4 Цикл
		Если ЗначениеЗаполнено(ЭтотОбъект["ВремяНачала" + Инд]) Или ЗначениеЗаполнено(ЭтотОбъект["ВремяОкончания" + Инд]) Тогда 
			НетЗаполненныхЗначений = Ложь;
		КонецЕсли;	
	КонецЦикла;	
	Если НетЗаполненныхЗначений Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указано ни одного интервала времени'"),,"ВремяНачала1",,Отказ);
		Возврат;	
	КонецЕсли;	
	
	Для Инд = 1 По 4 Цикл
		Если ЗначениеЗаполнено(ЭтотОбъект["ВремяНачала" + Инд]) И Не ЗначениеЗаполнено(ЭтотОбъект["ВремяОкончания" + Инд]) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено поле ""По""'"),,"ВремяОкончания"+Инд,,Отказ);
			Возврат;	
		КонецЕсли;
	КонецЦикла;
	
	Для Инд = 1 По 4 Цикл
		Если ЗначениеЗаполнено(ЭтотОбъект["ВремяОкончания" + Инд]) И ЭтотОбъект["ВремяНачала" + Инд] >= ЭтотОбъект["ВремяОкончания" + Инд] Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Время окончания меньше времени начала'"),,"ВремяОкончания" + Инд,,Отказ);
			Возврат;	
		КонецЕсли;	
	КонецЦикла;	
	
	Для Инд1 = 1 По 3 Цикл
		Для Инд2 = Инд1 + 1 По 4 Цикл
			Если ЗначениеЗаполнено(ЭтотОбъект["ВремяОкончания" + Инд1]) И ЗначениеЗаполнено(ЭтотОбъект["ВремяОкончания" + Инд2]) Тогда 
				Если ГрафикиРаботы.ИнтервалыПересекаются(
						ЭтотОбъект["ВремяНачала"+Инд1], 
						ЭтотОбъект["ВремяОкончания"+Инд1], 
						ЭтотОбъект["ВремяНачала"+Инд2], 
						ЭтотОбъект["ВремяОкончания"+Инд2]) 
					Тогда 
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Интервалы времени (%1, %2) и (%3, %4) пересекаются'"),
							Формат(ЭтотОбъект["ВремяНачала"+Инд1],	"ДФ=ЧЧ:мм; ДП=00:00"),
							Формат(ЭтотОбъект["ВремяОкончания"+Инд1], "ДФ=ЧЧ:мм; ДП=00:00"), 
							Формат(ЭтотОбъект["ВремяНачала"+Инд2],	"ДФ=ЧЧ:мм; ДП=00:00"), 
							Формат(ЭтотОбъект["ВремяОкончания"+Инд2], "ДФ=ЧЧ:мм; ДП=00:00")));
						Отказ = Истина;	
					Возврат;
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура ПроверитьОсобоеРабочееВремя(Отказ)
	
	Для Каждого Строка Из ОсобоеРабочееВремя Цикл
		ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
		
		Если Не ЗначениеЗаполнено(Строка.РабочийДень) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не указан день с особым рабочим временем'"),,"ОсобоеРабочееВремя["+ОсобоеРабочееВремя.Индекс(Строка)+"].РабочийДень",,Отказ);
			Возврат;	
		КонецЕсли;
		
		НетЗаполненныхЗначений = Истина;
		Для Инд = 1 По 4 Цикл
			Если ЗначениеЗаполнено(Строка["ВремяНачалаОсобое" + Инд]) Или ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд]) Тогда 
				НетЗаполненныхЗначений = Ложь;
			КонецЕсли;	
		КонецЦикла;	
		Если НетЗаполненныхЗначений Тогда 
			Элементы.ОсобоеРабочееВремя.ТекущаяСтрока = ИдентификаторСтроки;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано ни одного интервала времени'"),,"ВремяНачалаОсобое1",,Отказ);
			Возврат;	
		КонецЕсли;	
		
		Для Инд = 1 По 4 Цикл
			Если ЗначениеЗаполнено(Строка["ВремяНачалаОсобое" + Инд]) И Не ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд]) Тогда 
				Элементы.ОсобоеРабочееВремя.ТекущаяСтрока = ИдентификаторСтроки;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""По""'"),,"ВремяОкончанияОсобое"+Инд,,Отказ);
				Возврат;	
			КонецЕсли;
		КонецЦикла;
		
		Для Инд = 1 По 4 Цикл
			Если ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд]) И Строка["ВремяНачалаОсобое" + Инд] >= Строка["ВремяОкончанияОсобое" + Инд] Тогда 
				Элементы.ОсобоеРабочееВремя.ТекущаяСтрока = ИдентификаторСтроки;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Время окончания меньше времени начала'"),,"ВремяОкончанияОсобое" + Инд,,Отказ);
				Возврат;	
			КонецЕсли;	
		КонецЦикла;	
		
		Для Инд1 = 1 По 3 Цикл
			Для Инд2 = Инд1 + 1 По 4 Цикл
				Если ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд1]) И ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое" + Инд2]) Тогда 
					Если ГрафикиРаботы.ИнтервалыПересекаются(
						Строка["ВремяНачалаОсобое"+Инд1], 
						Строка["ВремяОкончанияОсобое"+Инд1], 
						Строка["ВремяНачалаОсобое"+Инд2], 
						Строка["ВремяОкончанияОсобое"+Инд2]) 
					Тогда 
						Элементы.ОсобоеРабочееВремя.ТекущаяСтрока = ИдентификаторСтроки;
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Интервалы времени (%1, %2) и (%3, %4) пересекаются'"),
							Формат(Строка["ВремяНачалаОсобое"+Инд1],	"ДФ=ЧЧ:мм; ДП=00:00"),
							Формат(Строка["ВремяОкончанияОсобое"+Инд1], "ДФ=ЧЧ:мм; ДП=00:00"), 
							Формат(Строка["ВремяНачалаОсобое"+Инд2],	"ДФ=ЧЧ:мм; ДП=00:00"), 
							Формат(Строка["ВремяОкончанияОсобое"+Инд2], "ДФ=ЧЧ:мм; ДП=00:00")),,"ОсобоеРабочееВремя");
							Отказ = Истина;	
						Возврат;
					КонецЕсли;	
				КонецЕсли;
			КонецЦикла;	
		КонецЦикла;	
		
	КонецЦикла;	
	
КонецПроцедуры	



&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// рабочее время
	Для Инд = 1 По Объект.РабочееВремя.Количество() Цикл
		ЭтотОбъект["ВремяНачала"+Инд] = Объект.РабочееВремя[Инд-1].ВремяНачала;
		ЭтотОбъект["ВремяОкончания"+Инд] = Объект.РабочееВремя[Инд-1].ВремяОкончания;
	КонецЦикла;	
	
	// особое рабочее время
	ТаблОсобоеРабочееВремя = Объект.ОсобоеРабочееВремя.Выгрузить();
	ТаблОсобоеРабочееВремя.Свернуть("РабочийДень");
	
	ОсобоеРабочееВремя.Загрузить(ТаблОсобоеРабочееВремя);
	Для Каждого Строка Из ОсобоеРабочееВремя Цикл
		ОтборСтрок = Новый Структура("РабочийДень", Строка.РабочийДень);
		НайденныеСтроки = Объект.ОсобоеРабочееВремя.НайтиСтроки(ОтборСтрок);
		
		Для Инд = 1 По НайденныеСтроки.Количество() Цикл
			Строка["ВремяНачалаОсобое"+Инд] = НайденныеСтроки[Инд-1].ВремяНачала;
			Строка["ВремяОкончанияОсобое"+Инд] = НайденныеСтроки[Инд-1].ВремяОкончания;
		КонецЦикла;	
	КонецЦикла;	
	
	Если ОсобоеРабочееВремя.Количество() = 0 Тогда 
		Элементы.ГруппаВремя.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ГруппаВремя.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьРабочееВремя(Отказ);
	
	ПроверитьОсобоеРабочееВремя(Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.РабочееВремя.Очистить();
	Для Инд = 1 по 4 Цикл
		Если ЗначениеЗаполнено(ЭтотОбъект["ВремяОкончания"+Инд]) Тогда 
			НоваяСтрока = Объект.РабочееВремя.Добавить();
			НоваяСтрока.ВремяНачала = ЭтотОбъект["ВремяНачала"+Инд];
			НоваяСтрока.ВремяОкончания = ЭтотОбъект["ВремяОкончания"+Инд];
		КонецЕсли;
	КонецЦикла;	
	
	Объект.ОсобоеРабочееВремя.Очистить();
	Для Каждого Строка Из ОсобоеРабочееВремя Цикл
		Для Инд = 1 По 4 Цикл
			Если ЗначениеЗаполнено(Строка["ВремяОкончанияОсобое"+Инд]) Тогда 
				НоваяСтрока = Объект.ОсобоеРабочееВремя.Добавить();
				НоваяСтрока.РабочийДень = Строка.РабочийДень;
				НоваяСтрока.ВремяНачала = Строка["ВремяНачалаОсобое"+Инд];
				НоваяСтрока.ВремяОкончания = Строка["ВремяОкончанияОсобое"+Инд];
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ОсобоеРабочееВремяПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ОсобоеРабочееВремя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Элементы.ГруппаВремя.ТолькоПросмотр = Истина;
		Возврат;
	Иначе	
		Элементы.ГруппаВремя.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
	Для Инд = 1 По 4 Цикл
		ЭтотОбъект["ВремяНачалаОсобое"+Инд] = ТекущиеДанные["ВремяНачалаОсобое"+Инд];
		ЭтотОбъект["ВремяОкончанияОсобое"+Инд] = ТекущиеДанные["ВремяОкончанияОсобое"+Инд];
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура ВремяОсобоеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОсобоеРабочееВремя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Для Инд = 1 По 4 Цикл
		ТекущиеДанные["ВремяНачалаОсобое"+Инд] = ЭтотОбъект["ВремяНачалаОсобое"+Инд];
		ТекущиеДанные["ВремяОкончанияОсобое"+Инд] = ЭтотОбъект["ВремяОкончанияОсобое"+Инд];
	КонецЦикла;	
	
КонецПроцедуры


