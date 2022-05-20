﻿
Перем СтарыйРодитель; // Значение родителя группы до изменения для использования
                      // в обработчике события ПриЗаписи.

Перем СтарыйСоставГруппыПользователей; // Состав пользователей группы пользователей
                                       // до изменения для использования в обработчике
                                       // события ПриЗаписи.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверенныеРеквизитыОбъекта = Новый Массив;
	Ошибки = Неопределено;
	
	// Проверка использования родителя.
	Если Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Родитель",
			НСтр("ru = 'Предопределенная группа ""Все пользователи"" не может быть родителем.'"));
	КонецЕсли;
	
	// Проверка незаполненных и повторяющихся пользователей.
	ПроверенныеРеквизитыОбъекта.Добавить("Состав.Пользователь");
	
	Для каждого ТекущаяСтрока Из Состав Цикл;
		НомерСтроки = Состав.Индекс(ТекущаяСтрока);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Пользователь) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].Пользователь",
				НСтр("ru = 'Пользователь не выбран.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Пользователь в строке %1 не выбран.'"));
			Продолжить;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		НайденныеЗначения = Состав.НайтиСтроки(Новый Структура("Пользователь", ТекущаяСтрока.Пользователь));
		Если НайденныеЗначения.Количество() > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].Пользователь",
				НСтр("ru = 'Пользователь повторяется.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Пользователь в строке %1 повторяется.'"));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
	
КонецПроцедуры

// Блокирует недопустимые действия с предопределенной группой "Все пользователи".
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		Если НЕ Родитель.Пустая() Тогда
			ВызватьИсключение
				НСтр("ru = 'Предопределенная группа ""Все пользователи""
				           |может быть только в корне.'");
		КонецЕсли;
		Если Состав.Количество() > 0 Тогда
			ВызватьИсключение
				НСтр("ru = 'Добавление пользователей в группу
				           |""Все пользователи"" не поддерживается.'");
		КонецЕсли;
	Иначе
		Если Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
			ВызватьИсключение
				НСтр("ru = 'Предопределенная группа ""Все пользователи""
				           |не может быть родителем.'");
		КонецЕсли;
		
		СтарыйРодитель = ?(
			Ссылка.Пустая(),
			Неопределено,
			ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Родитель"));
			
		Если ЗначениеЗаполнено(Ссылка)
		   И Ссылка <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
			
			СтарыйСоставГруппыПользователей =
				ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Состав").Выгрузить();
		КонецЕсли;
	КонецЕсли;
	
	СоздаватьПользователяПриемника = ?(ПометкаУдаления,Ложь,СоздаватьПриемника);
	ЗарегистрироватьПриемникаЗадач(СоздаватьПользователяПриемника);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		Выборка = Справочники.ГруппыПользователей.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПользователиСлужебный.ОбновитьСоставыГруппПользователей(Выборка.Ссылка);
		КонецЦикла;
	Иначе
		ИзмененияСостава = ПользователиСлужебный.РазличияЗначенийКолонки(
			"Пользователь",
			Состав.Выгрузить(),
			СтарыйСоставГруппыПользователей);
		
		ПользователиСлужебный.ОбновитьСоставыГруппПользователей(Ссылка, ИзмененияСостава);
		
		Если ЗначениеЗаполнено(СтарыйРодитель) И СтарыйРодитель <> Родитель Тогда
			ПользователиСлужебный.ОбновитьСоставыГруппПользователей(СтарыйРодитель);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьПриемникаЗадач(СоздаватьПользователяПриемника)
	Если СоздаватьПользователяПриемника Тогда
		Если ЗначениеЗаполнено(ПриемникЗадач) Тогда
			Спр = ПриемникЗадач.Ссылка.ПолучитьОбъект();
		Иначе
			Спр = Справочники.Пользователи.СоздатьЭлемент();
			Спр.Служебный = Истина;
		КонецЕсли;	
		
		Если Не Спр.Служебный Тогда
			Спр = Справочники.Пользователи.СоздатьЭлемент();
			Спр.Служебный = Истина;
		КонецЕсли;
		Спр.Наименование = Наименование;
		Спр.ПометкаУдаления = Ложь;
		Спр.Записать();
		ПриемникЗадач = Спр.Ссылка;
	Иначе
		Если ЗначениеЗаполнено(ПриемникЗадач) Тогда
			Спр = ПриемникЗадач.Ссылка.ПолучитьОбъект();
			Спр.УстановитьПометкуУдаления(Истина,Ложь);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры