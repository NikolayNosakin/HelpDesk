﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиПользователя.ЗагрузитьЗначения(ЗаполнениеОбъектовCRM.ПолучитьСотрудниковПользователя());
	
	Если ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		
			// Ограничение доступа:
			// Редактирование разрешено владельцу календаря 
			// Просмотр разрешен сотруднику, указанному в ТЧ "Доступ"
			
			ПравоРедактирования = СотрудникиПользователя.НайтиПоЗначению(Объект.ВладелецКалендаря) <> Неопределено;
			ПравоПросмотра = ПравоРедактирования;
			Отбор = Новый Структура("Сотрудник");
			Для Каждого СотрудникПользователя Из СотрудникиПользователя Цикл
				Отбор.Сотрудник = СотрудникПользователя;
				НайденныеСтроки = Объект.Доступ.НайтиСтроки(Отбор);
				Если НайденныеСтроки.Количество() > 0 Тогда
					ПравоПросмотра = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если Не ПравоПросмотра Тогда
				ВызватьИсключение НСтр("ru='Недостаточно прав для просмотра календаря.';uk='Недостатньо прав для перегляду календаря.'");
			КонецЕсли;
			
			ТолькоПросмотр = Не ПравоРедактирования;
			
		КонецЕсли;
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура;
	ПараметрОповещения.Вставить("Календарь", Объект.Ссылка);
	ПараметрОповещения.Вставить("Наименование", Объект.Наименование);
	ПараметрОповещения.Вставить("ВладелецКалендаря", Объект.ВладелецКалендаря);
	
	Оповестить("Запись_КалендарьСотрудника", ПараметрОповещения, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВладелецКалендаряПриИзменении(Элемент)
	
	Если СотрудникиПользователя.НайтиПоЗначению(Объект.ВладелецКалендаря) = Неопределено Тогда
		
		ЕстьДоступ = Ложь;
		Отбор = Новый Структура("Сотрудник");
		
		Для Каждого КлючИЗначение Из СотрудникиПользователя Цикл
			Отбор.Сотрудник = КлючИЗначение.Значение;
			Если Объект.Доступ.НайтиСтроки(Отбор).Количество() > 0 Тогда
				ЕстьДоступ = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЕстьДоступ Тогда
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеСотрудникаПредложено", ЭтотОбъект);
			
			ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
			ПараметрыВопроса.КнопкаПоУмолчанию = КодВозвратаДиалога.Да;
			ПараметрыВопроса.Заголовок = НСтр("ru='Изменение доступа';uk='Зміна доступу'");
			ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
			
			ТекстВопроса = СтрШаблон(НСтр("ru='Текущий сотрудник %1 не имеет доступа к календарю."
"Разрешить доступ?';uk='Поточний співробітник %1 не має доступу до календаря."
"Дозволити доступ?'"), Строка(СотрудникиПользователя));
			
			СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, ПараметрыВопроса);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавлениеСотрудникаПредложено(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатВопроса) = Тип("Структура")
		И РезультатВопроса.Свойство("Значение")
		И РезультатВопроса.Значение = КодВозвратаДиалога.Да Тогда
		
		Для Каждого КлючИЗначение Из СотрудникиПользователя Цикл
			НоваяСтрока = Объект.Доступ.Добавить();
			НоваяСтрока.Сотрудник = КлючИЗначение.Значение;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
