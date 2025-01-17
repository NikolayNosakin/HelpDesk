﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Формирует временную таблицу старых пользователей для обработчика ПриЗаписи.
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Ссылка = Справочники.ГруппыДоступа.Администраторы Тогда
		// Всегда предопределенный профиль Администратор
		Профиль = Справочники.ПрофилиГруппДоступа.Администратор;
		// Не может быть персональной группой доступа
		Пользователь = Неопределено;
		// Только обычные пользователи
		ТипПользователей = Справочники.Пользователи.ПустаяСсылка();
		// Изменение разрешено только полноправному пользователю
		Если НЕ ПривилегированныйРежим()
		   И НЕ УправлениеДоступом.ЕстьРоль("ПолныеПрава") Тогда
			
			ВызватьИсключение(НСтр("ru = 'Предопределенную группу доступа Администраторы
			                             |можно изменять, либо в привилегированном режиме,
			                             |либо при наличии роли ""Полные права"".'"));
		КонецЕсли;
		// Нельзя устанавливать предопределенный профиль Администратор произвольной группе доступа
	ИначеЕсли Профиль = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		ВызватьИсключение(НСтр("ru = 'Предопределенный профиль Администратор может быть только
		                             |у предопределенной группы доступа Администраторы.'"));
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
			
			Если ЗначениеЗаполнено(Ссылка) Тогда
				СтараяТаблицаПользователи = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Пользователи");
				СтарыеУчастникиГруппыДоступа = СтараяТаблицаПользователи.Выгрузить().ВыгрузитьКолонку("Пользователь");
			Иначе
				СтарыеУчастникиГруппыДоступа = Новый Массив;
			КонецЕсли;
			
			ДополнительныеСвойства.Вставить("СтарыеУчастникиГруппыДоступа", СтарыеУчастникиГруппыДоступа);
		КонецЕсли;
		
		// Автоматическая установка реквизитов для персональной группы доступа
		Если ЗначениеЗаполнено(Пользователь) Тогда
			Родитель         = УправлениеДоступомСлужебный.РодительПерсональныхГруппДоступа();
			ТипПользователей = Неопределено;
		Иначе
			Пользователь = Неопределено;
			Если Родитель = УправлениеДоступомСлужебный.РодительПерсональныхГруппДоступа(Истина) Тогда
				Родитель = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		// При снятии пометки удаления снятие пометки удаления с профиля групп доступа этой группы
		Если НЕ ПометкаУдаления
		   И ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка,  "ПометкаУдаления") = Истина
		   И ОбщегоНазначения.ПолучитьЗначениеРеквизита(Профиль, "ПометкаУдаления") = Истина Тогда
			ЗаблокироватьДанныеДляРедактирования(Профиль);
			ПрофильОбъект = Профиль.ПолучитьОбъект();
			ПрофильОбъект.ПометкаУдаления = Ложь;
			ПрофильОбъект.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обновляет:
// - роли добавленных, оставшихся и удаленных пользователей;
// - РегистрСведений.ТаблицыГруппДоступа;
// - РегистрСведений.ЗначенияГруппДоступа.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей") Тогда
			
			ОбновитьРолиПользователейПриИзмененииГруппыДоступа(
				Ссылка, ДополнительныеСвойства.СтарыеУчастникиГруппыДоступа);
		КонецЕсли;
		
		УправлениеДоступомСлужебный.ОбновитьТаблицыГруппДоступа(Ссылка);
		
		УправлениеДоступомСлужебный.ЗаписатьЗначенияГруппДоступа(Ссылка);
		
		УправлениеДоступомСлужебный.ОбновитьПодчиненныхПользователейГруппДоступа();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
			ПроверяемыеРеквизиты, ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Процедура ОбновитьРолиПользователейПриИзмененииГруппыДоступа(ГруппаДоступа,
                                                             СтарыеУчастникиГруппыДоступа) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Обновление ролей для добавленных, оставшихся и удаленных пользователей.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГруппаДоступа", ГруппаДоступа);
	Запрос.УстановитьПараметр("СтарыеУчастникиГруппыДоступа", СтарыеУчастникиГруппыДоступа);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПользователиИГруппыПользователей.ЗначениеДоступа КАК Пользователь
	|ИЗ
	|	РегистрСведений.ГруппыЗначенийДоступа КАК ПользователиИГруппыПользователей
	|ГДЕ
	|	ПользователиИГруппыПользователей.ВидДоступа = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПустаяСсылка)
	|	И ПользователиИГруппыПользователей.ТолькоВидДоступа = ЛОЖЬ
	|	И ПользователиИГруппыПользователей.ГруппаДоступа В(&СтарыеУчастникиГруппыДоступа)
	|	И (ТИПЗНАЧЕНИЯ(ПользователиИГруппыПользователей.ЗначениеДоступа) = ТИП(Справочник.Пользователи)
	|			ИЛИ ТИПЗНАЧЕНИЯ(ПользователиИГруппыПользователей.ЗначениеДоступа) = ТИП(Справочник.ВнешниеПользователи))
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПользователиИГруппыПользователей.ЗначениеДоступа
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГруппыЗначенийДоступа КАК ПользователиИГруппыПользователей
	|		ПО (ПользователиИГруппыПользователей.ВидДоступа = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПустаяСсылка))
	|			И (ПользователиИГруппыПользователей.ТолькоВидДоступа = ЛОЖЬ)
	|			И ГруппыДоступаПользователи.Пользователь = ПользователиИГруппыПользователей.ГруппаДоступа
	|			И (ГруппыДоступаПользователи.Ссылка = &ГруппаДоступа)
	|			И (ТИПЗНАЧЕНИЯ(ПользователиИГруппыПользователей.ЗначениеДоступа) = ТИП(Справочник.Пользователи)
	|				ИЛИ ТИПЗНАЧЕНИЯ(ПользователиИГруппыПользователей.ЗначениеДоступа) = ТИП(Справочник.ВнешниеПользователи))";
	СтарыеИНовыеПользователи = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
	//Если ГруппаДоступа = Справочники.ГруппыДоступа.Администраторы Тогда
		// Добавление пользователей, связанных с пользователямиИБ, имеющих роль ПолныеПрава
		Для каждого ПользовательИБ Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
			Если ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
				Пользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
				Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
					Пользователь = Справочники.ВнешниеПользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
				КонецЕсли;
				Если ЗначениеЗаполнено(Пользователь)
				   И СтарыеИНовыеПользователи.Найти(Пользователь) = Неопределено Тогда
					СтарыеИНовыеПользователи.Добавить(Пользователь);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	//КонецЕсли;
	
	УправлениеДоступом.ОбновитьРолиПользователей(СтарыеИНовыеПользователи);
	
КонецПроцедуры

