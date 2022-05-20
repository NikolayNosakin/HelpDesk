﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИсточникСписка = Параметры.Источник;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
		"Источник",
		Параметры.Источник);
	
	СпособУказанияВремени = ХранилищеОбщихНастроек.Загрузить("НастройкиУчетаВремени", "СпособУказанияВремени");
	Если Не ЗначениеЗаполнено(СпособУказанияВремени) Тогда
		СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность;
	КонецЕсли;	
	
	//Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность Тогда 
	//	Элементы.Длительность.Видимость = Истина;
	//	Элементы.Начало.Видимость = Ложь;
	//	Элементы.Окончание.Видимость = Ложь;
	//Иначе
	//	Элементы.Длительность.Видимость = Ложь;
	//	Элементы.Начало.Видимость = Истина;
	//	Элементы.Окончание.Видимость = Истина;
	//КонецЕсли;		
	
	Если ТипЗнч(Параметры.Источник) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
		ИсполнительЗадачи = Параметры.Источник.Исполнитель;
		Если ЗначениеЗаполнено(ИсполнительЗадачи) Тогда 
			Если ИсполнительЗадачи <> Пользователи.ТекущийПользователь() Тогда 
				Элементы.Список.ИзменятьСоставСтрок = Ложь;
				Элементы.Список.ТолькоПросмотр = Истина;
			КонецЕсли;	
		Иначе	
			ИсполнителиРоли = БизнесПроцессыИЗадачиСервер.ИсполнителиРоли(
					Параметры.Источник.РольИсполнителя,
					Параметры.Источник.ОсновнойОбъектАдресации,
					Параметры.Источник.ДополнительныйОбъектАдресации);
					
			Если ИсполнителиРоли.Найти(Пользователи.ТекущийПользователь()) = Неопределено Тогда 		
				Элементы.Список.ИзменятьСоставСтрок = Ложь;
				Элементы.Список.ТолькоПросмотр = Истина;
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ЕжедневныйОтчет) Тогда 
		Отказ = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Нельзя удалить запись, так как она отражена в ежедневном отчете %1'"),
			Строка(ТекущиеДанные.ЕжедневныйОтчет));
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	Оповестить("Изменение_ФактическиеТрудозатратыЗадачи", ИсточникСписка, ЭтотОбъект);
	Оповестить("Изменение_ФактическиеТрудозатратыПроектнойЗадачи", Неопределено, ЭтотОбъект);
	
КонецПроцедуры
